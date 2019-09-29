import pulp as lp
import pandas as pd
import numpy as np











































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
        