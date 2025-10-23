##Analyzing and Plotting genetic diversity metrics

#### INITIALIZE ####
# set working directory

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#### PACKAGES ####
packages_used <- 
  c("tidyverse",
    "cowplot",
    "boot",
    "Cairo",
    "dplyr"
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

options(bitmapType = "cairo")  # Set Cairo as the default graphics device

# install packages
# install.packages("tidyverse")
# install.packages("cowplot")
# install.packages("boot")
# install.packages("Cairo")

# load libraries
# library(tidyverse)
# library(cowplot)
# library(boot)
# library(Cairo)


#### READ IN DATA ####
##Load in theta outputs by population (abol, amta, cbol, cmta)
apnd_thetas_notrans <- read_table("ACeb_sites_notrans_subset.thetas.idx.pestPG")
cpnd_thetas_notrans <- read_table("CPnd_sites_notrans_subset.thetas.idx.pestPG")

##Import depth information
angsd_depth_notrans <- read_table("combined_sites_notrans_subset.pos.gz")
#This is by site, we need it by chromosome to match with the theta calculations

# Read the BAM list file
bamlist <- read.table("bam_list_all_subset.txt")
# Ensure it's treated as a vector
bamlist <- bamlist$V1  # Assuming the BAM file names are in the first column


#### USER DEFINED VARIABLES ####
# change your spp_code (e.g. Sob, Aen, Pbb)
spp_code="Sor"

# location longform
site_long = "Pandanon"

# change your site_A_code to the 3 letter site code of the Albatross (historical) population (e.g. Pnd, Gal, Mvi)
site_A_code="Ceb"

# change your site_C_code to the 3 letter site code of the contemporary (modern) population (e.g. Pnd, Gal, Mvi)
site_C_code="Pnd"


#### VARIABLES FROM USER INPUT  ####

# era site pattern (e.g. APnd, CPal). do not change. 
spp_era_A_site_pattern=paste0(spp_code,"A",site_A_code)
spp_era_C_site_pattern=paste0(spp_code,"C",site_C_code)


#### SAMPLE SIZE ####

# Count the number of albatross and contemporary individuals based on the patterns
albatross_n <- as.numeric(sum(grepl(paste0(spp_era_A_site_pattern, ".*\\.bam$"), bamlist)))  # Count lines matching albatross pattern
contemporary_n <- as.numeric(sum(grepl(paste0(spp_era_C_site_pattern, ".*\\.bam$"), bamlist)))  # Count lines matching contemporary pattern
albatross_n_plus_1 <- as.numeric(albatross_n + 1)
total_n <- as.numeric(sum(grepl(paste0(".*\\.bam$"), bamlist)))  # Count all lines matching *.bam

# Display the counts
cat("Number of Albatross (historical) BAM files:", albatross_n, "\n")
cat("Number of Contemporary (modern) BAM files:", contemporary_n, "\n")
cat("Total number of BAM files:", total_n, "\n")


#### WRANGLE DATA ####

#Add a column for site to each dataset
apnd_thetas_notrans$Site <- "APnd"
cpnd_thetas_notrans$Site <- "CPnd"

#Add a column for era to each dataset
apnd_thetas_notrans$Era <- "Historical"
cpnd_thetas_notrans$Era <- "Modern"

#Merge datasets for plotting
angsd_thetas_notrans <- rbind(apnd_thetas_notrans, cpnd_thetas_notrans)

#Take the average of total Depth for all the sites within a chromosome
angsd_avgdepth_notrans <- angsd_depth_notrans %>% group_by(chr) %>% summarise(avg_Depth = mean(totDepth))
#This gets us average total depth (summed across individuals) for each chromosome

#Add a column with average depth by individual
angsd_avgdepth_notrans$ind_depth <- angsd_avgdepth_notrans$avg_Depth/total_n

#Rename Chr column to match angsd_thetas dataframe
names(angsd_avgdepth_notrans)[1] <- "Chr"

#Merge with angsd_thetas dataframe
angsd_thetas_depth_notrans <- merge(angsd_thetas_notrans, angsd_avgdepth_notrans, by="Chr")

#Add a column with theta by site (theta for the contig divided by number of sites on the contig)
angsd_thetas_depth_notrans$tW_bysite <- angsd_thetas_depth_notrans$tW/angsd_thetas_depth_notrans$nSites

#Add a column with pi (nucleotide diversity) by site (theta for the contig divided by number of sites on the contig)
angsd_thetas_depth_notrans$tP_bysite <- angsd_thetas_depth_notrans$tP/angsd_thetas_depth_notrans$nSites

#Reorder for plotting
angsd_thetas_depth_notrans$Site <- factor(angsd_thetas_depth_notrans$Site, levels=c("APnd", "CPnd"))

#Theta by Depth plot
# Waterson's theta estimates
plot_theta_depth <- angsd_thetas_depth_notrans %>%
  ggplot(aes(x=ind_depth, y=tW_bysite, color=Era), show.legend=FALSE) +
  labs(x="Mean Depth Per Individual",y="Theta") +
  theme_classic() +
  theme(legend.position="none") +
  geom_point(size=1.5, alpha=0.5) +
  geom_smooth() +
  scale_color_manual(values = c("#00BFC4", "#F8766D")) +
  scale_y_continuous(breaks=c(0.05, 0.07, 0.9, 0.11)) +
  ylim(0.00, 0.25)
print(plot_theta_depth)

# outFile pattern
outFile_plot_theta_depth <- paste0("plots/", spp_code, "_plot_theta_depth_subset_FORMAT", ".png")  

# Save the plot to a file
ggsave(filename = outFile_plot_theta_depth, plot = plot_theta_depth, width = 2.15, height = 2.5)


# nucleotide diversity (pi) estimates
plot_pi_depth <- angsd_thetas_depth_notrans %>%
  ggplot(aes(x=ind_depth, y=tP_bysite, color=Era)) +
  labs(x="Mean Depth Per Individual",y="Nucleotide Diversity") +
  theme_classic() +
  theme(legend.position="none") +
  geom_point(size=1.5, alpha=0.5) +
  geom_smooth() +
  scale_color_manual(values = c("#00BFC4", "#F8766D")) +
  ylim(-0.05, 0.35)
print(plot_pi_depth)

# outFile pattern
outFile_plot_pi_depth <- paste0("plots/", spp_code, "_plot_pi_depth_subset_FORMAT", ".png")  

# Save the plot to a file
ggsave(filename = outFile_plot_pi_depth, plot = plot_pi_depth, width = 2.15, height = 2.5)


#Subset to depth 3-6X

angsd_thetas_depth_notrans_36 <- subset(angsd_thetas_depth_notrans, ind_depth >= 3 & ind_depth<=6)

angsd_thetas_depth_notrans_36 %>%
  ggplot(aes(x=ind_depth, y=tW_bysite, color=Era)) +
  labs(x="Average Individual Depth",y="Theta") +
  theme_bw() +
  geom_point(size=1.5, alpha=0.5) +
  geom_smooth() +
  scale_color_manual(values = c("#00BFC4", "#F8766D"))

angsd_thetas_depth_notrans_36_bol <- subset(angsd_thetas_depth_notrans_36, Site=="ABol" | Site=="CBol")
angsd_thetas_depth_notrans_36_mta <- subset(angsd_thetas_depth_notrans_36, Site=="AMta" | Site=="CMta")

bol_36_plot <- angsd_thetas_depth_notrans_36_bol %>%
  ggplot(aes(x=ind_depth, y=tW_bysite, color=Era)) +
  labs(x="Average Individual Depth",y="Theta") +
  theme_bw() +
  theme(legend.position="none") +
  geom_point(size=1.5, alpha=0.5) +
  geom_smooth() +
  scale_color_manual(values = c("#00BFC4", "#F8766D")) +
  scale_y_continuous(breaks=c(0.05, 0.075, 0.1, 0.125))

mta_36_plot <- angsd_thetas_depth_notrans_36_mta %>%
  ggplot(aes(x=ind_depth, y=tW_bysite, color=Era)) +
  labs(x="Average Individual Depth",y="Theta") +
  theme_bw() +
  theme(legend.position="none") +
  geom_point(size=1.5, alpha=0.5) +
  geom_smooth() +
  scale_color_manual(values = c("#00BFC4", "#F8766D")) +
  scale_y_continuous(breaks=c(0.05, 0.075, 0.1, 0.125))

plot_grid(bol_plot, mta_plot, bol_36_plot, mta_36_plot, ncol=2,
          labels=c('A', 'B', 'C', 'D',
                    vjust=-1.5))

plot_grid(bol_plot, mta_plot,
          labels=c('A', 'B'))

plot_grid(bol_36_plot, mta_36_plot,
          labels=c('A', 'B'))


#Subset by population
apnd_notrans <- subset(angsd_thetas_depth_notrans, Era=="Historical")
cpnd_notrans <- subset(angsd_thetas_depth_notrans, Era=="Modern")

# filter out any NaN
apnd_notrans <- apnd_notrans %>%
  filter(!is.na(tP_bysite) & !is.na(tW_bysite))
cpnd_notrans <- cpnd_notrans %>%
  filter(!is.na(tP_bysite) & !is.na(tW_bysite))

# Assuming 'Chr' as a common identifier column
apnd_notrans <- apnd_notrans[apnd_notrans$Chr %in% cpnd_notrans$Chr, ]
cpnd_notrans <- cpnd_notrans[cpnd_notrans$Chr %in% apnd_notrans$Chr, ]


#Test to see if theta is normally distributed
hist(apnd_notrans$tP_bysite)
hist(cpnd_notrans$tP_bysite)
#Looks right skewed

##Paired t-test

t.test(apnd_notrans$tP_bysite, cpnd_notrans$tP_bysite, paired=TRUE)
# Paired t-test
# 
# data:  apnd_notrans$tP_bysite and cpnd_notrans$tP_bysite
# t = -6.3829, df = 98, p-value = 5.801e-09
# alternative hypothesis: true mean difference is not equal to 0
# 95 percent confidence interval:
#   -0.03053312 -0.01605012
# sample estimates:
#   mean difference 
# -0.02329162 

#nonparametric wilcox test
wilcox.test(apnd_notrans$tP_bysite, cpnd_notrans$tP_bysite, paired = TRUE)
# V = 764, p-value = 2.37e-09
# alternative hypothesis: true location shift is not equal to 0


#Bootstrapping of pi
x = as.vector(apnd_notrans$tP_bysite)

samplemean <- function(x, d) {
  return(mean(x[d]))
}

apnd_boot = boot(x, samplemean, R=1000)

apnd_boot
plot(apnd_boot)
# Bootstrap Statistics :
# original        bias    std. error
# t1* 0.05654977 -7.179638e-05 0.003244628

boot.ci(boot.out=apnd_boot, type="norm") #95%   ( 0.0503,  0.0630 ) 
boot.ci(boot.out=apnd_boot, type="bca") #95%   ( 0.0516,  0.0655 )

x = as.vector(cpnd_notrans$tP_bysite)
cpnd_boot = boot(x, samplemean, R=1000)

cpnd_boot
plot(cpnd_boot)
# Bootstrap Statistics :
# original        bias    std. error
# t1* 0.07938462 -3.673295e-06 0.004763847

boot.ci(boot.out=cpnd_boot, type="norm") #95%   ( 0.0701,  0.0887 )
boot.ci(boot.out=cpnd_boot, type="bca") #95%   ( 0.0715,  0.0908 )

##Create data frame with means and 95% CI for plotting
population <- c("APnd","CPnd")
location <- c("Pandanon Island", "Pandanon Island")
mean_pi <- c(0.05654977, 0.07938462)
se_pi <- c(0.003244628, 0.004763847)
lower_95_pi <- c(0.0503, 0.0701)
upper_95_pi <- c(0.0630, 0.0887)
era <- c("Historical", "Modern")

theta_plotting_pi <- data.frame(era, location, mean_pi, se_pi)
theta_plotting_pi$location <- factor(theta_plotting_pi$location, levels=c("Pandanon Island"))
theta_plotting_pi$era <- factor(theta_plotting_pi$era, levels=c("Historical", "Modern"))

plot_pi <- theta_plotting_pi %>%
  ggplot(aes(x=era, y=mean_pi, color=era)) +
  labs(y="Mean Pi") +
  theme_classic() +
  theme(legend.position="none") +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=mean_pi-1.96*se_pi, ymax=mean_pi+1.96*se_pi), width=0.0) +
  ylim(0.00, 0.10) +
