//: [Previous](@previous)

import Foundation

func possible(sides: [Int]) -> Bool {
    guard sides.count == 3 else { return false }

    let sorted = sides.sorted()

    return sorted[0] + sorted[1] > sorted[2]
}

print(possible(sides: [5, 10, 8]))

func countPossible(input: String) -> Int {
    var count = 0
    for line in input.components(separatedBy: "\n").filter({ !$0.isEmpty })
    {
        let sideStrings = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let sides = sideStrings.map { Int($0)! }
        count += possible(sides: sides) ? 1 : 0
    }

    return count
}

let inputFileURL = #fileLiteral(resourceName: "day3.input.txt")

let testInput = "5  10    25\n"


print(countPossible(input: testInput))

let realInput = try! String(contentsOf: inputFileURL)
print(countPossible(input: realInput))

let parseTest = "101 301 501\n102 302 502\n103 303 503\n201 401 601\n202 402 602\n203 403 603\n"
func parseColumns(input: String) -> [[Int]] {
    var lines = input.components(separatedBy: "\n").filter({ !$0.isEmpty })

    var fullResult = [[Int]]()
    while !lines.isEmpty {
        let threeLines = lines.prefix(3)
        lines = Array(lines.suffix(from: 3))

        let splitIntoStrings: [[String]] = threeLines.map { $0.components(separatedBy: .whitespaces).filter { !$0.isEmpty } }

        let asInts: [[Int]] = splitIntoStrings.map { $0.map { Int($0)! } }

        let thisResult: [[Int]] = [
            [asInts[0][0], asInts[1][0], asInts[2][0]],
            [asInts[0][1], asInts[1][1], asInts[2][1]],
            [asInts[0][2], asInts[1][2], asInts[2][2]],
        ]

        fullResult.append(contentsOf: thisResult)
    }

    return fullResult
}

print(parseColumns(input: parseTest))

func countPossible(input: [[Int]]) -> Int {
    var result = 0
    for candidate in input {
        result += possible(sides: candidate) ? 1 : 0
    }

    return result
}

print(countPossible(input: parseColumns(input: parseTest)))

print(countPossible(input: parseColumns(input: realInput)))
//: [Next](@next)
