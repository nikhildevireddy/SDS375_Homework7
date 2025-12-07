## HW7_api_server.R

library(plumber2)
library(readr)
source("HW7_model_prep.R")


#* Predict probabilities of no-show (0–1)
#* @post /predict_prob
#* @parser rds
#* @serializer rds
predict_prob <- function(body) {
  df <- prep_newdata(body)
  message(sprintf("predict_prob: received %d rows", nrow(df)))
  probs <- predict(model, newdata = df, type = "response")
  as.numeric(probs)
}

#* Predict classes (0/1, 1 = no-show)
#* @post /predict_class
#* @parser rds
#* @serializer rds
predict_class <- function(body) {
  df <- prep_newdata(body)
  message(sprintf("predict_class: received %d rows", nrow(df)))
  probs <- predict(model, newdata = df, type = "response")
  as.integer(probs > 0.5)
}
