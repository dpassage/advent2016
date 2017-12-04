//: [Previous](@previous)

import Foundation

let roomPattern = "([a-z\\-]*)-([0-9]*)\\[([a-z]*)\\]"
let roomRegex = try! Regex(pattern: roomPattern)


extension UnicodeScalar {
    func rotated(_ n: UInt32) -> UnicodeScalar {
        let a: UnicodeScalar = "a"

        let index = (self.value - a.value)
        let rotatedIndex = (index + n) % 26

        let result = UnicodeScalar(rotatedIndex + a.value)!
        return result
    }
}
struct Room {
    var name: String
    var sector: Int
    var checksum: String

    init?(room: String) {
        guard let matches = roomRegex.match(input: room) else { return nil }
        guard matches.count == 3 else { return nil }

        self.name = matches[0]
        self.sector = Int(matches[1])!
        self.checksum = matches[2]
    }

    func decryptedName() -> String {
        let result = self.name.unicodeScalars.map { u -> UnicodeScalar in
            if u == "-" { return " " }
            return u.rotated(UInt32(sector))
        }

        let resultView = result.reduce(String.UnicodeScalarView(), { scalarView, u -> String.UnicodeScalarView in
            var result = scalarView
            result.append(u)
            return result
        })

        return String(resultView)
    }

    func isValid() -> Bool {

        var count = [Character: Int]()

        for char in name {
            guard char != "-" else { continue }

            if let current = count[char] {
                count[char] = current + 1
            } else {
                count[char] = 1
            }
        }

        let inverted = count.map { ($0.1, $0.0) }

        let sorted = inverted.sorted { (left, right) -> Bool in
            if left.0 == right.0 {
                return left.1 < right.1
            } else {
                return left.0 > right.0
            }
        }

        let firstFive = sorted.prefix(5)
        let testSum = firstFive.reduce("") { soFar, tuple -> String in

            let char = tuple.1
            return soFar.appending(String(char))
        }

        return testSum == checksum
    }
}

let first = "aaaaa-bbb-z-y-x-123[abxyz]"
print(Room(room: first)!.isValid())

let testInput = try! String(contentsOf: #fileLiteral(resourceName: "test.input.txt"))

for line in testInput.components(separatedBy: "\n") {
    guard let room = Room(room: line) else { continue }

    let isValid = room.isValid() ? "is" : "is not"
    print("room \(room.name) \(isValid) valid")
}

func computeResult(_ input: String) -> Int {
    let result = input.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .map { Room(room: $0)! }
        .filter { $0.isValid() }
        .reduce(0) { sum, room -> Int in
            return sum + room.sector
        }

    return result
}

print(computeResult(testInput))


let realInput = try! String(contentsOf: #fileLiteral(resourceName: "day4.input.txt"))
//print(computeResult(realInput))


let testDecrypt = Room(room: "qzmt-zixmtkozy-ivhz-343[abcde]")!
print(testDecrypt.decryptedName())

let validRooms = realInput.components(separatedBy: "\n")
    .filter { !$0.isEmpty }
    .map { Room(room: $0)! }
    .filter { $0.isValid() }
    .map { "\($0.sector): \($0.decryptedName())" }
    .filter { $0.contains("storage") }

for validRoom in validRooms {
    print(validRoom)
}

//: [Next](@next)
