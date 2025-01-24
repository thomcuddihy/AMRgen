# AMRgen

R Package for Genetic and Phenotypic Resistance Interpretation

## Overview

**AMRgen** is an open-source R package designed to bridge the gap between genotypic and phenotypic antimicrobial resistance (AMR) data. Developed as an extension to the [AMR R package](https://github.com/msberends/AMR), it provides tools to interpret AMR genes, integrate these findings with antimicrobial susceptibility test (AST) data, and calculate genotype-phenotype associations.

This package is developed in collaboration with the ESGEM-AMR Working Group and is tailored for researchers and healthcare professionals tackling AMR globally.

------------------------------------------------------------------------

## Key Features

> NOTE: These features are *intended* to develop in the near future

-   **Genotype-Phenotype Integration**: Links AMR gene presence with phenotypic resistance profiles, enabling deeper insights into resistance mechanisms.
-   **Automated EUCAST MIC Distribution Integration**: Fetch MIC distribution data directly from [EUCAST](https://mic.eucast.org) for seamless comparison with local susceptibility data.
-   **Visualisation**: Generate powerful UpSet plots to identify intersections of AMR gene presence and phenotypic resistance, highlighting multidrug resistance patterns.
-   **NCBI-Compliant Export**: Create NCBI-compliant antibiograms for global data sharing and interoperability with surveillance platforms.
-   **Modular and Extensible**: Leverages the robust foundation of the AMR package, including antibiotic selectors and clinical breakpoint interpretations.

------------------------------------------------------------------------

## Getting Started

To install and explore the package, follow the instructions below:

### Installation
Note that this package requires the latest version of the `AMR` package (still in beta).

Install the latest version of the `AMR` package with:
```r
install.packages("remotes") # if you haven't already
remotes::install_github("msberends/AMR")
```

Then install this package
``` r
# Install from GitHub
remotes::install_github("interpretAMR/AMRgen")
```

## Usage Examples

_Will follow shortly_

## Contributions

Contributions are welcome! If you encounter issues or wish to suggest new features, please open an issue or submit a pull request.

## Licence

This package is distributed under the GNU GPL-3.0 Licence. See `LICENSE` for details.



## Dev notes:

### Definition: 'genotype' dataframe

required fields:
- a column indicating the sample ID (any string; to be matched to phenotype data)
- a column named 'marker' indicating the label for a specific gene or mutation (S3 class 'gene')

at least one of:
- a column named 'drug_agent' (S3 class 'ab'; this will usually be generated by a genotype parser function applying as.ab)
- a column named 'drug_class' indicating a drug class associated with this marker (controlled vocab string; allowed values are those in antbiotics$group, this will usually be generated by a genotype parser function, if not provided it will be generated from 'drug_agent') [might develop S3 class? e.g. needs to include 'efflux']

optionally:
- a column indicating the species (S3 class mo; to facilitate interpretation)
  
genotype parsers should be generating all 4 fields

### Definition: 'phenotype' dataframe

required fields:
- a column indicating the sample ID (any string; to be matched to genotype data)
- a column named 'drug_agent' (S3 class 'ab'; this will usually be generated by a phenotype parser function applying as.ab)

at least one of:
- a column of class 'disk' or 'mic'
- a column of class 'sir'

optionally:
- a column indicating the species (S3 class mo; to facilitate interpretation)

### function to import NCBI AST file into a suitable 'phenotype' dataframe: import_ncbi_ast
- input = filepath to a NCBI AST file (e.g. https://www.ncbi.nlm.nih.gov/pathogens/ast#Pseudomonas%20aeruginosa)
- rename `#BioSample` column -> new column  'biosample'
- map key columns to AMR classes:
  - `Antibiotic` -> as.ab -> new column 'drug_agent' (class ab)
  - `Scientific name` -> as.mo -> new column 'spp_pheno' (class mo)
  - `MIC (mg/L)` -> as.mic -> new column 'mic' (class mic)
  - `Disk diffusion (mm)` -> as.disk -> new column 'disk' (class disk)
  - `Testing standard` -> new column 'guideline' (character; value = 'CLSI' if specified, otherwise default to 'EUCAST')
- optionally (on by default), interpret any mic or disk columns using the ab, mo, guideline values - new column 'pheno' (class sir)
- return = dataframe with the input NCBI AST file contents with the new columns added

### Expected workflow (target for dev)

* import genotype data -> genotype dataframe
* import phenotype data -> phenotype dataframe (e.g. `import_ncbi_ast`)
  - interpret SIR if required (as.sir; requires either a species column, or that all rows are a single species)
* filter both files to the required sample sets (e.g. filter on species, check common sample identifiers exist)
* pass filtered genotype & phenotype objects (which have common sample identifiers) to functions for
  - cross-tabulating SIR vs marker presence/absence, calculating & plotting PPV
  - upset plots showing MIC/DD distribution stratified by genotype profile
  - generating binary matrix of SIR vs marker presence/absence suitable for regression modelling
  - 

# Working examples
```
load(AMRgen)

# import example E. coli AST data from NCBI (without re-interpreting resistance)
pheno <- import_ncbi_ast("testdata/Ecoli_AST_NCBI_n50.tsv")

# import example E. coli AMRfinderplus data
geno <- parse_amrfp("testdata/Ecoli_AMRfinderplus_n50.tsv", "Name")

# get subsets of each table for samples present in both
overlap <- compare_geno_pheno_id(geno,pheno)

# get binary matrix for R/NWT for a given drug (using "Resistance phenotype" from NCBI), and presence/absence for markers for relevant drug class/es
mero_vs_blaGenes <- getBinMat(geno, pheno, antibiotic="Meropenem", drug_class_list=c("Carbapenems", "Cephalosporins"), sir_col="Resistance phenotype")
cipro_vs_quinoloneMarkers <- getBinMat(geno, pheno, "Ciprofloxacin", c("Quinolones"), sir_col="Resistance phenotype")

# import example E. coli AST data from NCBI, and re-interpret resistance into new column 'pheno' (WARNING: phenotype interpretation can take a few minutes)
pheno2 <- import_ncbi_ast("testdata/Ecoli_AST_NCBI_n50.tsv", interpret = T)
mero_vs_blaGenes2 <- getBinMat(geno, pheno2, antibiotic="Meropenem", drug_class_list=c("Carbapenems", "Cephalosporins"), sir_col="pheno")
cipro_vs_quinoloneMarkers2 <- getBinMat(geno, pheno2, "Ciprofloxacin", c("Quinolones"), sir_col="pheno")


```
