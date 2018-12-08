//: [Previous](@previous)

import Foundation

let testInput = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"""

struct Loc: Hashable {
    var x: Int
    var y: Int

    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

    static func ==(lhs: Loc, rhs: Loc) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func neighbors() -> [Loc] {
        let deltas = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        var result = [Loc]()
        for delta in deltas {
            let newX = self.x + delta.0
            let newY = self.y + delta.1
            if newX >= 0 && newY >= 0 { result.append(Loc(x: newX, y: newY)) }
        }
        return result
    }

    func distance(from: Loc) -> Int {
        return abs(self.x - from.x) + abs(self.y - from.y)
    }
}

enum Space {
    case open
    case wall

    init(c: Character) {
        switch c {
        case "#":
            self = .wall
        default:
            self = .open
        }
    }
}

extension Space {
    var printed: String {
        switch self {
        case .open: return "."
        case .wall: return "#"
        }
    }
}

extension Character {
    var isDigit: Bool {
        return ("0"..."9").contains(self)
    }
}

struct Board {
    var map: [[Space]] = []

    func spaceAt(loc: Loc) -> Space? {
        guard map.indices.contains(loc.y) else { return nil }
        let line = map[loc.y]
        guard line.indices.contains(loc.x) else { return nil }
        return line[loc.x]
    }

    var spots: [Int: Loc] = [:]

    class Memo {
        var shortestPaths: [String: Int] = [:]
        init() {}
    }

    private let memo = Memo()

    init(input: String) {
        let lines = input.split(separator: "\n")
        for (y, line) in lines.enumerated() {
            let mapLine = line.map(Space.init)
            map.append(mapLine)
            for (x, c) in line.enumerated() {
                if c.isDigit, let num = Int(String(c)) {
                    spots[num] = Loc(x: x, y: y)
                }
            }
        }
    }

    private struct PathRecord {
        var currentLoc: Loc
        var steps: Int

        func score(destination: Loc) -> Int {
            return currentLoc.distance(from: destination) + steps
        }
    }

    func shortestPath(from: Int, to: Int) -> Int {
        if let memoized = memo.shortestPaths["\(from),\(to)"] { return memoized }
        if let memoized = memo.shortestPaths["\(to),\(from)"] { return memoized }
        guard let fromLoc = spots[from], let toLoc = spots[to] else { return -1 }
        var visited: Set<Loc> = []
        var heap = Heap<PathRecord> { (left, right) -> Bool in
            left.score(destination: toLoc) < right.score(destination: toLoc)
        }
        heap.enqueue(Board.PathRecord(currentLoc: fromLoc, steps: 0))

        while let current = heap.dequeue() {
            if current.currentLoc == toLoc {
                memo.shortestPaths["\(from),\(to)"] = current.steps
                return current.steps
            }
            for neighbor in current.currentLoc.neighbors() {
                if visited.contains(neighbor) { continue } else { visited.insert(neighbor) }
                if let space = spaceAt(loc: neighbor), space == .open {
                    heap.enqueue(Board.PathRecord(currentLoc: neighbor, steps: current.steps + 1))
                }
            }
        }


        return -1
    }

    private struct TourRecord {
        var path: [Int]
        var score: Int
    }

    func pathCost(_ path: [Int]) -> Int {
        guard path.count > 1 else { return 0 }
        var result = 0
        for i in 0..<(path.count - 1) {
            result += shortestPath(from: path[i], to: path[i + 1])
        }
        return result
    }

    func shortestTourNearestNeighbor() -> Int {
        let nodes = spots.keys
        var path = [0]
        var currentCost = 0
        var currentNode = 0

        while path.count != nodes.count {
            let unusedNodes = nodes.filter { !path.contains($0) }
            print(unusedNodes)
            let nodeCosts = unusedNodes.map({ (node) -> (Int, Int) in
                let cost = shortestPath(from: currentNode, to: node)
                print(currentNode, node, cost)
                return (node, cost)
            })
            let sorted = nodeCosts.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.1 < rhs.1
            })
            let best = sorted.first!
            path.append(best.0)
            currentCost += best.1
            currentNode = best.0
            print(path, currentCost)
        }

        return currentCost
    }
}

extension Board {
    var printed: String {
        let spots = self.spots.map { (key, value) -> (Loc, Int) in
            return (value, key)
        }

        let result = map.enumerated().map { (y, line) -> String in
            let s = line.enumerated().map({ (x, space) -> String in
                if let spot = spots.first(where: { (loc, num) -> Bool in
                    loc == Loc(x: x, y: y)
                }) {
                    return "\(spot.1)"
                } else { return space.printed }
            }).joined()
            return s
        }.joined(separator: "\n")

        return result
    }
}

let testBoard = Board(input: testInput)
print(testBoard.printed)
print(testBoard.shortestPath(from: 3, to: 1))
print(testBoard.shortestPath(from: 3, to: 1))
print(testBoard.shortestTourNearestNeighbor())

let url = Bundle.main.url(forResource: "day24.input", withExtension: "txt")!
let input = try! String(contentsOf: url)
let board = Board(input: input)
//print(board.shortestPath(from: 0, to: 1))
//print(board.shortestTourNearestNeighbor())

//: [Next](@next)
