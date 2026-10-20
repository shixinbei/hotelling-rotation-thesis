{\rtf1\ansi\ansicpg936\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Hotelling's T\'b2: Classical and Rotation-Based Tests\
\
This repository contains the R code, simulation results, and figures used in my bachelor thesis on the classical one-sample Hotelling \\(T^2\\) test and a rotation-based alternative.\
\
The simulation study examines finite-sample Type I error, two sensitivity analyses, and empirical power under several multivariate distributions.\
\
## Repository structure\
\
```text\
hotelling-rotation-thesis/\

\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  code/\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  type1/\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  helper_functions.R\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  main_type1.R\
\uc0\u9474    \u9474    \u9492 \u9472 \u9472  plot_type1.R\
\uc0\u9474    \u9474 \
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  sensitivity/\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  main_sensitivity_rho.R\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  helper_functions_lognormal.R\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  main_sensitivity_lognormal.R\
\uc0\u9474    \u9474    \u9492 \u9472 \u9472  plot_sensitivity.R\
\uc0\u9474    \u9474 \
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  power/\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  helper_functions.R\
\uc0\u9474    \u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  main_power.R\
\uc0\u9474    \u9474    \u9492 \u9472 \u9472  plot_power.R\
\uc0\u9474    \u9474 \
\uc0\u9474    \u9492 \u9472 \u9472  submit_slurm.sh\
\uc0\u9474 \

\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  results/\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  type1_results.rds\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  sensitivity_rho_results.rds\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  sensitivity_lognormal_results.rds\
\uc0\u9474    \u9492 \u9472 \u9472  power_results.rds\
\uc0\u9474 \

\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  figures/\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  type1_error.pdf\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  sensitivity_rho.pdf\
\uc0\u9474    
\f1 \'a9\'c0
\f0 \uc0\u9472 \u9472  sensitivity_lognormal.pdf\
\uc0\u9474    \u9492 \u9472 \u9472  power.pdf\
\uc0\u9474 \
\uc0\u9492 \u9472 \u9472  README.md\
```\
\
## Simulation design\
\
The nominal significance level is \\(\\alpha=0.05\\). The main Type I error study uses \\(B=2000\\) Monte Carlo repetitions and \\(R=2000\\) random rotations, with dimensions \\(p\\in\\\{2,5,10\\\}\\) and sample sizes \\(n\\in\\\{15,50,100,500\\\}\\).\
\
The four main scenarios are:\
\
1. **Standard multivariate normal:** \\(N_p(0,I_p)\\).\
2. **Correlated multivariate normal:** \\(N_p(0,\\Sigma)\\), with Toeplitz covariance \\(\\Sigma_\{jk\}=0.5^\{|j-k|\}\\).\
3. **Multivariate \\(t\\):** 5 degrees of freedom, scaled so that the covariance matrix is \\(I_p\\).\
4. **Multivariate skew-\\(t\\):** 5 degrees of freedom with shape vector \\((5,0,\\ldots,0)^\\top\\), centered to have population mean zero.\
\
Three tests are compared in the Type I error study: the classical Hotelling \\(T^2\\) test using the finite-sample \\(F\\) critical value, the rotation-based Hotelling \\(T^2\\) test, and the asymptotic Hotelling \\(T^2\\) test using the \\(\\chi_p^2\\) critical value.\
\
## Sensitivity analyses\
\
Two additional sensitivity analyses are included.\
\
### Higher correlation\
\
The Toeplitz correlation parameter in Scenario 2 is increased from \\(\\rho=0.5\\) to \\(\\rho=0.8\\), while the remaining settings are unchanged.\
\
### Lognormal distribution\
\
An additional non-normal setting is generated from standardized lognormal variables and transformed to have a Toeplitz covariance structure with \\(\\rho=0.5\\).\
\
## Power study\
\
The power study compares the classical and rotation-based tests under the four main scenarios. The dimension is fixed at \\(p=5\\), with sample sizes \\(n\\in\\\{15,50,100,500\\\}\\) and Mahalanobis effect sizes\
\
\\[\
D\\in\\\{0,0.1,0.2,0.3,0.4,0.5,0.71\\\}.\
\\]\
\
## R packages\
\
The scripts use the following R packages:\
\
```r\
parallel\
mvtnorm\
sn\
rstiefel\
ggplot2\
tidyr\
```\
\
Please install any missing packages before running the simulations.\
\
## Running the code\
\
All scripts should be run from the **repository root directory** so that the relative paths to `code/`, `results/`, and `figures/` work correctly.\
\
### Type I error study\
\
```bash\
Rscript code/type1/main_type1.R\
Rscript code/type1/plot_type1.R\
```\
\
### Higher-correlation sensitivity analysis\
\
```bash\
Rscript code/sensitivity/main_sensitivity_rho.R\
```\
\
### Lognormal sensitivity analysis\
\
```bash\
Rscript code/sensitivity/main_sensitivity_lognormal.R\
```\
\
### Sensitivity figures\
\
The following script generates the two sensitivity-analysis figures separately:\
\
```bash\
Rscript code/sensitivity/plot_sensitivity.R\
```\
\
### Power study\
\
```bash\
Rscript code/power/main_power.R\
Rscript code/power/plot_power.R\
```\
\
The main simulation scripts save intermediate checkpoint files while running. After successful completion, the final results are stored in `results/`.\
\
## Running on a Slurm cluster\
\
`code/submit_slurm.sh` is a generic Slurm submission script. It uses 32 CPU cores and accepts the R script to be run as its first argument.\
\
Examples:\
\
```bash\
sbatch --job-name=type1 code/submit_slurm.sh code/type1/main_type1.R\
sbatch --job-name=sensitivity_rho code/submit_slurm.sh code/sensitivity/main_sensitivity_rho.R\
sbatch --job-name=sensitivity_lognormal code/submit_slurm.sh code/sensitivity/main_sensitivity_lognormal.R\
sbatch --job-name=power code/submit_slurm.sh code/power/main_power.R\
```\
\
Slurm output is written to\
\
```text\
results/<job-name>_<job-id>.txt\
```\
\
Cluster-specific resource settings such as wall time and memory can be adjusted in `code/submit_slurm.sh` if necessary.\
\
## Reproducibility\
\
The simulation scripts use a fixed random-number seed through `clusterSetRNGStream()`.\
\
The final `.rds` files used to produce the thesis figures are included in `results/`, so the figures can be reproduced without rerunning the full simulations.\
\
## Notes\
\
The simulation code is intended to accompany the bachelor thesis and to document the computational implementation of the numerical study.\
}