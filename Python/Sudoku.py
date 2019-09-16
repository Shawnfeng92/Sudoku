import pulp
import pandas

constraint = pandas.read_csv("constraints.csv", header = "infer")

puzzle = pandas.read_csv("puzzle.csv", header = None)

sudoku = pulp.LpProblem("the sudoku problem", pulp.LpMinimize)
choices = pulp.LpVariable.dicts("Choice", list(range(729)), 0, 1, pulp.LpInteger)
sudoku += 0, "Arbitrary Objective Function"

for i in range(0,81*4):
    sudoku += sum(choices * list(constraint.loc[:,i])) == 1, ""