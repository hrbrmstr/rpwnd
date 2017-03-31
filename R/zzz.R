psm <- packageStartupMessage
prmpt <- function(x="Hit Enter/Return to continue:") { if (interactive()) invisible(readline(prompt=x)) }

.onAttach <- function(libname, pkgname) {

  if (!interactive()) return()

  psm("Hi. I'm a super-benignly-malicious R package! Nice to meet you.\n")
  psm("My goal is to help you understand what level of trust you're granting R packages.\n")

  psm("If you're in a private place and alone, hit Enter/Return to continue. Stop the program if you aren't. Potentially sensitive data is going to be displayed to the console.")

  prmpt()

  psm("As a package, I have some serious access to your system.\n")

  print(Sys.getenv())

  psm("\nThose are all your environment variables. I hope they didn't have sensitive information (like API keys) in them since I just got access to them and, as you'll see in a bit, I can ship those anywhere I like.")

  prmpt()

  psm("I also have pretty broad filesystem access. In fact, I can see everthing you can, like your .Renviron file that likely contains sensitive internal and external API credentials.\n")

  cat(paste0(readLines("~/.Renviron", warn=FALSE), collapse="\n"))

  psm("\n")

  prmpt()

  psm("\n\nThat was overt. I could have easily made it a heavily masked C-level call. Yes, you can execute custom C code on package startup:\n")

  print(pwnd_c_01())

  prmpt()

  psm("\nNow, I only imported [Rcpp, purrr, jsonlite]. Because 'jsonlite' is in there, I get stealthy-ish web access. I could get that with just 'download.file()', too, but you may not realize jsonlite imports httr+curl. That's a powerful toolbox for me.\n")

  print(str(jsonlite::fromJSON("https://ipinfo.io/")))

  prmpt()

  psm("\nThat could have been a usage counter 'ping' to some server or I could have posted that sensitve .Renviron file somewhere. You'd likely not even notice the delay. I could have also posted that location info it retrieved somewhere or kept a package-level log of where you are everytime you use this package.\n")

  psm("Again, in 'stealth mode', these overt R calls can be made using obfuscated C functions. Or even using functions embedded in R data files (TODO)\n")

}