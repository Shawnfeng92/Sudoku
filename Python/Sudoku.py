from pulp import *
import pandas
import numpy

constraint = pandas.read_csv("constraints.csv", header = "infer")

puzzle = pandas.read_csv("puzzle.csv", header = None)

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

# The status of the solution is printed to the screen
print("Status:", LpStatus[sudoku.status])
result = [[0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0]]
for i in range(729):
    if(value(choices[i]) != 0):
        print(i//81)
        print(i%81//9)
        print(i)
        result[i//81][i%81//9] = i % 9 + 1