scale_color_manual(values = c("#F8766D", "#00BFC4"))
print(plot_pi)

# FORMATTED
plot_pi <- theta_plotting_pi %>%
  ggplot(aes(x = era, y = mean_pi, color = era)) +
  labs(y = "Mean Pi") +
  theme_classic() +
  theme(legend.position = "none",
        axis.text.x = element_blank(),  # Hides x-axis labels
        axis.title.x = element_blank(),  # Hides x-axis title
        axis.ticks.x = element_blank(),  # Hides x-axis ticks
        axis.text.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis values
        axis.title.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis title
        axis.ticks.length = unit(3, "pt"),  # Small tick marks
        axis.ticks = element_line(color = "black")) +  # Black tick mark
  geom_point(size = 2, position = position_dodge(width = 0.3)) +  
  geom_errorbar(aes(ymin = mean_pi - 1.96 * se_pi, ymax = mean_pi + 1.96 * se_pi),
                width = 0.1, position = position_dodge(width = 0.3)) +  
  ylim(0.00, 0.20) +  # Adjusted to fit your data
  scale_color_manual(values = c("#F8766D", "#00BFC4")) 
print(plot_pi)

# outFile pattern
outFile_plot_pi <- paste0("plots/", spp_code, "_plot_pi_subset_FORMAT", ".png")  

