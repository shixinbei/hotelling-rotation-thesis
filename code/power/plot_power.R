library(ggplot2)
library(tidyr)

results = readRDS("results/power_results.rds")

plot_power_data = pivot_longer(
  results,
  cols = c(classical, rotation),
  names_to = "method",
  values_to = "power"
)

plot_power_data$method = factor(
  plot_power_data$method,
  levels = c("classical", "rotation")
)

p_power = ggplot(
  plot_power_data,
  aes(
    x = D,
    y = power,
    color = method,
    linetype = method,
    shape = method,
    group = method
  )
) +
  
  # Nominal significance level
  geom_hline(
    yintercept = 0.05,
    linewidth = 0.35,
    color = "grey60"
  ) +
  
  geom_line(linewidth = 0.5) +
  geom_point(size = 1.5) +
  
  facet_grid(
    scenario ~ n,
    labeller = labeller(
      scenario = function(x) paste("Scenario", x),
      n = function(x) paste("n =", x)
    )
  ) +
  
  scale_x_continuous(
    breaks = sort(unique(plot_power_data$D))
  ) +
  
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.2)
  ) +
  
  scale_color_manual(
    values = c(
      "classical" = "#4285F4",
      "rotation"  = "#EA4335"
    ),
    labels = c("Classical", "Rotation-based")
  ) +
  
  scale_linetype_manual(
    values = c(
      "classical" = "solid",
      "rotation"  = "dashed"
    ),
    labels = c("Classical", "Rotation-based")
  ) +
  
  scale_shape_manual(
    values = c(
      "classical" = 16,
      "rotation"  = 17
    ),
    labels = c("Classical", "Rotation-based")
  ) +
  
  labs(
    x = "Effect size D",
    y = "Empirical power",
    color = NULL,
    linetype = NULL,
    shape = NULL
  ) +
  
  theme_bw(base_size = 12) +
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
    strip.text = element_text(size = 11),
    legend.position = "bottom",
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

p_power

ggsave(
  "figures/power.pdf",
  plot = p_power,
  width = 15.5,
  height = 18,
  units = "cm"
)