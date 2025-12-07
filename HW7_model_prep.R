## HW7_model_prep.R

library(readr)
library(dplyr)
library(lubridate)

safe_read <- function(csv_path, gz_path, ...) {
  if (file.exists(csv_path)) {
    readr::read_csv(csv_path, show_col_types = FALSE, ...)
  } else if (file.exists(gz_path)) {
    readr::read_csv(gz_path, show_col_types = FALSE, ...)
  } else {
    stop("Could not find ", csv_path, " or ", gz_path)
  }
}

parse_any_date <- function(x) {
  lubridate::as_datetime(x, tz = "UTC")
}


train <- safe_read("train_dataset.csv", "train_dataset.csv.gz") |>
  mutate(
    appt_time = parse_any_date(appt_time),
    appt_made = parse_any_date(appt_made),
    lead_time = as.numeric(difftime(appt_time, appt_made, units = "days")),
    appt_hour = hour(appt_time),
    weekday   = wday(appt_time, label = TRUE, abbr = TRUE)
  )

test <- safe_read("test_dataset.csv", "test_dataset.csv.gz") |>
  mutate(
    appt_time = parse_any_date(appt_time),
    appt_made = parse_any_date(appt_made),
    lead_time = as.numeric(difftime(appt_time, appt_made, units = "days")),
    appt_hour = hour(appt_time),
    weekday   = wday(appt_time, label = TRUE, abbr = TRUE)
  )


model <- glm(
  no_show ~ provider_id + address + age + specialty +
    lead_time + appt_hour + weekday,
  data   = train,
  family = "binomial"
)

prep_newdata <- function(df) {
  df <- as.data.frame(df)

  required_cols <- c(
    "provider_id",
    "address",
    "age",
    "specialty",
    "lead_time",
    "appt_hour",
    "weekday"
  )

  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(
      paste(
        "Missing required columns in input data:",
        paste(missing_cols, collapse = ", ")
      )
    )
  }

  df$age       <- as.numeric(df$age)
  df$lead_time <- as.numeric(df$lead_time)
  df$appt_hour <- as.numeric(df$appt_hour)

  df[required_cols]
}