# Save the plot to a file
ggsave(filename = outFile_plot_pi, plot = plot_pi, width = 2.15, height = 2.5)


#Test to see if theta is normally distributed
hist(apnd_notrans$tW_bysite)
hist(cpnd_notrans$tW_bysite)
#Looks normally distributed

# Now, perform the t-test
t.test(apnd_notrans$tW_bysite, cpnd_notrans$tW_bysite, paired=TRUE)

# Paired t-test
# 
# data:  apnd_filtered$tW_bysite and cpnd_filtered$tW_bysite
# t = -12.907, df = 98, p-value < 2.2e-16
# alternative hypothesis: true mean difference is not equal to 0
# 95 percent confidence interval:
#   -0.05688962 -0.04172739
# sample estimates:
#   mean difference 
# -0.0493085

#Bootstrapping of theta
x = as.vector(apnd_notrans$tW_bysite)

samplemean <- function(x, d) {
  return(mean(x[d]))
}

apnd_boot = boot(x, samplemean, R=1000)

apnd_boot
plot(apnd_boot)
# original        bias    std. error
# t1* 0.07577759 -0.0001097203 0.002414624

boot.ci(boot.out=apnd_boot, type="norm") #95%   ( 0.0712,  0.0806 ) 
boot.ci(boot.out=apnd_boot, type="bca") #95%   ( 0.0718,  0.0815 ) 

