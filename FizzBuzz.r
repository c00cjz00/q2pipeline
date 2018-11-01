#!/usr/bin/env Rscript
# Bloody FizzBuzz
options(warn=-1)
f <- function(x) {
  x[as.numeric(x)%%3==0 & as.numeric(x)%%5==0] <- "FizzBuzz"
  x[as.numeric(x)%%3==0] <- "Fizz"
  x[as.numeric(x)%%5==0] <- "Buzz"
  x  
}
x <- 1:101
suppressWarnings(f(x))
