library(lpSolve)

puzzle <- read.csv(file = "Puzzle.csv", header = FALSE)

# create a vector of length of 729
objective.in <- rep(1, 729)
direction <- "min"

# create a rhs vector
const.rhs <- rep(1, 729)

# create every cell constraint
temp <-c()
for (i in 0:80) {
  temp1 <- c(rep(0,i*9), rep(1,9),rep(0,729-(i+1)*9))
  temp <- cbind(temp, temp1)
}

# creat every line and column constraints
for (i in 1:9) {
  for (j in 1:9) {
    temp1 <- 2:730
    temp1[which((temp1<=(i*81))&(temp1>=(i-1)*81)&((temp1-1)%%9==j))] <- 1
    temp1[which(temp1 > 1)] <- 0
    temp <- cbind(temp, temp1)
    temp1 <- 2:730
    temp1[which((temp1<=(j*81))&(temp1>=(j-1)*81)&((temp1-1)%%9==i))] <- 1
    temp1[which(temp1 > 1)] <- 0
    temp <- cbind(temp, temp1)
  }
}

# create every square constraint