//: [Previous](@previous)

import Foundation
import AdventLib







let input = try! String(contentsOf: #fileLiteral(resourceName: "day22.input.txt"))
let board = Board(input: input)
print(board)
//print(board.possibleNextBoards())

let testInput = """
Filesystem            Size  Used  Avail  Use%
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T    0T    32T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    7T     1T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
"""

let testBoard = Board(input: testInput)
print(testBoard)
let testSolver = Solver(startBoard: testBoard)
print(testSolver.solve())

let day22solver = Solver(startBoard: board)

print(day22solver.solve()) // 219 is incorrect
                             // 210, my by-hand solution, is also incorrect
                             // 205 is correct!

//: [Next](@next)
