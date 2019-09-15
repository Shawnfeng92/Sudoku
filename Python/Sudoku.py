import pulp
import numpy
import csv

puzzleFile = "C://Users//Shawn//Documents//GitHub//Sudoku//puzzle.csv"
with open(puzzleFile, 'r') as f:
    reader = csv.reader(f, delimiter=',')
    # get all the rows as a list
    data = list(reader)
    # transform data into numpy array
    data = numpy.array(data).astype(float)