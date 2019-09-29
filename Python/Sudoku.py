import pulp as lp
import pandas as pd
import numpy as np

def puzzleToVector(x):
    # Read puzzle
    puzzle = pd.read_csv(x, header = "infer")
  
    # Transforming
    result = np.zeros(729)
    for i in range(9):
        for j in range(9):
            if (not pd.isna(puzzle.iloc[i,j])) :
                temp = np.zeros(729)
                temp[i*81 + j*9 + puzzle[i,j]] = 1
                result = np.vstack((result, temp))
  
    # Finished
    return(result[1:-1][:])

def vectorToPuzzle(x):
    result = np.zeros(shape=(3,3))
    for i in range(729):
        if(x[i] != 0):
            result[i//81][i%81//9] = i % 9 + 1
    return(result)
    
def createCMatrix(x, output = False, name = "ConstraintMatrix.csv"):
    # Create result matrix
    cMatrix = puzzleToVector(x)
    
    rowNumber = np.array([1])
    colNumber = np.array([1])
    celNumber = np.array([1])
    
    for i in range(9):
        rowNumber = np.hstack((rowNumber, np.ones(81) * (i+1)))
        
    for i in range(9):
        for j in range(9):
            colNumber = np.hstack((colNumber, np.ones(9) * (j+1)))
    
    for i in range(81):
        celNumber = np.hstack((celNumber, np.arange(1,10,1)))






































constraint = pd.read_csv("constraints.csv", header = "infer")

puzzle = pd.read_csv("puzzle.csv", header = None)

sudoku = LpProblem("the sudoku problem", pulp.LpMinimize)
choices = LpVariable.dicts("choices", list(range(729)), 0, 1, LpInteger)
sudoku += 0, "Arbitrary Objective Function"

for i in range(0,81*4):
    sudoku += sum(choices[j] * constraint.iloc[j,i] for j in range(729)) == 1, ""

puzzle = pandas.read_csv("puzzle.csv", header = None)
for i in range(3):
    for j in range(3):
        if(not pandas.isna(puzzle.iloc[i,j])):
            sudoku += choices[i*81 + j*9 + puzzle.iloc[i,j] - 1] == 1, ""
            
# The problem is solved using PuLP's choice of Solver
sudoku.solve()

i = 0
x = [0] * 729
while LpStatus[sudoku.status] == "Optimal":
    print(i)
    i = i + 1
    for j in range(729):
        x[j] = value(choices[j])
    sudoku += sum(choices[j] * x[j] for j in range(729)) <= 80, ""
    sudoku.solve()

for i in range(729):
    if(value(choices[i]) != 0):
        result[i//81][i%81//9] = i % 9 + 1
        