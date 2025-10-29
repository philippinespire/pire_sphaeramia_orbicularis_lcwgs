##Estimating Ne

#### INITIALIZE ####
# set working directory

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#### PACKAGES ####
packages_used <- 
  c("tidyverse",
    "boot",
    "R.utils",
    "data.table",
    "lubridate"
  )

packages_to_install <- 
  packages_used[!packages_used %in% installed.packages()[,1]]

if (length(packages_to_install) > 0) {
  install.packages(packages_to_install, 
                   Ncpus = Sys.getenv("NUMBER_OF_PROCESSORS") - 1)
}

lapply(packages_used, 
       require, 
       character.only = TRUE)


#### READ IN DATA ####
# Read in allele frequency data

# MAFS (Minor Allele Frequencies)
apnd_mafs <- fread("ACeb_sites_notrans_subset_neutral_fdr.mafs.gz", header=TRUE) # 13680 Neutral SNPs
cpnd_mafs <- fread("CPnd_sites_notrans_subset_neutral_fdr.mafs.gz", header=TRUE) # 13680 Neutral SNPs

#### WRANGLE DATA ####
# Merge population comparisons
# Set Albatross to population 1
setnames(apnd_mafs, c("knownEM", 'nInd'), c("freq1", 'nInd1'))
# Set Contemporary to population 2
setnames(cpnd_mafs, c("knownEM", 'nInd'), c("freq2", 'nInd2'))

# merge by chromo & position & major & minor & ref & anc
all_mafs <- merge(apnd_mafs, cpnd_mafs, by = c("chromo", "position", "major", "minor", "ref", "anc"))
# makes sure the merged dataframe has the same number of observations

# remove NAs from freq columns
all_mafs <- all_mafs[!is.na(freq1) & !is.na(freq2)]

# Find where all populations (1 location, 2 populations) overlap with maf>0.001
# set minimum minor allele frequency filter. default is 0.001. 
minmaf <- 0.001

# filter by minmaf
all_mafs_001 <- subset(all_mafs, freq1 > minmaf & freq2 > minmaf)
# 6725 SNPs remaining after minmaf

### Jorde & Ryman/NeEstimator approach
# Jorde & Ryman 2007

# Ne in # diploid individuals
# based on NeEstimator manual v2.1

jrNe2 <- function(maf1, maf2, n1, n2, gen){
  Fsnum <- (maf1-maf2)^2 + (1-maf1 - (1-maf2))^2 # the numerator, summing across the two alleles

  z <- (maf1+maf2)/2 # for the first allele
  z2 <- ((1-maf1)+(1-maf2))/2 # z for the 2nd allele
  Fsdenom <- z*(1-z) + z2*(1-z2) # the denominator of Fs, summing across the 2 alleles
  Fs <- sum(Fsnum)/sum(Fsdenom) # from NeEstimator calculations manual

  sl <- 2/(1/n1 + 1/n2) # harmonic mean sample size for each locus, in # individuals

  S <- length(maf1)*2/sum(2/sl) # harmonic mean sample size in # individuals, across loci and across both times. 2 alleles. Eq. 4.10 in NeEstimator v2.1 manual
  S2 <- length(maf2)*2/sum(2/n2) # harmonic mean sample size of 2nd sample in # individuals, across loci. all 2 alleles. See NeEstimator v2.1 below Eq. 4.13
  Fsprime <- (Fs*(1 - 1/(4*S)) - 1/S)/((1 + Fs/4)*(1 - 1/(2*S2))) # Eq. 4.13 in NeEstimator v2.1
  return(gen/(2*Fsprime)) # calculation of Ne in # diploid individuals
}

length(unique(all_mafs_001$nInd1))
# 22
length(unique(all_mafs_001$nInd2))
# 26
# contemporary collected in 2021. albatross collected in 1909. So 112 years.

# GenTime as estimated by FishLife is 2.509738 based on family-level estimate
# However, Fitz et al 2025 (Taeniamia zosterophora) and Baldisimo et al 2026 (Sphaeramia nematoptera) used a GenTime = 1.
# They cited Kume et al 2003: Variation in life history parameters of the cardinalfish Apogon lineatus.
# Jem  used neutral SNPs to calculate Ne for S. nematoptera between 3 sites which ranged from 1514, 1573, 1578. 
# Ne calculated from all SNPs was 140, 151, 196. Neutral Ne was ~4x higher than for all SNPs.
# Kyra used neutral SNPs to calculate Ne for T. zosterophora at 2230 from Mantatao (Cebu Strait) and 2311 from Palawan. 
# Ne calculated from all SNPs was 1022. Neutral SNPs Ne ~2.25x greater than All SNPs Ne. 
# Ne calculated from all SNPs is what the script selection.R uses to determine the list of neutral SNPs. 
GenTime = 2.509738

