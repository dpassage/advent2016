//: [Previous](@previous)

import Foundation
import AdventLib

let testInput = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"""

enum Space: Char {
    case open = "."
    case wall = "#"
}

struct Board: CustomStringConvertible {
    var grid: Rect<Space>
    var spots: [Char: Point] = [:]
    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        let width = lines.map { $0.count }.max()!
        let height = lines.count
        grid = Rect(width: width, height: height, defaultValue: .open)
        for (y, line) in lines.enumerated() {
            for (x, char) in line.chars.enumerated() {
                if let space = Space(rawValue: char) {
                    grid[x, y] = space
                } else if char.isDigit {
                    grid[x, y] = .open
                    spots[char] = Point(x: x, y: y)
                }
            }
        }
    }

    var description: String {
        var result = ""
        let spots = [Point: Char](uniqueKeysWithValues: self.spots.map { ($1, $0) })
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                if let spot = spots[Point(x: x, y: y)] {
                    result.append(char: spot)
                } else {
                    result.append(char: grid[x, y].rawValue)
                }
            }
            result.append("\n")
        }
        return result
    }
}


let testBoard = Board(input: testInput)
print(testBoard)

extension Board: Dijkstra {
    typealias Node = Point

    func neighborsOf(_ node: Point) -> [(node: Point, distance: Int)] {
        return node.adjacents()
            .filter { grid.isValidIndex($0) }
            .filter { grid[$0] == .open }
            .map { ($0, 1) }
    }

    func shortestPathLengths(from spot: Char) -> [Char: Int] {
        let startPoint = spots[spot]!
        let pointDistances = distances(from: startPoint)
        var result: [Char: Int] = [:]
        for (char, point) in spots {
            guard char != spot else { continue }
            if let distance = pointDistances[point] {
                result[char] = distance
            }
        }
        return result
    }

    struct Path: Hashable {
        var from: Char
        var to: Char
    }
    func pathLookupTable() -> [Path: Int] {
        var result = [Path: Int]()
        for start in spots.keys {
            let pathLengths = shortestPathLengths(from: start)
            for (to, distance) in pathLengths {
                result[Path(from: start, to: to)] = distance
            }
        }
        return result
    }
}

struct PathFinder {
    var distances: [Board.Path: Int]
    var spots: Set<Char>
    var shortestDistance: Int
    init(distances: [Board.Path: Int]) {
        self.distances = distances
        self.spots = Set(distances.keys.map { $0.from })
        self.shortestDistance = distances.values.min()!
    }

    struct Walk: Hashable {
        var nodes: [Char]
        var totalLength: Int

        func adding(node: Char, dist: Int) -> Walk {
            var result = self
            result.nodes.append(node)
            result.totalLength += dist
            return result
        }
    }

    func estimatedCost(from start: Walk) -> Int {
        let remaining = spots.subtracting(start.nodes).count
        return remaining * shortestDistance
    }

    func nextSteps(from current: Walk) -> [(walk: Walk, distance: Int)] {
        let currentSpot = current.nodes.last!
        let remainingSpots = spots.subtracting(current.nodes)
        return remainingSpots.map { (spot) -> (walk: Walk, distance: Int) in
            let distance = distances[Board.Path(from: currentSpot, to: spot)] ?? Int.max
            let newWalk = current.adding(node: spot, dist: distance)
            return (newWalk, distance)
        }
    }

    func aStar() -> Walk? {
        var closedSet: Set<Walk> = []
        let start = Walk(nodes: ["0"], totalLength: 0)
        var gScore: [Walk: Int] = [start: 0]

        var heap = AdventLib.Heap<(walk: Walk, fScore: Int)>(priorityFunction: { $0.fScore < $1.fScore })
        heap.enqueue((walk: start, fScore: estimatedCost(from: start)))

        while let current = heap.dequeue()?.walk {
            if current.nodes.count == spots.count {
                return current
            }
            closedSet.insert(current)

            for (neighbor, distance) in nextSteps(from: current) {
                if closedSet.contains(neighbor) { continue }
                let tentativeScore = gScore[current, default: Int.max] + distance
                if tentativeScore > gScore[neighbor, default: Int.max] {
                    continue
                }
                gScore[neighbor] = tentativeScore
                heap.enqueue((walk: neighbor, fScore: tentativeScore + estimatedCost(from: neighbor)))
            }
        }
        return nil
    }

}

print(testBoard.shortestPathLengths(from: "0"))
let testTable = testBoard.pathLookupTable()
print(testTable)
let testFinder = PathFinder(distances: testTable)
print(testFinder)
print(testFinder.aStar())

let url = Bundle.main.url(forResource: "day24.input", withExtension: "txt")!
let input = try! String(contentsOf: url)
let board = Board(input: input)
print(board)
print(board.spots)
print(board.shortestPathLengths(from: "0"))
let boardTable = board.pathLookupTable()
let boardFinder = PathFinder(distances: boardTable)
print(boardFinder.aStar())


//: [Next](@next)
