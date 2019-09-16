from pulp import *
import pandas

constraint = pandas.read_csv("constraints.csv", header = "infer")

puzzle = pandas.read_csv("puzzle.csv", header = None)

sudoku = LpProblem("the sudoku problem", pulp.LpMinimize)
choices = LpVariable.dicts("choices", list(range(729)), 0, 1, LpInteger)
sudoku += 0, "Arbitrary Objective Function"

for i in range(0,81*4):
    sudoku += sum(choices[j] * constraint.iloc[j,i] for j in range(729)) == 1, ""
    
# The problem is solved using PuLP's choice of Solver
sudoku.solve()

# The status of the solution is printed to the screen
print("Status:", LpStatus[sudoku.status])