## Generations (gen) based on sampling years 
a_date <- as.Date("1908-04-07") # 4/7/1908
c_date <- as.Date("2021-11-06") # 11/6/2021

# Calculate exact number of years
years <- as.numeric(difftime(c_date, a_date, units = "days")) / 365.25  # use 365.25 for leap years
years <- round(years, 1)
years2 <- round(years/2,1)
years3 <- round(years/3,1)

Generations = years/GenTime
# 45.0246

# gen = number of generations
all_mafs_001[, jrNe2(freq1, freq2, nInd1, nInd2, Generations)] # 177.8319 w/ GenTime of 2.509738 years and Neutral SNPs. 58 for all SNPs. 3 times higher than neutral SNPs. 
all_mafs_001[, jrNe2(freq1, freq2, nInd1, nInd2, years)]       # 446.3114 w/ GenTime of 1 year
all_mafs_001[, jrNe2(freq1, freq2, nInd1, nInd2, years2)]      # 224.3406 w/ GenTime of 2 years
all_mafs_001[, jrNe2(freq1, freq2, nInd1, nInd2, years3)]      # 149.6920 w/ GenTime of 3 years (37.33)


#Bootstrap over loci to get CIs

## Jorde & Ryman Ne estimator, for boot() to use

jrNe2boot <- function(data, gen, indices){
  maf1 <- data$freq1[indices]
  maf2 <- data$freq2[indices]
  n1 <- data$nInd1[indices]
  n2 <- data$nInd2[indices]

  Fsnum <- (maf1-maf2)^2 + (1-maf1 - (1-maf2))^2 # the numerator, summing across the two alleles

  z <- (maf1+maf2)/2 # for the first allele
  z2 <- ((1-maf1)+(1-maf2))/2 # z for the 2nd allele
  Fsdenom <- z*(1-z) + z2*(1-z2) # the denominator of Fs, summing across the 2 alleles
  Fs <- sum(Fsnum)/sum(Fsdenom) # from NeEstimator calculations manual

  sl <- 2/(1/n1 + 1/n2) # harmonic mean sample size for each locus, in # individuals

  S <- length(maf1)*2/sum(2/sl) # harmonic mean sample size in # individuals, across loci and across both times. 2 alleles. Eq. 4.10 in NeEstimator v2.1 manual
  S2 <- length(maf2)*2/sum(2/n2) # harmonic mean sample size of 2nd sample in # individuals, across loci. all 2 alleles. See NeEstimator v2.1 below Eq. 4.13
  Fsprime <- (Fs*(1 - 1/(4*S)) - 1/S)/((1 + Fs/4)*(1 - 1/(2*S2))) # Eq. 4.13 in NeEstimator v2.1
  Ne <- gen/(2*Fsprime)
  if(Ne < 0) Ne <- Inf
  return(Ne) # calculation of Ne in # diploid individuals
}



################################
#### Calculate Ne @ GenTime #### 
################################
boot_pnd <- boot(data = all_mafs_001, statistic = jrNe2boot, R = 1000, gen = Generations) # GenTime = 2.509738 years

# Ne @ t0 = 177.8319 at GenTime = 2.509738 years
print(boot_pnd)
# original    bias    std. error
# t1* 177.8319 0.2502484    5.249172

# 95% Confidence Interval: (168.3, 189.3) 
boot.ci(boot_pnd, type='perc') 

# Bias: -0.2502484
bias <- boot_pnd$t0 - mean(boot_pnd$t)
print(bias)



################################
#### Calculate Ne @ GenTime #### 
################################
boot_pnd_year <- boot(data = all_mafs_001, statistic = jrNe2boot, R = 1000, gen = years) # GenTime = 1 year

# Ne @ t0 = 448.6812 at GenTime = 1 year
print(boot_pnd_year)
# original    bias    std. error
# t1* 448.6812 0.1717889    13.72171

# 95% Confidence Interval: (422.3, 477.2) 
boot.ci(boot_pnd_year, type='perc') 

# Bias: -0.4573869
bias <- boot_pnd_year$t0 - mean(boot_pnd_year$t)
print(bias)
