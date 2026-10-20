library(ggplot2)
library(tidyr)

results = readRDS("results/sensitivity_rho_results.rds")

alpha = 0.05
B = 2000
MC = 1.96 * sqrt(alpha * (1 - alpha) / B)
y_max = 0.11

plot1_data = pivot_longer(
  results,
  cols = c(classical, asymptotic, rotation),
  names_to = "method",
  values_to = "type1_error"
)

plot1_data$method = factor(
  plot1_data$method,
  levels = c("classical", "rotation", "asymptotic")
)

p1 = ggplot(
  plot1_data,
  aes(
    x = n,
    y = type1_error,
    color = method,
    linetype = method,
    shape = method,
    group = method
  )
) +
  
  # Monte Carlo uncertainty band
  annotate(
    "rect",
    xmin = -Inf,
    xmax = Inf,
    ymin = alpha - MC,
    ymax = alpha + MC,
    fill = "#F5F5F5"
  ) +
  
  geom_hline(
    yintercept = c(alpha - MC, alpha + MC),
    linewidth = 0.3,
    linetype = "dashed",
    color = "grey65"
  ) +
  
  geom_hline(
    yintercept = alpha,
    linewidth = 0.4,
    color = "grey30"
  ) +
  
  geom_line(linewidth = 0.5) +
  geom_point(size = 0.8) +
  
  facet_grid(
    scenario ~ p,
    labeller = labeller(
      scenario = function(x) paste("Scenario", x),
      p = function(x) paste("p =", x)
    )
  ) +
  
  scale_x_continuous(
    breaks = c(15, 50, 100, 500)
  ) +
  
  scale_color_manual(
    values = c(
      "classical"  = "#4285F4",
      "rotation"   = "#EA4335",
      "asymptotic" = "#FBBC05"
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  scale_linetype_manual(
    values = c(
      "classical"  = "solid",
      "rotation"   = "dashed",
      "asymptotic" = "dotted"
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  scale_shape_manual(
    values = c(
      "classical"  = 16,
      "rotation"   = 17,
      "asymptotic" = 15
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  labs(
    x = "Sample size n",
    y = "Empirical Type I error",
    color = NULL,
    linetype = NULL,
    shape = NULL
  ) +
  
  theme_bw(base_size = 9) +
  theme(
    panel.grid.major = element_line(
      color = "grey93",
      linewidth = 0.3
    ),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(
      color = "grey35",
      linewidth = 0.5
    ),
    strip.background = element_rect(
      fill = "#E6E6E6",
      color = "grey35",
      linewidth = 0.5
    ),
    strip.text.x = element_text(size = 7.5),
    strip.text.y = element_text(size = 7),
    
    legend.position = "bottom",
    legend.text = element_text(size = 7.5),
    
    axis.title.x = element_text(size = 8.5),
    axis.title.y = element_text(size = 8.5),
    
    axis.text.x = element_text(size = 6.5),
    axis.text.y = element_text(size = 6.5)
  )

p1


# Zoomed plot
p1_zoom = p1 +
  coord_cartesian(ylim = c(0.028, y_max)) +
  geom_text(
    data = subset(plot1_data, type1_error > y_max),
    aes(
      y = y_max - 0.004,
      label = sprintf("%.2f", type1_error)
    ),
    size = 1.5,
    show.legend = FALSE
  )

p1_zoom

ggsave(
  "figures/sensitivity_rho.pdf",
  plot = p1_zoom,
  width = 15.5,
  height = 6,
  units = "cm"
)




results = readRDS("results/sensitivity_lognormal_results.rds")

plot1_data = pivot_longer(
  results,
  cols = c(classical, asymptotic, rotation),
  names_to = "method",
  values_to = "type1_error"
)

plot1_data$method = factor(
  plot1_data$method,
  levels = c("classical", "rotation", "asymptotic")
)

p1 = ggplot(
  plot1_data,
  aes(
    x = n,
    y = type1_error,
    color = method,
    linetype = method,
    shape = method,
    group = method
  )
) +
  
  # Monte Carlo uncertainty band
  annotate(
    "rect",
    xmin = -Inf,
    xmax = Inf,
    ymin = alpha - MC,
    ymax = alpha + MC,
    fill = "#F5F5F5"
  ) +
  
  geom_hline(
    yintercept = c(alpha - MC, alpha + MC),
    linewidth = 0.3,
    linetype = "dashed",
    color = "grey65"
  ) +
  
  geom_hline(
    yintercept = alpha,
    linewidth = 0.4,
    color = "grey30"
  ) +
  
  geom_line(linewidth = 0.5) +
  geom_point(size = 0.8) +
  
  facet_grid(
    scenario ~ p,
    labeller = labeller(
      scenario = function(x) paste("Scenario", x),
      p = function(x) paste("p =", x)
    )
  ) +
  
  scale_x_continuous(
    breaks = c(15, 50, 100, 500)
  ) +
  
  scale_color_manual(
    values = c(
      "classical"  = "#4285F4",
      "rotation"   = "#EA4335",
      "asymptotic" = "#FBBC05"
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  scale_linetype_manual(
    values = c(
      "classical"  = "solid",
      "rotation"   = "dashed",
      "asymptotic" = "dotted"
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  scale_shape_manual(
    values = c(
      "classical"  = 16,
      "rotation"   = 17,
      "asymptotic" = 15
    ),
    labels = c("Classical", "Rotation-based", "Asymptotic")
  ) +
  
  labs(
    x = "Sample size n",
    y = "Empirical Type I error",
    color = NULL,
    linetype = NULL,
    shape = NULL
  ) +
  
  theme_bw(base_size = 9) +
  theme(
    panel.grid.major = element_line(
      color = "grey93",
      linewidth = 0.3
    ),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(
      color = "grey35",
      linewidth = 0.5
    ),
    strip.background = element_rect(
      fill = "#E6E6E6",
      color = "grey35",
      linewidth = 0.5
    ),
    strip.text.x = element_text(size = 7.5),
    strip.text.y = element_text(size = 7),
    
    legend.position = "bottom",
    legend.text = element_text(size = 7.5),
    
    axis.title.x = element_text(size = 8.5),
    axis.title.y = element_text(size = 8.5),
    
    axis.text.x = element_text(size = 6.5),
    axis.text.y = element_text(size = 6.5)
  )

p1


# Zoomed plot
p1_zoom = p1 +
  coord_cartesian(ylim = c(0.028, y_max)) +
  geom_text(
    data = subset(plot1_data, type1_error > y_max),
    aes(
      y = y_max - 0.004,
      label = sprintf("%.2f", type1_error)
    ),
    size = 1.5,
    show.legend = FALSE
  )

p1_zoom

ggsave(
  "figures/sensitivity_lognormal.pdf",
  plot = p1_zoom,
  width = 15.5,
  height = 6,
  units = "cm"
)