x = as.vector(cpnd_notrans$tW_bysite)
cpnd_boot = boot(x, samplemean, R=1000)

cpnd_boot
plot(cpnd_boot)
# original        bias    std. error
# t1* 0.1250861 -0.0001357701  0.00338543

boot.ci(boot.out=cpnd_boot, type="norm") #95%   ( 0.1186,  0.1319 ) 
boot.ci(boot.out=cpnd_boot, type="bca") #95%   ( 0.1180,  0.1313 )

##Create data frame with means and 95% CI for plotting

population <- c("APnd","CPnd")
location <- c("Pandanon Island", "Pandanon Island")
mean_theta <- c(0.07577759, 0.1250861)
se_theta <- c(0.002414624, 0.00338543)
lower_95_theta <- c(0.0712, 0.1186)
upper_95_theta <- c(0.0806, 0.1319)
era <- c("Historical", "Modern")

theta_plotting <- data.frame(population, era, location, mean_theta, se_theta)
theta_plotting$location <- factor(theta_plotting$location, levels=c("Pandanon Island"))
theta_plotting$era <- factor(theta_plotting$era, levels=c("Historical", "Modern"))

# FORMATTED
plot_theta <- theta_plotting %>%
  ggplot(aes(x = era, y = mean_theta, color = era)) +
  labs(y = "Mean Theta") +
  theme_classic() +
  theme(legend.position = "none",
        axis.text.x = element_blank(),  # Hides x-axis labels
        axis.title.x = element_blank(),  # Hides x-axis title
        axis.ticks.x = element_blank(),  # Hides x-axis ticks
        axis.text.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis values
        axis.title.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis title
        axis.ticks.length = unit(3, "pt"),  # Small tick marks
        axis.ticks = element_line(color = "black")) +  # Black tick mark
  geom_point(size = 2, position = position_dodge(width = 0.3)) +  
  geom_errorbar(aes(ymin = mean_theta - 1.96 * se_pi, ymax = mean_theta + 1.96 * se_theta),
                width = 0.1, position = position_dodge(width = 0.3)) +  
  ylim(0.00, 0.20) +  # Adjusted to fit your data
  scale_color_manual(values = c("#F8766D", "#00BFC4")) 
