//: [Previous](@previous)

import Foundation

let bitLookup: [Int] = [
    0, // 0
    1, // 1
    1, // 2
    2, // 3
    1, // 4
    2, // 5
    2, // 6
    3, // 7
    1, // 8
    2, // 9
    2, // 10
    3, // 11
    2, // 12
    3, // 13
    3, // 14
    4, // 15
]

func bitsSet(_ n: Int) -> Int {
    var result = 0
    var n = UInt(bitPattern: n)

    while n != 0 {
        result += bitLookup[Int(n & 0xf)]
        n = n >> 4
    }

    return result
}

struct Loc {
    var x: Int
    var y: Int

    var favoriteNumber: Int = 1352

    init(x: Int, y: Int) {
        self.x = x; self.y = y
    }

    var isWall: Bool {
        let base = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + favoriteNumber
        let bits = bitsSet(base)
        return (bits & 1) == 1
    }

    func neighbors() -> [Loc] {
        var ret = [Loc]()
        let deltas = [(-1,0), (1,0), (0,1), (0,-1)]

        for delta in deltas {
            let newX = x + delta.0
            let newY = y + delta.1
            if newX >= 0 && newY >= 0 {
                ret.append(Loc(x: newX, y: newY))
            }
        }

        return ret
    }

    func distance(to: Loc) -> Int {
        return abs(x - to.x) + abs(y - to.y)
    }
}

extension Loc: Hashable {
    var hashValue: Int {
        return (x.hashValue << 4) ^ y.hashValue
    }

    static func ==(lhs: Loc, rhs: Loc) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Loc: CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}

// stolen from https://en.wikipedia.org/wiki/A*_search_algorithm
func stepsTo(_ goal: Loc) -> Int {
    let start = Loc(x: 1, y: 1)
    var closedSet: Set<Loc> = []
    var openSet: Set<Loc> = [start]
    var cameFrom: [Loc: Loc] = [:]
    var gScore: [Loc: Int] = [:]
    gScore[start] = 0
    var fScore: [Loc: Int] = [:]

    let distance = start.distance(to: goal)
    fScore[start] = distance

    while let current = openSet.min(by: { fScore[$0, default: Int.max] < fScore[$1, default: Int.max]}) {

        if current == goal { return path(cameFrom: cameFrom, current: current).count - 1 }

        openSet.remove(current)
        closedSet.insert(current)

        for neighbor in current.neighbors() {
            guard !neighbor.isWall else { continue }
            guard !closedSet.contains(neighbor) else { continue }

            openSet.insert(neighbor)

            let tentative_gScore = gScore[current, default: Int.max - 1] + 1
            if tentative_gScore >= gScore[neighbor, default: Int.max] { continue }

            cameFrom[neighbor] = current
            gScore[neighbor] = tentative_gScore
            fScore[neighbor] = tentative_gScore + neighbor.distance(to: goal)
        }

    }

    return -1
}

func path(cameFrom: [Loc: Loc], current: Loc) -> [Loc] {
    var current = current
    var result = [current]
    while let newCurrent = cameFrom[current] {
        current = newCurrent
        result.append(current)
    }
    return result
}

print(stepsTo(Loc(x: 31, y: 39)))

// MARK: - Part 2

struct Entry {
    var loc: Loc
    var distance: Int
}

// Simpler because we don't care if there are multiple paths to the same location, so long as
// there's a path within the goal.
func countNodesWithin(_ goal: Int) -> Int {
    let start = Loc(x: 1, y: 1)

    var withinGoal: Set<Loc> = [start]
    var heap = Heap<Entry>(priorityFunction: { $0.distance < $1.distance })

    heap.enqueue(Entry(loc: start, distance: 0))

    while let current = heap.dequeue() {
        let currentCost = current.distance
        let currentLoc = current.loc
        guard currentCost < goal else { continue }
        for neighbor in currentLoc.neighbors() {
            guard !neighbor.isWall else { continue }
            guard !withinGoal.contains(neighbor) else { continue }
            withinGoal.insert(neighbor)
            let entry = Entry(loc: neighbor, distance: currentCost + 1)
            heap.enqueue(entry)
        }
    }

    return withinGoal.count
}

print(countNodesWithin(50))

//: [Next](@next)
