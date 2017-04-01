if (interactive()) {
  message("While loading this dataset, potentially untrusted R code was executed.")
  message(paste0("Current time: ", Sys.time()))
  assign("rpwnd", datasets::mtcars)
}
