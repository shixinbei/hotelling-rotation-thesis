library(parallel)
library(sn)

source("code/power/helper_functions.R")

no.cores = 32
alpha = 0.05
B = 2000
R = 2000

settings = expand.grid(
  scenario = 1:4,
  n = c(15, 50, 100, 500),
  p = 5,
  D = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.71)
)

results = data.frame(
  settings,
  classical = NA_real_,
  rotation = NA_real_
)

cl = makeCluster(
  no.cores,
  type = "FORK",
  outfile = "results/power_worker_log.txt"
)

clusterSetRNGStream(cl, iseed = 3456)

clusterExport(
  cl,
  c(
    "make_setting_parameters",
    "make_alternative_mean",
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
  D = settings$D[s]
  
  parameters = make_setting_parameters(
    scenario,
    p,
    rho = 0.5
  )
  
  mu = make_alternative_mean(
    D,
    parameters$Sigma_true
  )
  
  critical_F =
    p * (n - 1) / (n - p) *
    qf(1 - alpha, df1 = p, df2 = n - p)
  
  temp = parLapply(
    cl,
    seq_len(B),
    one_repetition,
    scenario = scenario,
    n = n,
    p = p,
    Sigma = parameters$Sigma,
    st_mean = parameters$st_mean,
    mu = mu,
    R = R,
    alpha = alpha,
    critical_F = critical_F
  )
  
  results[s, c("classical", "rotation")] =
    colMeans(do.call(rbind, temp))
 
  saveRDS(
    results[seq_len(s), ],
    file = "results/power_checkpoint.rds"
  )
}

stopCluster(cl)

saveRDS(
  results,
  file = "results/power_results.rds"
)

if (file.exists("results/power_checkpoint.rds")) {
  file.remove("results/power_checkpoint.rds")
}