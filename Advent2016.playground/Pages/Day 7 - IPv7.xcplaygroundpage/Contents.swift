//: [Previous](@previous)

import Foundation

func isAbba(_ input: [Character]) -> Bool {
    guard input.count == 4 else { return false }

    return input[0] == input[3] &&
        input[1] == input[2] &&
        input[0] != input[2]
}

func isAbba<S: StringProtocol>(s: S) -> Bool {
    guard s.count >= 4 else { return false }

    let first = s.startIndex
    let second = s.index(after: first)
    let third = s.index(after: second)
    let fourth = s.index(after: third)

    return s[first] == s[fourth] &&
        s[second] == s[third] &&
        s[first] != s[second]
}

func isAbbaString(_ string: String) -> Bool {
    guard string.count >= 4 else { return false }
    for i in string.indices {
        let substring = string[i..<string.endIndex]
        if isAbba(s: substring) { return true }
    }
    return false
}

print(isAbbaString("abba"))
print(isAbbaString("0000"))
print(isAbbaString("ioxxoj"))

let input = try! String(contentsOf: #fileLiteral(resourceName: "test.input.txt"), encoding: .ascii)

let brackets = CharacterSet(charactersIn: "[]")

extension Int {
    var isOdd: Bool {
        return (self & 1) == 1
    }
}

func supportsTLS(_ input: String) -> Bool {
    let words = input.components(separatedBy: brackets)
    if words.isEmpty { return false }
    var foundAbba = false
    for i in words.indices {
        if words[i].isEmpty { return false }
        let isAbba = isAbbaString(words[i])
        if !i.isOdd { foundAbba = foundAbba || isAbba }
        if i.isOdd && isAbba { return false }
    }

    return foundAbba
}

let lines = input.components(separatedBy: "\n")

print(lines[0].components(separatedBy: brackets))
print(lines.filter(supportsTLS).count)

supportsTLS("ioxxoj[asdfgh]zxcvbn")
supportsTLS("abcd[bddb]xyyx")
supportsTLS("aaaa[qwer]tyui")
supportsTLS("ioxxoj[asdfgh]zxcvbn")

supportsTLS("oxxo[xvwuujrfkqjmtqdh]abba[quzbelbcfxknvqc]abba")

let day7 = try! String(contentsOf: #fileLiteral(resourceName: "day7.input.txt"), encoding: .ascii)
let day7lines = day7.components(separatedBy: "\n")
print(day7lines.filter(supportsTLS).count)

//: [Next](@next)
