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
    let chars = string.characters
    guard chars.count >= 4 else { return false }
    for i in 0..<(chars.count - 4) {

    }
    return isAbba(Array(string.characters))
}
print(isAbbaString("abba"))
print(isAbbaString("0000"))
print(isAbbaString("ioxxoj"))

let input = try! String(contentsOf: #fileLiteral(resourceName: "test.input.txt"), encoding: .ascii)

let brackets = CharacterSet(charactersIn: "[]")

func supportsTLS(_ input: String) -> Bool {

    let words = input.components(separatedBy: brackets)
    print("words: \(words)")
    guard words.count == 3 else { return false }
//    if isAbbaString(words[0]) && !isAbbaString(words[2]) { return false }
//    if isAbbaString(words[1]) { return false }
    return (isAbbaString(words[0]) || isAbbaString(words[2])) && !isAbbaString(words[1])
}

let lines = input.components(separatedBy: "\n")

print(lines[0].components(separatedBy: brackets))
print(lines.filter(supportsTLS).count)

supportsTLS("ioxxoj[asdfgh]zxcvbn")
//: [Next](@next)
let coordinatePrecision: Int32        = 10_000_000

let value: Int32 = 1802000000

func string(for number: Int32) -> String {

    var n = number
    var result = ""
    if n < 0 {
        result.append("-")
        n = -n
    }
    let degrees = n / coordinatePrecision
    let fraction = n % coordinatePrecision

    result.append(String(degrees))
    if fraction == 0 { return result }
    result.append(".")

    let fractionString = String(format: "%07d", fraction)
    result.append(fractionString)
    while result.hasSuffix("0") {
        result.removeLast()
    }
    return result
}

print(string(for: value))