print(plot_theta)

# outFile pattern
outFile_plot_theta <- paste0("plots/", spp_code, "_plot_theta_subset_FORMAT", ".png")  

# Save the plot to a file
ggsave(filename = outFile_plot_theta, plot = plot_theta, width = 2.15, height = 2.5)



theta_all <- theta_plotting %>%
  ggplot(aes(x=era, y=mean, shape=location, color=location)) +
  labs(x="Era",y="Mean Theta", color="Era") +
  theme_classic() +
  theme(legend.position="none") +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=mean_36-1.96*se_36, ymax=mean_36+1.96*se_36), width=0.0) +
  scale_color_manual(values = c("dodgerblue4", "darkseagreen2")) +
  ylim(0.06, 0.095)
print(theta_all)

plot_grid(theta_all, pi_all,
          labels=c('A', 'B'))

plot_grid(theta_all, pi_all, theta_neutral, pi_neutral,
          labels=c('A', 'B', 'C', 'D'))
#theta_neutral and pi_neutral are plotted in the geneticdiversity_neutral.R script

#Tajimas D Distribution Plot
#FORMAT
plot_tajima_density <- angsd_thetas_depth_notrans %>%
  ggplot(aes(x=Tajima, fill=Era)) +
  labs(x="Tajima's D",y="Density") +
  theme_classic() +
  theme(legend.position = "none",
        axis.text.x = element_text(family = "Times New Roman", size = 12),  # Font for x-axis values
        axis.title.x = element_text(family = "Times New Roman", size = 12),  # Font for x-axis title
        axis.ticks.x = element_blank(),  # Hides x-axis ticks
        axis.text.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis values
        axis.title.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis title
        axis.ticks.length = unit(3, "pt"),  # Small tick marks
        axis.ticks = element_line(color = "black")) +  # Black tick mark
  geom_density(alpha=0.65) +
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  scale_x_continuous(breaks = seq(-2, 2, by = 2), 
                     limits = c(-2.5, 2.5), 
                     # expand = c(0, 1.1),
                     labels = scales::number_format(accuracy = 1)) +  # Round to 0 decimal places
  scale_y_continuous(breaks = seq(0, 1.0, by = 0.2), 
                     limits = c(0, 1.1), 
                     #expand = c(0, 0.5),
                     labels = scales::number_format(accuracy = 0.1))  # Round to 1 decimal places
print(plot_tajima_density)

# outFile pattern
outFile_plot_tajima <- paste0("plots/", spp_code, "_plot_tajima_subset_FORMAT", ".png")  

# Save the plot to a file
ggsave(filename = outFile_plot_tajima, plot = plot_tajima_density, width = 2.15, height = 2.5)


# PEAKS
# Compute density estimate for Historical
density_historical <- density(angsd_thetas_depth_notrans$Tajima[angsd_thetas_depth_notrans$Era == "Historical"], na.rm = TRUE)
peak_historical <- density_historical$x[which.max(density_historical$y)]

# Compute density estimate for Modern
density_modern <- density(angsd_thetas_depth_notrans$Tajima[angsd_thetas_depth_notrans$Era == "Modern"], na.rm = TRUE)
peak_modern <- density_modern$x[which.max(density_modern$y)]

# Print peak values
print(paste("Peak of Historical:", peak_historical))
# Peak of Historical: -1.0167198229469
print(paste("Peak of Modern:", peak_modern))
# Peak of Modern: -1.38256846599433


plot_tajima <- angsd_thetas_depth_notrans %>%
  ggplot(aes(x=Tajima, fill=Era)) +
  labs(x="Tajima's D",y="Density") +
  theme_classic() +
  theme(legend.position = "none",
        axis.text.x = element_text(family = "Times New Roman", size = 12),  # Font for x-axis values
        axis.title.x = element_text(family = "Times New Roman", size = 12),  # Font for x-axis title
        axis.ticks.x = element_blank(),  # Hides x-axis ticks
        axis.text.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis values
        axis.title.y = element_text(family = "Times New Roman", size = 12),  # Font for y-axis title
        axis.ticks.length = unit(3, "pt"),  # Small tick marks
        axis.ticks = element_line(color = "black")) +  # Black tick mark
  geom_density(alpha=0.65) +
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
print(plot_tajima)

plot_grid(bol_tajima_all, mta_tajima_all,
          labels=c('A', 'B'))
