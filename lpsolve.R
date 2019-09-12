library(lpSolve)

puzzle <- read.csv(file = "Puzzle.csv", header = FALSE)

# create a vector of length of 729
objective.in <- rep(1, 729)
direction <- "min"

# create every cell constraint
const.mat  <-c()
for (i in 0:80) {
  temp <- c(rep(0,i*9), rep(1,9),rep(0,729-(i+1)*9))
  const.mat <- cbind(const.mat, temp)
}

# creat every row constraints
for (i in 1:9) {
  for (j in c(1:8,0)) {
    temp <- 2:730
    temp[which(((temp-1)<=(i*81))&((temp-1)>(i-1)*81)&((temp-1)%%9==j))] <- 1
    temp[which(temp > 1)] <- 0
    const.mat  <- cbind(const.mat, temp)
  }
}

# creat every column constraints
temp <- c()
for (i in 1:9) {
  temp <- rbind(temp, diag(1,81,81))
}
const.mat <- cbind(const.mat, temp)

# create every square constraint
for (i in 0:8) {
  temp <- c(rep(0,i*81), as.vector(diag(1, 9, 9)),rep(0,729-(i+1)*81))
  const.mat <- cbind(const.mat, temp)
}

# create every square constraint
for (i in 0:2) {
  for (j in 0:2) {
    for (k in c(1:8,0)) {
      temp <- rep(2, 729)
      temp[which(
        (as.integer((1:729)/9) >= i*3) & (as.integer((1:729)/9) < (i+1)*3) &
          (as.integer((1:729)/9) >= j*3) & (as.integer((1:729)/9) < (j+1)*3) &
          ((1:729)%%9 == k)
      )] <- 1
    }
    temp[which(temp > 1)] <- 0
    const.mat  <- cbind(const.mat, temp)
  }
}

# create direction
const.dir <- rep("==", ncol(const.mat))

# create a rhs vector
const.rhs <- rep(1, ncol(const.mat))

result <- lp(direction, objective.in, const.mat, const.dir, const.rhs,
              transpose.constraints = FALSE, all.int=TRUE, all.bin=TRUE)
write.csv(const.mat, "try.csv")
