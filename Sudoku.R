rm(list = ls())

library(lpSolve)

# Create index vectors
colNumber <- c()
rowNumber <- c()
celNumber <- c()

for (i in 1:9) {
  rowNumber <- c(rowNumber, rep(i,81)) 
}

for (i in 1:9) {
  for (j in 1:9) {
    colNumber <- c(colNumber, rep(j, 9))
  }
}

for (i in 1:81) {
  celNumber <- c(celNumber, 1:9)
}

const.mat<- c()

# Add spuare constraints
for (i in 0:2) {
  for (j in 0:2) {
    for (k in 1:9) {
      temp <- rep(2, 729)
      temp[which((rowNumber > i*3) & (rowNumber <= (i+1)*3) & 
             (colNumber > j*3) & (colNumber <= (j+1)*3) & 
             (celNumber == k))] <- 1 
      temp[which(temp == 2)] <- 0
      const.mat<- cbind(const.mat, temp)
    }
  }
}

# Add row constraints
for (i in 1:9) {
  for (j in 1:9) {
    temp <- rep(2, 729)
    temp[which((rowNumber == i) & (celNumber == j))] <- 1 
    temp[which(temp == 2)] <- 0
    const.mat<- cbind(const.mat, temp)
  }
}

# Add column constraints
for (i in 1:9) {
  for (j in 1:9) {
    temp <- rep(2, 729)
    temp[which((colNumber == i) & (celNumber == j))] <- 1 
    temp[which(temp == 2)] <- 0
    const.mat<- cbind(const.mat, temp)
  }
}

# Read puzzle
puzzle <- read.csv("Desktop/Sudoku/puzzle.csv", header = FALSE)

for (i in 1:9) {
  for (j in 1:9) {
    if (!is.na(puzzle[i,j])) {
      temp <- rep(0,729)
      temp[(i-1)*81 + (j-1)*9 + puzzle[i,j]] <- 1
      const.mat<- cbind(const.mat, temp)
    }
  }
}

rm(i, j, k, temp, celNumber, colNumber, rowNumber)

const.mat <- cbind(const.mat, diag(1, 729, 729))

result <- lp(direction = "min", objective.in = rep(1, 729), const.mat = const.mat, 
             const.dir = c(rep("=", ncol(const.mat)-729), rep(">=", 729)), 
             const.rhs = c(rep(1, ncol(const.mat)-729), rep(0, 729)),
             all.int = TRUE, transpose.constraints = FALSE)

result$solution