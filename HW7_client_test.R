## HW7_client_test.R

library(httr)
library(dplyr)
library(lubridate)
library(jsonlite)
library(readr)

source("HW7_model_prep.R")

api_base <- "http://127.0.0.1:8080"

cols <- c("provider_id", "address", "age",
          "specialty", "lead_time", "appt_hour", "weekday")

newdata <- test |>
  select(all_of(cols)) |>
  head(5) |>
  as.data.frame()

cat("Data being sent to API:\n")
print(newdata)

cat("\nCalling /predict_prob ...\n")

resp_prob <- POST(
  url  = paste(api_base, "predict_prob", sep = "/"),
  body = serialize(newdata, NULL),
  content_type("application/rds")
)

stop_for_status(resp_prob)

prob_vec <- content(resp_prob, "raw") |>
  unserialize()

cat("Predicted probabilities of no-show:\n")
print(prob_vec)

cat("\nCalling /predict_class ...\n")

resp_class <- POST(
  url  = paste(api_base, "predict_class", sep = "/"),
  body = serialize(newdata, NULL),
  content_type("application/rds")
)

stop_for_status(resp_class)

class_vec <- content(resp_class, "raw") |>
  unserialize()

cat("Predicted classes (1 = no-show):\n")
print(class_vec)
