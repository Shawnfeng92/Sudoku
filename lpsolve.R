library(lpSolve)

puzzle <- read.csv(file = "Puzzle.csv", header = FALSE)

# create a vector of length of 729
objective.in <- rep(1, 729)
direction <- "min"

# create a rhs vector
const.rhs <- rep(1, 729)

# create every cell constraint
temp <-c()
for (i in 0:8) {
  temp1 <- c(rep(0,i*9), rep(1,9),rep(0,729-(i+1)*9))
  temp <- cbind(temp, temp1)
}

# creat every line constraint
temp <- c()

for (i in 1:9) {
  for (j in 1:9) {
    temp1 <- 2:730
    temp1[which((temp1<=(i*9))&(temp1>=(i-1)*9)&((temp1-1)%%9==j))] <- 1
    temp <- cbind(temp, temp1)
  }
}
