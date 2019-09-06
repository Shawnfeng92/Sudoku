library(lpSolve)

puzzle <- read.csv(file = "Puzzle.csv", header = FALSE)

# create a vector of length of 729
objective.in <- rep(1, 729)
direction <- "min"

# create a rhs vector
const.rhs <- rep(1, 729)

# create every cell constraint
const.mat  <-c()
for (i in 0:80) {
  temp <- c(rep(0,i*9), rep(1,9),rep(0,729-(i+1)*9))
  const.mat <- cbind(const.mat, temp)
}

# creat every line and column constraints
for (i in 1:9) {
  for (j in 1:9) {
    temp <- 2:730
    temp[which((temp<=(i*81))&(temp>=(i-1)*81)&((temp-1)%%9==j))] <- 1
    temp[which(temp > 1)] <- 0
    const.mat  <- cbind(const.mat, temp)
    temp <- 2:730
    temp[which((temp<=(j*81))&(temp>=(j-1)*81)&((temp-1)%%9==i))] <- 1
    temp[which(temp > 1)] <- 0
    const.mat  <- cbind(const.mat, temp)
  }
}

# create every square constraint
for (i in 0:8) {
  temp <- c(rep(0,i*81), as.vector(diag(1, 9, 9)),rep(0,729-(i+1)*81))
  const.mat <- cbind(const.mat, temp)
}

rm(i, j, temp)

# create direction


result <- lp (direction, objective.in, const.mat, const.dir, const.rhs,
              transpose.constraints = TRUE, int.vec, presolve=0, compute.sens=0,
              binary.vec, all.int=FALSE, all.bin=FALSE, scale = 196, dense.const,
              num.bin.solns=1, use.rw=FALSE)
