rm(list = ls())

library(lpSolve)

# Multi-OS support ----
system <- Sys.info()["sysname"]

# Read Puzzle ----
puzzleToVector <- function(x) {
  # Read puzzle ----
  puzzle <- try(read.csv(x, header = FALSE))
  
  # Verify puzzle valid or not ----
  if (class(puzzle) == "try-error") {
    return("No puzzle found.")
  }
  
  # Transforming ----
  result <- c()
  for (i in 1:9) {
    for (j in 1:9) {
      if (!is.na(puzzle[i,j])) {
        temp <- rep(0,729)
        temp[(i-1)*81 + (j-1)*9 + puzzle[i,j]] <- 1
        const.mat<- cbind(const.mat, temp)
      }
    }
  }
  
  # Finished ----
  return(result)
}

# Reveal puzzle ----
vectorToPuzzle <- function(x) {
  result <- matrix(NA, 9, 9)
  for (i in 1:729) {
    if (x[i] == 1) {
      result[(i-1)%/%81+1,(i-1)%%81%/%9+1] <- (i-1) %% 9 + 1
    }
  }
  return(result)
}

# Create full constraint matrix ----
creatCMatrix <- function(x, output = FALSE){
  # Create result matrix ----
  const.mat <- puzzleToVector(x)
  if (const.mat == "No puzzle found.") {
    stop("No puzzle found.")
  }
  
  # Create index vectors ----
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
  
  # Add spuare constraints ----
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
  
  # Add column constraints ----
  for (i in 1:9) {
    for (j in 1:9) {
      temp <- rep(2, 729)
      temp[which((colNumber == i) & (celNumber == j))] <- 1 
      temp[which(temp == 2)] <- 0
      const.mat<- cbind(const.mat, temp)
    }
  }
  
  # Add row constraints ----
  for (i in 1:9) {
    for (j in 1:9) {
      temp <- rep(2, 729)
      temp[which((rowNumber == i) & (celNumber == j))] <- 1 
      temp[which(temp == 2)] <- 0
      const.mat<- cbind(const.mat, temp)
    }
  }
  
  # Add one number per cell constraint ----
  for (i in 1:81) {
    const.mat<- cbind(const.mat, c(rep(0, (i-1)*9), rep(1, 9), rep(0, 729-i*9)))
  }
  
  # Add all non-negative constraints ----
  const.mat <- cbind(const.mat, diag(1, 729, 729))
  
  # Return Matrix ----
  return(const.mat)
}

# Solver Function ----
puzzleSolve <- function(x, solution = "one")
{
  # Creat right hand vector ----
  const.rhs <- c(rep(1, 81*4), rep(0, 729), rep(1, sum(puzzle > 0, na.rm = TRUE)))
  
  # Creat direction ----
  const.dir <- c(rep("=", 81*4), rep(">=", 729), rep("=", sum(puzzle > 0, na.rm = TRUE)))
  
  # Creat constraint matrix ----
  const.mat <- c(rep("=", 81*4), rep(">=", 729), rep("=", sum(puzzle > 0, na.rm = TRUE)))
  
  
  # Solve puzzle ----
  result <- lp(direction = "max", objective.in = rep(1, 729), const.mat = const.mat,
               const.dir = const.dir, const.rhs = const.rhs, 
               all.int = TRUE, transpose.constraints = FALSE)
  
}



# Find multiple solution ----
while(!result$status){
  const.mat <- cbind(const.mat, result$solution)
  const.rhs <- c(const.rhs, 80)
  const.dir <- c(const.dir, "<=")
  result <- lp(direction = "max", objective.in = rep(1, 729), 
               const.mat = const.mat, const.dir = const.dir, 
               const.rhs = const.rhs, all.int = TRUE, 
               transpose.constraints = FALSE)
}

