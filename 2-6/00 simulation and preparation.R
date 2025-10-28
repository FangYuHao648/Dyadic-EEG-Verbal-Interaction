# Install and load necessary packages
# install.packages(c("lme4", "lmerTest", "dplyr"))
library(lme4)
library(lmerTest)
library(dplyr)

# --- Data Simulation ---
set.seed(42) # for reproducibility
n_subjects <- 24
n_trials_per_subject <- 60 # e.g., 5 repetitions of each of the 12 conditions

# Define factor levels
factor1_levels <- c("A", "B")
factor2_levels <- c("X", "Y")
factor3_levels <- c("L", "M", "H")

# Create a design matrix for one subject
conditions <- expand.grid(F1 = factor1_levels, F2 = factor2_levels, F3 = factor3_levels)
subject_design <- do.call("rbind", replicate(5, conditions, simplify = FALSE))

# Create the full dataset
sim_data <- data.frame()
for (i in 1:n_subjects) {
  # Randomize trial order for each subject (block randomization)
  shuffled_design <- subject_design[sample(nrow(subject_design)), ]
  
  subject_df <- data.frame(
    subject_id = factor(i),
    trial_number = 1:n_trials_per_subject
  )
  
  subject_df <- cbind(subject_df, shuffled_design)
  sim_data <- rbind(sim_data, subject_df)
}

# --- Engineer the carryover effect variables ---
sim_data <- sim_data %>%
  arrange(subject_id, trial_number) %>%
  group_by(subject_id) %>%
  mutate(
    prev_F1 = lag(F1, 1),
    prev_F2 = lag(F2, 1),
    prev_F3 = lag(F3, 1)
  ) %>%
  ungroup()

# --- Simulate the dependent variable (RT) ---
# Base RT
sim_data$RT <- 600 
# Main effects
sim_data$RT <- sim_data$RT + ifelse(sim_data$F1 == "B", 25, 0) # F1 effect
sim_data$RT <- sim_data$RT + ifelse(sim_data$F2 == "Y", -15, 0) # F2 effect
# Interaction effect
sim_data$RT <- sim_data$RT + ifelse(sim_data$F1 == "B" & sim_data$F3 == "H", 30, 0)
# Practice effect (gets faster over time)
sim_data$RT <- sim_data$RT - sim_data$trial_number * 0.5 
# Carryover effect from F1 (if previous trial was 'B', current trial is slower)
sim_data$RT <- sim_data$RT + ifelse(!is.na(sim_data$prev_F1) & sim_data$prev_F1 == "B", 20, 0)
# Add random noise for each trial
sim_data$RT <- sim_data$RT + rnorm(nrow(sim_data), mean = 0, sd = 40)
# Add random intercept for each subject (some subjects are just faster/slower)
subject_effects <- rnorm(n_subjects, mean = 0, sd = 50)
sim_data$RT <- sim_data$RT + subject_effects[sim_data$subject_id]

# Ensure factors are treated as factors
sim_data <- sim_data %>%
  mutate(across(c(subject_id, F1, F2, F3, prev_F1, prev_F2, prev_F3), as.factor))

# View the first few rows
head(sim_data, 15)