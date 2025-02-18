## Data Assignment 2 - Webflicks

# Dataset
library(data.table)
Webflicks <- as.data.table(Webflicks)

# Summary Stats
summary(Webflicks)

# Initial boxplot
library(ggplot2)
library(ggthemes)
ggplot(Webflicks) +
  geom_boxplot(aes(y = Views,
                   x = Genre,
                   fill = ReleaseSchedule)) +
  theme_bw() +
  labs(title = "Average Views Across Genres by Release Schedule Model",
       y = "Views (in minutes)") 


# ANOVA Assumptions
fit <- aov(Views ~ ReleaseSchedule + Genre, data = Webflicks)
Webflicks$Residuals <- residuals(fit)

qqnorm(residuals(fit))
qqline(residuals(fit))

Webflicks$Predicted <- predict(fit)
plot(Residuals ~ Predicted, data = Webflicks) +
  title('Residuals vs Predicted Values')


# ANOVA test
summary(fit)


# Post-Hoc
summary(aov(Views~Genre + ReleaseSchedule,
            data=Webflicks[ ReleaseSchedule %in% c("Drop", "Weekly")]))
# uncorrected p-value = 0.0158 --> corrected p-value = 0.0474

summary(aov(Views~Genre + ReleaseSchedule,
            data=Webflicks[ ReleaseSchedule %in% c("Drop", "DualDrop")]))
# uncorrected p-value = 0.494 --> corrected p-value = 1.482

summary(aov(Views~Genre + ReleaseSchedule,
            data=Webflicks[ ReleaseSchedule %in% c("Weekly", "DualDrop")]))
# uncorrected p-value = 0.00168 --> corrected p-value = 0.00504

library(ggthemes)

  
#Averages Tables
Webflicks[,.(Mean = mean(Views)),
          by = "ReleaseSchedule"]
