# Add trial_number to test for linear time effects
# scale() centers and scales the variable, which helps model convergence
model_time <- lmer(RT ~ F1 * F2 * F3 + scale(trial_number) + (1 | subject_id), data = clean_data)

cat("\n--- Model with Time Effect ---\n")
summary(model_time)

# Formally compare the models to see if adding trial_number significantly improved the fit
cat("\n--- Model Comparison (Baseline vs. Time) ---\n")
anova(model_baseline, model_time)