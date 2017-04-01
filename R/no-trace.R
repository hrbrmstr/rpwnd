#' Alters itself when executed for the first time
#'
#' This function returns 42. Promised.
#'
#' @return 42
#' @export
no_trace <- function() {
  message("This message will disappear next time your run it.")
  message("It will deleted from the source of your package library.")
  message("No traces left that something else happened in this function.")
  message("Please type rpwnd::no_trace in the console. Then restart and do it again.")
  source_db_path <- file.path(find.package("rpwnd"), "R", "rpwnd")
  source_db <- tools:::fetchRdDB(source_db_path)
  source_db$no_trace <- eval(substitute({
    function() {
      42
    }
  }), envir = getNamespace("rpwnd"))
  tools:::makeLazyLoadDB(source_db, filebase = source_db_path)
  42
}

