#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
CharacterVector pwnd_c_01() {
  return(wrap("Hi! I'm a C function call!"));
}

