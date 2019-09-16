from pulp import *
import pandas

constraint = pandas.read_csv("constraints.csv", header = "infer")

puzzle = pandas.read_csv("puzzle.csv", header = None)

sudoku = LpProblem("the sudoku problem", pulp.LpMinimize)
choices = LpVariable.dicts("choices", list(range(729)), 0, 1, LpInteger)
sudoku += 0, "Arbitrary Objective Function"

for i in range(0,81*4):
    sudoku += sum(choices * list([1]*729)) == 1, ""
    
    
problem = LpProblem("problemName", LpMaximize)
# factory cost per day
cf0 = 450
cf1 = 420
cf2 = 400# factory throughput per day
f0 = 2000
f1 = 1500
f2 = 1000# production goal
goal = 80000# time limit
max_num_days = 30
# factories
num_factories = 3
factory_days = LpVariable.dicts("factoryDays", list(range(num_factories)), 0, 30, cat="Continuous")
# goal constraint
c1 = factory_days[0]*f0 + factory_days[1]*f1 + factory_days[2] * f2 >= goal# production constraints
c2 = factory_days[0]*f0 <= 2*factory_days[1]*f1
c3 = factory_days[0]*f0 <= 2*factory_days[2]*f2
c4 = factory_days[1]*f1 <= 2*factory_days[2]*f2
c5 = factory_days[1]*f1 <= 2*factory_days[0]*f0
c6 = factory_days[2]*f2 <= 2*factory_days[1]*f1
c7 = factory_days[2]*f2 <= 2*factory_days[0]*f0# adding the constraints to the problem
problem += c1
problem += c2
problem += c3
problem += c4
problem += c5
problem += c6
problem += c7