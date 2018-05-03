setwd("/home/lamarck/Satyajeet/Data/Mariam/nutshell/")

# Create data object for Trinity.gene.lengths
Trinity_gene_lengths <- read.csv("Trinity.gene_lengths.txt", sep = "\t")

# Create data object for go_annotations
go_annotations <- read.csv("DE_analysis/go_annotations.txt", sep = NULL, header = FALSE)

# Create data object for annot_feature_map
annot_feature_map <- read.csv("DE_analysis/annot_feature_map.txt", sep = "\t", header = FALSE)

# Modify Trinity_gene_lengths data object by adding a third column with Annotations
Trinity_gene_lengths_mod <- left_join(Trinity_gene_lengths, annot_feature_map, by = c("X.gene_id" = "V1"))

# Modify third column by replacing NA with Trinity gene IDs
setDT(Trinity_gene_lengths_mod)[is.na(V2), V2 := X.gene_id]

# Relace the "X.gene_id" values with values in the third column
Trinity_gene_lengths_mod[, "X.gene_id"] <- Trinity_gene_lengths_mod$V2

# Delete the third column. Its no longer required.
Trinity_gene_lengths_mod$V2 <- NULL

# Write a modified gene length file. This file will be used for analysis of differential expression
write.table(Trinity_gene_lengths_mod, file = "Trinity_gene_lengths_mod.txt", quote = FALSE, row.names = FALSE, sep = "\t")

# Modify go_annotations by adding a third column with Annotations
go_annotations_mod <- left_join(go_annotations, annot_feature_map, by = c("V1" = "V1"))

# Relace the "V1" values with values in the third column (V2.y)
go_annotations_mod[, "V1"] <- go_annotations_mod$V2.y

# Delete the third column. Its no longer required.
go_annotations_mod$V2 <- NULL

# Write a modified go annotation file. This file will be used for analysis of differential expression
write.table(go_annotations_mod, file = "go_annotations_mod.txt", quote = FALSE, row.names = FALSE, sep = "\t")

# Use "Trinity_gene_lengths_mod.txt" in place of "Trinity.gene_lengths.txt" 
# and "go_annotations_mod.txt" in place of "go_annotations.txt"
# in "Trinity-v2.6.5/Analysis/DifferentialExpression/analyze_diff_expr.pl"script
