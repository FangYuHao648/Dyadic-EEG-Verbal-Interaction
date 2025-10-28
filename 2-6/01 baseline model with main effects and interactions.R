# List all variables used in ANY model you want to compare
all_vars <- c("prev_F1", "prev_F2", "prev_F3") # Add any other variables you might use

# Create a new data frame with no missing values in those columns
# The drop = FALSE is good practice, though not strictly needed here
clean_data <- sim_data[complete.cases(sim_data[ , all_vars]), ]


# Model with all interactions of your primary factors
# Using lmerTest to get p-values


model_baseline <- lmer(RT ~ F1 * F2 * F3 + (1 | subject_id), data = clean_data)

cat("--- Baseline Model Summary ---\n")
summary(model_baseline)