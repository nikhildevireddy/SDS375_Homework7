# Homework7

## Set-up Instructions

In one R session, set the working directory to the project directory. Then, activate and host the server on a local host, using these commands:

```{r}
library(plumber2)

api1 <- api("HW7_api_server.R", port = 8080)
api_run(api1)
```

You should see this sort of message: plumber2 server started at http://127.0.0.1:8080

In a second R session, execute the client test file by running `r source("HW7_client_test.R")`. Then, you should see:

- The newdata data frame

- Probabilities printed (numeric vector)

- Classes printed (0/1 integer vector)
