suppressPackageStartupMessages({
  library(readxl)
  library(ggpubr)
  library(ggsci)
})

# import data files with colocalization measurements 
data_files <- list.files(pattern = "*Result_Table.csv")
data_df <- data.frame()

for (file in data_files){
  csv_file <- read.csv(file)
  data_df <- rbind(data_df, csv_file)
  }

# import the sample annotation file
stats_Dact1_bCat_coloc <- read_excel(
  "stats_Dact1_bCat_coloc.xlsx",
  col_types = c("text", "text", "text", "text", "numeric")
)

# Expand the sample annotations to match the measurements file
dact1_bCat_samples <- as.data.frame(lapply(stats_Dact1_bCat_coloc,
                                           rep,
                                           stats_Dact1_bCat_coloc$Cell_N))

stats_Db_coloc <- cbind(dact1_bCat_samples, data_df)

# Factorize sample annotations for downstream compatibility
stats_Db_coloc$Plasmid <- factor(stats_Db_coloc$Plasmid)
stats_Db_coloc$Time_h <- factor(stats_Db_coloc$Time_h)
stats_Db_coloc$Wnt <- factor(stats_Db_coloc$Wnt)

# Generate and annotate data in boxplots with overlapped data points
stat_comparisons <-
  list(c("p25", "p68"), c("p5", "sh973"), c("p68", "sh973"))

pdf(file = "Comparisons_color_TOS_linear.pdf")
ggboxplot(
  stats_Db_coloc,
  x = "Plasmid",
  y = "TOS_linear",
  color = "Plasmid",
  palette = "npg",
  title = "TOS (linear) measure of nuclear beta-Catenine",
  ylab = "TOS (linear)",
  #combine = TRUE,
  facet.by = c("Time_h"),
  add = "jitter",
  add.params = list(size = 0.75, jitter = 0.2)
) +
  stat_compare_means(comparisons = my_comparisons)
dev.off()
