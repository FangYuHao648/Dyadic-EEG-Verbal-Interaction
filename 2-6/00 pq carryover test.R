
# test for PQ carry over efffect

#install.packages("readxl")

library(readxl)

# Load the data and store it in a variable called 'my_data'
clean_data <- read_excel("D:\\桌面\\Matlab Working path\\residual effect\\Re_ISC_end_filled_end.xlsx")

all_vars <- c("Pre_Feedback", "Pre_InformationType", "Pre_EyeContact") 
# clean_data <- my_data[complete.cases(my_data[ , all_vars]), ]

## baseline 

model_baseline <- lmer(ISC ~ Feedback * InformationType * EyeContact + (1 | subject), data = clean_data)

cat("--- Baseline Model Summary ---\n")
summary(model_baseline)

## adding trial number

model_time <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + (1 | subject), data = clean_data)

cat("\n--- Model with Time Effect ---\n")
summary(model_time)

# Formally compare the models to see if adding trial_number significantly improved the fit
cat("\n--- Model Comparison (Baseline vs. Time) ---\n")
anova(model_baseline, model_time)

## adding carryover condition

# model_carryover <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + Pre_Feedback + (1 | subject), data = clean_data)

# model_carryover <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + Pre_InformationType + (1 | subject), data = clean_data)

model_carryover <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + Pre_Feedback + Pre_InformationType + Pre_EyeContact + (1 | subject), data = clean_data)

model_carryover1 <- lmer(ISC ~ Feedback * InformationType * EyeContact + Pre_Feedback + Pre_InformationType + Pre_EyeContact + (1 | subject), data = clean_data)

# model_carryover <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + Pre_Feedback * Pre_InformationType * Pre_EyeContact + (1 | subject), data = clean_data)

# model_carryover <- lmer(ISC ~ Feedback * InformationType * EyeContact + scale(Groupid) + Pre_Feedback * Pre_InformationType * Pre_EyeContact + (1 | subject), data = clean_data)

cat("\n--- Model with Carryover Effect ---\n")
summary(model_carryover)

# Formally compare the time model to the carryover model
cat("\n--- Model Comparison (Time vs. Carryover) ---\n")
anova(model_time, model_carryover)
anova(model_baseline, model_carryover1)