# Add the previous trial's F1 condition as a predictor
# We'll build on the model that already includes the time effect
model_carryover <- lmer(RT ~ F1 * F2 * F3 + scale(trial_number) + prev_F1 * prev_F2 * prev_F3 + (1 | subject_id), data = clean_data)

cat("\n--- Model with Carryover Effect ---\n")
summary(model_carryover)

# Formally compare the time model to the carryover model
cat("\n--- Model Comparison (Time vs. Carryover) ---\n")
anova(model_time, model_carryover)