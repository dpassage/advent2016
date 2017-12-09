//: [Previous](@previous)

import Foundation

func countTraps(input: String, rows: Int) -> Int {
    let firstLine = input.map { $0 == "^" ? true : false }

    var count = firstLine.filter { !$0 }.count
    var currentLine = firstLine

    for _ in 1..<rows {
        let lineLength = currentLine.count
        currentLine.insert(false, at: 0)
        currentLine.append(false)

        var nextLine = [Bool]()
        for i in 0..<lineLength {
            let hasTrap: Bool
            switch (currentLine[i], currentLine[i + 1], currentLine[i + 2]) {
            case (true, true, false),
                 (false, true, true),
                 (true, false, false),
                 (false, false, true):
                hasTrap = true
            default:
                hasTrap = false
            }
            nextLine.append(hasTrap)
        }
        count += nextLine.filter { !$0 }.count
        currentLine = nextLine
    }
    return count
}

countTraps(input: ".^^.^.^^^^", rows: 10)

let input = "......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^.."
print(countTraps(input: input, rows: 40))

print(countTraps(input: input, rows: 400000))
//: [Next](@next)
