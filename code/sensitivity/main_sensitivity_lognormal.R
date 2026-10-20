library(parallel)
library(sn)

source("code/sensitivity/helper_functions_lognormal.R") 

no.cores = 32
alpha = 0.05
B = 2000
R = 2000

settings = expand.grid( 
  scenario = 5,
  n = c(15, 50, 100, 500),
  p = c(2, 5, 10)
)

results = data.frame( 
  settings,
  classical = NA_real_,
  asymptotic = NA_real_,
  rotation = NA_real_
)

cl = makeCluster( 
  no.cores,
  type = "FORK",
  outfile = "results/sensitivity_lognormal_worker_log.txt"
)

clusterSetRNGStream(cl, iseed = 3456) 

clusterExport( 
  cl,
  c(
    "make_setting_parameters",
    "make_sample",
    "hotelling_T2",
    "rotate_sample",
    "rotation_test",
    "one_repetition"
  )
)

for (s in seq_len(nrow(settings))) { 
  scenario = settings$scenario[s]
  n = settings$n[s]
  p = settings$p[s]
  
  parameters = make_setting_parameters(scenario, p, rho = 0.5) 
  
 
  critical_F =
    p * (n - 1) / (n - p) *
    qf(1 - alpha, df1 = p, df2 = n - p)
  
  critical_chisq =
    qchisq(1 - alpha, df = p)
  
  temp = parLapply(
    cl,
    seq_len(B), 
    one_repetition,
    scenario = scenario,
    n = n,
    p = p,
    Sigma = parameters$Sigma,
    st_mean = parameters$st_mean,
    R = R,
    alpha = alpha,
    critical_F = critical_F,
    critical_chisq = critical_chisq
  )
  
  results[s, c("classical", "asymptotic", "rotation")] = colMeans(do.call(rbind, temp))
  
  saveRDS(
    results[seq_len(s), ],
    file = "results/sensitivity_lognormal_checkpoint.rds"
  )
}

stopCluster(cl)

saveRDS(
  results,
  file = "results/sensitivity_lognormal_results.rds"
)

if (file.exists("results/sensitivity_lognormal_checkpoint.rds")) {
  file.remove("results/sensitivity_lognormal_checkpoint.rds")
}