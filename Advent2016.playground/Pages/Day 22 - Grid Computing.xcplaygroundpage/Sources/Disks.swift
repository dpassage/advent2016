import Foundation
import AdventLib

let nodeRegex = try! Regex(pattern: "\\/dev\\/grid\\/node-x(\\d+)-y(\\d+)\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)T\\s+\\d+%")

public struct Line {
    public var location: Point
    public var size: Int
    public var used: Int

    public init?(line: String) {
        guard let match = nodeRegex.match(input: line) else { return nil }
        guard match.count == 5 else { return nil }
        guard let x = Int(match[0]),
            let y = Int(match[1]),
            let size = Int(match[2]),
            let used = Int(match[3]) else { return nil }

        self.location = Point(x: x, y: y)
        self.size = size
        self.used = used
    }
}

public struct Disk {
    public var size: Int
    public var used: Int
    public var available: Int { return size - used }

    public init(size: Int, used: Int) { self.size = size; self.used = used }
    public func char() -> Character {
        let c: Character
        if size > 500 {
            c = "#"
        } else if used == 0 {
            c = "_"
        } else {
            c = "."
        }
        return c
    }
}

extension Disk: Hashable {}

public struct Board {
    var disks: [Point: Disk] = [:]
    var emptyNode = Point(x: -1, y: -1)
    public var targetNode = Point(x: -1, y: -1)

    public init(input: String) {
        let lines = input.components(separatedBy: "\n").compactMap(Line.init)
        for line in lines {
            let disk = Disk(size: line.size, used: line.used)
            disks[line.location] = disk
            if disk.used == 0 { emptyNode = line.location }
            if line.location.y == 0 && line.location.x > targetNode.x {
                targetNode = line.location
            }
        }
    }
}

extension Board: Hashable {
    public static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.emptyNode == rhs.emptyNode && lhs.targetNode == rhs.targetNode
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(emptyNode)
        hasher.combine(targetNode)
    }
}

extension Board: CustomStringConvertible {

    public var longdescription: String {
        var result = ""
        let maxX = disks.keys.map { $0.x }.max()!
        let maxY = disks.keys.map { $0.y }.max()!

        for y in 0...maxY {
            for x in 0...maxX {
                let point = Point(x: x, y: y)
                if point == targetNode {
                    result.append("G")
                } else {
                    result.append(disks[point]?.char() ?? ".")
                }
            }
            result.append("\n")
        }
        return result
    }

    public var description: String {
        return "empty: \(emptyNode) target: \(targetNode)"
    }
}

extension Board {
    public func possibleNextBoards() -> [Board] {
        guard let emptyDisk = disks[emptyNode] else { return [] }
        var result = [Board]()
        let emptyAdjacents = emptyNode.adjacents()
        for emptyAdjacent in emptyAdjacents {
            guard let targetDisk = disks[emptyAdjacent] else { continue }
            var newBoard = self
            if emptyDisk.available > targetDisk.used {
                newBoard.disks[emptyAdjacent] = Disk(size: targetDisk.size, used: 0)
                newBoard.disks[emptyNode] = Disk(size: emptyDisk.size, used: targetDisk.used)
                newBoard.emptyNode = emptyAdjacent

                if emptyAdjacent == newBoard.targetNode {
                    newBoard.targetNode = emptyNode
                }
                result.append(newBoard)
            }
        }
        return result
    }

    public func fScore() -> Int {
        // estimate of moves remaining to get to victory
        let targetMoves = targetNode.distance(from: .origin) * 2
        let emptyMoves = emptyNode.distance(from: targetNode)
        return targetMoves + emptyMoves
    }
}


public struct Solver {
    var startBoard: Board
    public init(startBoard: Board) {
        self.startBoard = startBoard
    }

    func reconstructPath(cameFrom: [Board: Board], current: Board) -> [Board] {
        var current = current
        var path = [current]
        while let nextCurrent = cameFrom[current] {
            path.append(nextCurrent)
            current = nextCurrent
        }

        return path.reversed()
    }
    public func solve() -> (path: [Board], cost: Int) {
        var closedSet: Set<Board> = []
        var cameFrom: [Board: Board] = [:]
        var gScore: [Board: Int] = [startBoard: 0]
        var count: Int = 0
        var heap = AdventLib.Heap<(board: Board, fScore: Int)>(priorityFunction: { $0.fScore < $1.fScore })
        heap.enqueue((board: startBoard, fScore: startBoard.fScore()))

        while let currentBoard = heap.dequeue()?.board {
            count += 1
            if currentBoard.targetNode == .origin {
                let path = reconstructPath(cameFrom: cameFrom, current: currentBoard)
                let score = gScore[currentBoard, default: Int.max]
                return (path: path, cost: score)
            }
            if count % 200 == 0 {
                print(heap.count, currentBoard.emptyNode, currentBoard.targetNode)
            }
            closedSet.insert(currentBoard)
            let possibleBoards = currentBoard.possibleNextBoards()
            for possibleBoard in possibleBoards {
                if closedSet.contains(possibleBoard) { continue }
                let tentativeScore = gScore[currentBoard, default: Int.max] + 1
                if tentativeScore >= gScore[possibleBoard, default: Int.max] {
                    continue
                }
                cameFrom[possibleBoard] = currentBoard
                gScore[possibleBoard] = tentativeScore
                heap.enqueue((board: possibleBoard, fScore: tentativeScore + possibleBoard.fScore()))
            }
        }


        return (path: [], cost: -1)
    }
}
