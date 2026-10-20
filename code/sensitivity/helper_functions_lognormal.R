# Parameters that stay fixed within one setting
make_setting_parameters = function(scenario, p, rho = 0.5) { 
  Sigma = if (scenario %in% c(2, 5)) { # modified
    outer(seq_len(p), seq_len(p), function(j, k) rho^abs(j - k)) 
  } else {
    diag(p) 
  }
  
  st_mean = NULL 
  if (scenario == 4) {
    alpha_st = c(5, rep(0, p - 1))
    
    st_distribution = sn::makeSECdistr(
      dp = list(
        xi = rep(0, p),
        Omega = Sigma,
        alpha = alpha_st,
        nu = 5
      ),
      family = "ST"
    )
    
    st_mean = mean(st_distribution) 
  }
  
  list(Sigma = Sigma, st_mean = st_mean) 
}



# Generate one n x p sample under H0 
make_sample = function(scenario, n, p, Sigma, st_mean = NULL) {
  if (scenario %in% c(1, 2)) {
    return( 
      mvtnorm::rmvnorm( 
        n, 
        mean = rep(0, p), 
        sigma = Sigma 
      )
    )
  }
  
  if (scenario == 3) {
    df_t = 5
    return(
      mvtnorm::rmvt(
        n, 
        sigma = ((df_t - 2) / df_t) * Sigma,
        df = df_t,
        delta = rep(0, p),
        type = "shifted"
      )
    )
  }
  
  if (scenario == 4) {
    alpha_st = c(5, rep(0, p - 1)) 
    
    Y = sn::rmst( 
      n,
      xi = rep(0, p), 
      Omega = Sigma, 
      alpha = alpha_st, 
      nu = 5 
    ) 
    
    return( 
      sweep(Y, 2, st_mean, FUN = "-") 
    )
  }
  
  if (scenario == 5) { # modified
    Z = matrix(rnorm(n * p), nrow = n, ncol = p)
    Y = exp(Z)
    
    W = (Y - exp(0.5)) / sqrt(exp(1) * (exp(1) - 1))
    
    return(W %*% chol(Sigma))
  }
  
  stop("scenario must be 1, 2, 3, 4, or 5") # modified
}



# Hotelling's T-squared statistic 
hotelling_T2 = function(X, mu0) {
  d = colMeans(X) - mu0
  S = cov(X)
  
  as.numeric( 
    nrow(X) * crossprod(d, solve(S, d))
  )
}



# Equivalent generation of independent Haar rotations O_i Z_i 
rotate_sample = function(Z) {
  n = nrow(Z)
  p = ncol(Z)
  
  Z_rotated = matrix(NA_real_, nrow = n, ncol = p) 
  
  for (i in seq_len(n)) { 
    O_i = rstiefel::rustiefel(p, p)
    Z_rotated[i, ] = as.vector(O_i %*% Z[i, ])
  }
  
  return(Z_rotated)
}



# One rotation-based test 
rotation_test = function(X, mu0, T2_obs, R, alpha) {
  Z = sweep(X, 2, mu0, FUN = "-") 
  zero = rep(0, ncol(X)) 
  T2_rot = numeric(R) 
  
  for (r in seq_len(R)) {
    Z_rot = rotate_sample(Z) 
    T2_rot[r] = hotelling_T2(Z_rot, zero) 
  }
  
  k = ceiling((1 - alpha) * (R + 1)) 
  
  critical = sort(
    c(T2_obs, T2_rot), 
    partial = k 
  )[k] 
  
  as.integer(T2_obs > critical)
}



# One Monte Carlo repetition
one_repetition = function(i, scenario, n, p, Sigma, st_mean, R, alpha, critical_F, critical_chisq) {
  mu0 = rep(0, p) 
  
  X = make_sample(
    scenario,
    n,
    p,
    Sigma,
    st_mean
  )
  
  T2_obs = hotelling_T2(X, mu0)
  
  c(
    classical = as.integer(T2_obs > critical_F),
    
    asymptotic = as.integer(T2_obs > critical_chisq),
    
    rotation = rotation_test(
      X,
      mu0,
      T2_obs,
      R,
      alpha
    )
  )
}