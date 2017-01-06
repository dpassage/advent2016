//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

extension Int {
    var isOdd: Bool {
        return (self & 1) == 1
    }
}

4.isOdd
5.isOdd

func isAbba(_ input: [Character]) -> Bool {
    guard input.count == 4 else { return false }

    return input[0] == input[3] &&
        input[1] == input[2] &&
        input[0] != input[2]
}

func isAbbaString(_ string: String) -> Bool {
    return isAbba(Array(string.characters))
}
print(isAbbaString("abba"))
print(isAbbaString("0000"))

let input = try! String(contentsOf: #fileLiteral(resourceName: "test.input.txt"), encoding: .ascii)

let brackets = CharacterSet(charactersIn: "[]")


for line in input.components(separatedBy: "\n") {
    for (n, word) in line.components(separatedBy: brackets).enumerated() {
        if isAbba(Array(word.characters)) && n.isOdd { print("whee") }
    }
}

//: [Next](@next)
