//: [Previous](@previous)

import Foundation

func decode(input: String) -> String {
    let lines = input.components(separatedBy: "\n")
    let width = lines[0].count

    var columns: [[Character: Int]] = Array(repeating: [:], count: width)

    for line in lines {
        guard !line.isEmpty else { continue }

        for (n, char) in line.enumerated() {
            if let cur = columns[n][char] {
                columns[n][char] = cur + 1
            } else {
                columns[n][char] = 1
            }
        }
    }

    var result = ""

    for column in columns {

        let sorted = column.sorted(by: { (left, right) -> Bool in
            left.value < right.value
        })

        let char = sorted.first!.key
        result.append(char)
    }

    return result
}

//let testInput = try! String(contentsOf: #fileLiteral(resourceName: "test.input.txt"), encoding: .ascii)
let testInput = try! String(contentsOf: #fileLiteral(resourceName: "day6.input.txt"), encoding: .ascii)
print(decode(input: testInput))

//: [Next](@next)
