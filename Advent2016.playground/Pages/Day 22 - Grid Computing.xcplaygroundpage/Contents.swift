//: [Previous](@previous)

import Foundation

let nodeRegex = try! Regex(pattern: "\\/dev\\/grid\\/node-x(\\d+)-y(\\d+)\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)T\\s+\\d+%")

print(nodeRegex.match(input: "/dev/grid/node-x0-y0     85T   68T    17T   80%") ?? "no match")


struct Loc {
    var x: Int
    var y: Int
}

extension Loc: Hashable {
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

    static func ==(lhs: Loc, rhs: Loc) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func distance(from: Loc) -> Int {
        return abs(x - from.x) + abs(y - from.y)
    }
}

struct Node {
    var loc: Loc
    var size: Int
    var used: Int
    var avail: Int { return size - used }

    init?(line: String) {
        guard let match = nodeRegex.match(input: line) else { return nil }
        guard match.count == 5 else { return nil }
        guard let x = Int(match[0]),
            let y = Int(match[1]),
            let size = Int(match[2]),
            let used = Int(match[3]) else { return nil }

        self.loc = Loc(x: x, y: y)
        self.size = size
        self.used = used
    }
}

struct Board {
    var nodes: [Loc: Node] = [:]
    var emptyNode = Loc(x: -1, y: -1)
    var targetNode = Loc(x: -1, y: -1)
    var moves = 0

    init() {

    }

    mutating func add(_ node: Node) {
        nodes[node.loc] = node
        if node.used == 0 { emptyNode = node.loc }
        if node.loc.y == 0 && node.loc.x > targetNode.x {
            targetNode = node.loc
        }
    }

    mutating func add(nodes: [Node]) {
        for node in nodes {
            self.add(node)
        }
    }

    func nodeAt(x: Int, y: Int) -> Node? {
        let loc = Loc(x: x, y: y)
        return nodes[loc]
    }

    func neighbors(of loc: Loc) -> [Loc] {
        let deltas = [(0, 1), (1, 0), (0, -1), (-1, 0)]

        let locations = deltas.flatMap { (arg0) -> Loc in
            let (x, y) = arg0
            return Loc(x: loc.x + x, y: loc.y + y)
        }

        let neighbors = locations.filter { nodes.keys.contains($0) }

        return neighbors
    }

    mutating func move(nodeAt from: Loc, to: Loc) -> Bool {
        guard let source = nodes[from] else { return false }
        guard let target = nodes[to] else { return false }
        if source.used <= target.avail {
            nodes[from]?.used = 0
            nodes[to]?.used += source.used
            if to == emptyNode { emptyNode = from }
            if from == targetNode { targetNode = to }
            moves += 1
            return true
        }
        return false
    }

    func moving(nodeAt from: Loc, to: Loc) -> Board? {
        var new = self
        if new.move(nodeAt: from, to: to) {
            return new
        } else {
            return nil
        }
    }

    var score: Int {
        return (5 * emptyNode.distance(from: targetNode)) + targetNode.distance(from: Loc(x: 0, y: 0)) + moves
    }
}


func parseNodes(input: String) -> [Node] {
    var nodes: [Node] = []

    for line in input.split(separator: "\n") {
        if let node = Node(line: String(line)) {
            nodes.append(node)
        } else {
            print("unparsed line: \(line)")
        }
    }
    return nodes
}

func printBoard(nodes: [Node]) {
    guard let dimX = nodes.map({ $0.loc.x }).max() else { return }
    guard let dimY = nodes.map({ $0.loc.y }).max() else { return }

    print(dimX, dimY)
    let row = [Character](repeating: ".", count: dimX + 1)
    var board = [[Character]](repeating: row, count: dimY + 1)

    for node in nodes {
        let c: Character
        if node.size > 500 {
            c = "#"
        } else if node.used == 0 {
            c = "_"
        } else {
            c = "."
        }
        board[node.loc.y][node.loc.x] = c
    }

    for row in board {
        print(String(row))
    }
}

let input = try! String(contentsOf: #fileLiteral(resourceName: "day22.input.txt"))
printBoard(nodes: parseNodes(input: input))

func findPath(nodes: [Node]) -> Int {
    var heap = Heap<Board> { (lhs, rhs) -> Bool in
        lhs.score < rhs.score
    }

    var firstBoard = Board()
    firstBoard.add(nodes: nodes)
    heap.enqueue(firstBoard)

    while let currentBoard = heap.dequeue() {

    }


    return -1
}

//: [Next](@next)
