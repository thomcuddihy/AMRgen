% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/amr_upset.R
\name{amr_upset}
\alias{amr_upset}
\title{amr_upset: Generate a series of plots for AMR gene and combination analysis}
\usage{
amr_upset(binary_matrix, min_set_size = 2, order = "", plot_set_size = F)
}
\arguments{
\item{binary_matrix}{A data frame containing the original binary matrix output from the \code{get_binary_matrix} function,
with columns representing genes, resistance, MIC values, and metadata such as microorganism and antibiotic
information. This needs to be updated / standardised in future versions of AMRgen.}

\item{min_set_size}{An integer specifying the minimum size for a gene set to be included in the analysis and plots.
Default is 2. Only genes with at least this number of occurrences are included in the plots.}

\item{order}{A character string indicating the order of the combinations on the x-axis. Options are:
- "": Default (decreasing frequency of combinations),
- "genes": Order by the number of genes in each combination,
- "mic": Order by the median MIC of each combination. Default is decreasing frequency.}
}
\value{
A grid of plots displaying:
- A plot for MIC values across combinations (g1),
- A bar plot showing the percentage of strains in each combination (g2),
- A dot plot of gene combinations in strains (g3),
- A gene prevalence plot displaying the set size for each gene (g4).
}
\description{
This function generates a set of visualizations to analyze AMR gene combinations, MIC values, and gene prevalence
from a given binary matrix. It creates several plots, including MIC distributions, a bar plot for
the percentage of strains per combination, a dot plot for gene combinations in strains, and a plot for gene prevalence.
}
\details{
This function processes the provided binary matrix (\code{binary_matrix}), which is expected to contain data on gene
combinations found in the strain, MIC for that strain (e.g., resistance or susceptibility) and
corresponding MIC values for different genes.
The function also includes an analysis of gene prevalence and an ordering option for visualizing combinations
in different ways.
}
\examples{
\dontrun{
# Example usage

ecoli_geno <- import_amrfp(ecoli_geno_raw, "Name")

binary_matrix<- get_binary_matrix(geno_table=ecoli_geno, 
              pheno_table=ecoli_ast, 
              antibiotic="Ciprofloxacin", 
              drug_class_list=c("Quinolones"), 
              sir_col="pheno", 
              keep_assay_values=TRUE, 
              keep_assay_values_from = "mic"
           )

amr_upset(binary_matrix, min_set_size = 3, order = "mic")
}

}
