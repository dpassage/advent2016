//: [Previous](@previous)

import Foundation

func legalMove(c: Character) -> Bool {
    switch c {
    case "0"..."9", "a": return false
    case "b"..."f": return true
    default: fatalError("invalid input")
    }
}

struct VaultPosition {
    var x: Int
    var y: Int
    var password: String
    var path: String

    func neighborPositions() -> [VaultPosition] {
        var result = [VaultPosition]()

        let hash = md5(input: "\(password)\(path)").map { $0 }
        // everything in this order: up, down, left, right
        let deltas = [(0, -1), (0, 1), (-1, 0), (1, 0)]
        let moves = ["U", "D", "L", "R"]

        for i in 0...3 {
            let newX = x + deltas[i].0
            let newY = y + deltas[i].1
            guard (0...3).contains(newX) && (0...3).contains(newY) else { continue }
            guard legalMove(c: hash[i]) else { continue }
            let newPath = path + moves[i]
            let newPosition = VaultPosition(x: newX, y: newY, password: password, path: newPath)
            result.append(newPosition)
        }
        return result
    }

    var distance: Int {
        return (3 - x) + (3 - y)
    }
}

let start = VaultPosition(x: 0, y: 0, password: "hijkl", path: "")
let firstStep = start.neighborPositions()
//print(firstStep)
let secondPosition = firstStep.first!

//print(secondPosition.neighborPositions())

func findShortestPath() -> String {
    let start = VaultPosition(x: 0, y: 0, password: "qzthpkfp", path: "")

    var heap = Heap<VaultPosition> { (left, right) -> Bool in
        if left.path.count == right.path.count {
            return left.distance < right.distance
        }
        return left.path.count < right.path.count
    }

    heap.enqueue(start)

    while let next = heap.dequeue() {
        print(next)
        if next.distance == 0 {
            return next.path
        }
        for neighbor in next.neighborPositions() {
//            print(neighbor)
            heap.enqueue(neighbor)
        }
    }

    return ""
}

//print(findShortestPath())

func findLongestPath() -> String {
    let start = VaultPosition(x: 0, y: 0, password: "qzthpkfp", path: "")

    var longestPath = ""
    var heap = Heap<VaultPosition> { (left, right) -> Bool in
        if left.path.count == right.path.count {
            return left.distance < right.distance
        }
        return left.path.count < right.path.count
    }

    heap.enqueue(start)

    while let next = heap.dequeue() {
        if next.distance == 0 {
            if next.path.count > longestPath.count {
                longestPath = next.path
                print(longestPath.count, heap.count)
            }
        } else {
            for neighbor in next.neighborPositions() {
                heap.enqueue(neighbor)
            }
        }
    }

    return longestPath
}

print(findLongestPath().count)

//: [Next](@next)
