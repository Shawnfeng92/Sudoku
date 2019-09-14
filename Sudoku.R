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

# Add one number per cell constraint
for (i in 1:81) {
  const.mat<- cbind(const.mat, c(rep(0, (i-1)*9), rep(1, 9), rep(0, 729-i*9)))
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
system <- Sys.info()["sysname"]

if (system == "Windows") {
  puzzle <- read.csv("GitHub/Sudoku/puzzle.csv", header = FALSE)
}

for (i in 1:9) {
  for (j in 1:9) {
    if (!is.na(puzzle[i,j])) {
      temp <- rep(0,729)
      temp[(i-1)*81 + (j-1)*9 + puzzle[i,j]] <- 1
      const.mat<- cbind(const.mat, temp)
    }
  }
}

# Add all non-negative constraints
const.mat <- cbind(const.mat, diag(1, 729, 729),diag(1, 729, 729))

# Release memory
rm(i, j, k, temp, celNumber, colNumber, rowNumber)

# output const.mat for debug
# write.csv(const.mat, "GitHub/Sudoku/debug.csv", row.names = FALSE)

system.time(result <- lp(direction = "max", objective.in = rep(1, 729), const.mat = const.mat, 
             const.dir = c(rep("=", ncol(const.mat)-729*2), rep(">=", 729), rep("<=", 729)), 
             const.rhs = c(rep(1, ncol(const.mat)-729*2), rep(0, 729), rep(1, 729)), 
             all.int = TRUE, transpose.constraints = FALSE)
)
# Write Puzzle
reveal <- function(x = puzzle) {
  result <- matrix(NA, 9, 9)
  for (i in 1:729) {
    if (x[i] == 1) {
      result[(i-1)%/%81+1,(i-1)%%81%/%9+1] <- (i-1) %% 9 + 1
    }
  }
  return(result)
}

reveal(result$solution)
