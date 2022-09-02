surv_data <- function(m) {
  library(dplyr)
  time <- status <- tr <- rep <- list()
  for (i in seq_len(nrow(m))) {
    d <- m %>%
      slice(i) %>%
      select(4:(length(m) - 1)) %>%
      unlist() %>%
      unname()
    d <- d - lag(d)
    t <- m %>%
      slice(i) %>%
      select(4:(length(m) - 1)) %>%
      colnames() %>%
      as.numeric()
    t <- t - t[1]
    time[[i]] <- c(rep(t[which(d > 0)], d[which(d > 0)]), rep(last(t), m %>% slice(i) %>% last()))
    status[[i]] <- c(rep(1, length(time[[i]]) - m %>% slice(i) %>% last()), rep(0, m %>% slice(i) %>% last()))
    tr[[i]] <- rep(m %>% slice(i) %>% select(1) %>% unlist() %>% unname(), length(time[[i]]))
    rep[[i]] <- rep(m %>% slice(i) %>% select(2) %>% unlist() %>% unname(), length(time[[i]]))
  }
  a <- data.frame(time = unlist(time), status = unlist(status), trat = unlist(tr), rep = unlist(rep))
  return(a)
}

