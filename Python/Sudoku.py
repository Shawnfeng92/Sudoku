import pulp
import numpy
import pandas

puzzle = pandas.read_csv("puzzle.csv", header = None)

constraint = pandas.read_csv("constraints.csv", header = "infer")

