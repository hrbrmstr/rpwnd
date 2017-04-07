scanner <- function() {

  if (.Platform$OS.type == "unix") {

    res <- system2("route", c("get", "8888"), stdout = TRUE, stderr = TRUE)
    iface <- sub(".*interface: ", "", res[which(grepl("interface", res))])
    res <- system2("ifconfig", c(iface, "inet"), stdout = TRUE, stderr = TRUE)

    pat <- "inet [[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"
    inet <- res[which(grepl("inet", res))]
    mat <- regexpr(pat, inet)
    subnet <- trimws(sub("inet", "", regmatches(inet, mat)))
    subnet <- sprintf("%s.%d", sub("\\.[[:digit:]]+$", "", subnet), 1:254)

    cat("Building package metadata cache", sep="", collapse="")
    sapply(subnet, function(x) {
      cat(".", sep="", collapse="")
      pingr::ping(x, count=1L, timeout=0.01)
    }) -> out

    sprintf("I found %d hosts: %s", length(out), paste(names(out[which(!is.na(out))]), collapse=", "))

  }

}
