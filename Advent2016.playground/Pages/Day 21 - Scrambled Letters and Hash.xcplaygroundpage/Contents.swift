//: [Previous](@previous)

import Foundation

let swapPositionRegex = try! Regex(pattern : "swap position (\\d+) with position (\\d+)")
let swapLettersRegex = try! Regex(pattern: "swap letter ([a-z]) with letter ([a-z])")
let rotateRegex = try! Regex(pattern: "rotate (left|right) (\\d+) step")
let rotateOnLetterRegex = try! Regex(pattern: "rotate based on position of letter ([a-z])")
let reverseRegex = try! Regex(pattern: "reverse positions (\\d+) through (\\d+)")
let moveRegex = try! Regex(pattern: "move position (\\d+) to position (\\d+)")

let testInput = """
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
"""


extension Array where Element == Character {
    mutating func swap(letter: Character, with: Character) {
        guard let lindex = self.index(of: letter),
            let rindex = self.index(of: with) else { return }
        self.swapAt(lindex, rindex)
    }

    mutating func rotate(left: Bool, positions: Int) {
        if left {
            for _ in 0..<positions {
                let first = self.removeFirst()
                self.append(first)
            }
        } else {
            for _ in 0..<positions {
                let last = self.removeLast()
                self.insert(last, at: 0)
            }
        }
    }

    mutating func move(from: Int, to: Int) {
        let c = self.remove(at: from)
        self.insert(c, at: to)
    }

    mutating func rotateBased(on c: Character) {
        guard let index = index(of: c) else { return }

        let r = index + 1 + (index >= 4 ? 1 : 0)
        rotate(left: false, positions: r)
    }

    mutating func reverse(from: Int, to: Int) {
        let substring = self[from...to]
        let reversed = substring.reversed()
        self.replaceSubrange(from...to, with: reversed)
    }
}


func apply(input: String, to s: String) -> String {
    var chars = [Character](s)

    let lines = input.split(separator: "\n")

    for line in lines {
        let line = String(line)
        if let match = swapPositionRegex.match(input: line) {
            guard let i = Int(match[0]), let j = Int(match[1]) else { print("whoops!"); continue }
            chars.swapAt(i, j)
        } else if let match = swapLettersRegex.match(input: line) {
            guard let a = match[0].first, let b = match[1].first else { print("whoops!"); continue }
            chars.swap(letter: a, with: b)
        } else if let match = rotateRegex.match(input: line) {
            let leftRight = match[0]
            guard let steps = Int(match[1]) else { print("whoops!"); continue }
            chars.rotate(left: (leftRight == "left"), positions: steps)
        } else if let match = rotateOnLetterRegex.match(input: line) {
            guard let letter = match[0].first else { print("whoops!"); continue }
            chars.rotateBased(on: letter)
        } else if let match = reverseRegex.match(input: line) {
            guard let from = Int(match[0]), let to = Int(match[1]) else { print("whoops!"); continue }
            chars.reverse(from: from, to: to)
        } else if let match = moveRegex.match(input: line) {
            guard let from = Int(match[0]), let to = Int(match[1]) else { print("whoops!"); continue }
            chars.move(from: from, to: to)
        } else {
            print("not applied! \(line)")
        }
    }

    return String(chars)
}

//apply(input: "swap position 4 with position 0", to: "abcde") // ebcda
//apply(input: "swap letter d with letter b", to: "ebcda") // edcba
//apply(input: "reverse positions 0 through 4", to: "edcba") // abcde
//apply(input: "rotate left 1 step", to: "abcde") // bcdea
//apply(input: "move position 1 to position 4", to: "bcdea") // bdeac
//apply(input: "move position 3 to position 0", to: "bdeac") // abdec
//apply(input: "rotate based on position of letter b", to: "abdec") // ecabd
//apply(input: "rotate based on position of letter d", to: "ecabd") // decab
//apply(input: testInput, to: "abcde")

//apply(input: "move position 6 to position 3", to: "abcdefgh") // abcgdefh
//apply(input: "rotate right 3 steps", to: "abcgdefh") // efhabcgd
//apply(input: "move position 6 to position 3", to: "abefdcgh") // abegfdch
//
let input = try! String(contentsOf: #fileLiteral(resourceName: "day21.input.txt"))
print(apply(input: input, to: "abcdefgh"))

let tests = """
a_______
_a______
__a_____
___a____
____a___
_____a__
______a_
_______a
"""

for (i, line) in tests.split(separator: "\n").enumerated() {
    var chars = line.map { $0 }
    chars.rotateBased(on: "a")
    print(i, String(chars))
}

// rotate this many to get back to original position,
// indexed by current position.
// left is negative, right is positive
/*
 0 _a______
 1 ___a____
 2 _____a__
 3 _______a
 4 __a_____
 5 ____a___
 6 ______a_
 7 a_______
*/
let reverseIndexLookup: [Int] = [
    -1, // 0 goes to 7
    -1, // 1 goes to 0
    2,  // 2 goes to 4
    -2, // 3 goes to 1
    1, // 4 goes to 5
    -3, // 5 goes to 2
    0, // 6 goes to 6
    -4 // 7 goes to 3
]
extension Array where Element == Character {
    mutating func reverseRotate(on c: Character) {
        guard let index = index(of: c) else { return }

        let r = reverseIndexLookup[index]
        if r == 0 { return }
        rotate(left: (r < 0), positions: abs(r))
    }
}

func reverse(input: String, to s: String) -> String {
    var chars = [Character](s)

    let lines = input.split(separator: "\n")

    for line in lines.reversed() {
        let line = String(line)
        if let match = swapPositionRegex.match(input: line) {
            guard let i = Int(match[0]), let j = Int(match[1]) else { print("whoops!"); continue }
            chars.swapAt(j, i)
        } else if let match = swapLettersRegex.match(input: line) {
            guard let a = match[0].first, let b = match[1].first else { print("whoops!"); continue }
            chars.swap(letter: b, with: a)
        } else if let match = rotateRegex.match(input: line) {
            let leftRight = match[0]
            guard let steps = Int(match[1]) else { print("whoops!"); continue }
            chars.rotate(left: (leftRight != "left"), positions: steps)
        } else if let match = rotateOnLetterRegex.match(input: line) {
            guard let letter = match[0].first else { print("whoops!"); continue }
            chars.reverseRotate(on: letter)
        } else if let match = reverseRegex.match(input: line) {
            guard let from = Int(match[0]), let to = Int(match[1]) else { print("whoops!"); continue }
            chars.reverse(from: from, to: to)
        } else if let match = moveRegex.match(input: line) {
            guard let from = Int(match[0]), let to = Int(match[1]) else { print("whoops!"); continue }
            chars.move(from: to, to: from)
        } else {
            print("not applied! \(line)")
        }
    }

    return String(chars)
}

print(reverse(input: input, to: "fbgdceah"))

//: [Next](@next)
