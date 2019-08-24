library(lpSolve)

puzzle <- read.csv(file = "Puzzle.csv", header = FALSE)

# create a vector of length of 729
objective.in <- rep(1, 729)

# create a rhs vector
const.rhs <- rep(1, 729)

