//: [Previous](@previous)

import Foundation

func generate(start: String) -> String {
    let a = start
    let b = start.reversed()

    let newB = b.map { c -> Character in
        switch c {
        case "0": return "1"
        case "1": return "0"
        default: fatalError("bad input")
        }
    }

    return a + "0" + String(newB)
}

print(generate(start: "1"))
print(generate(start: "0"))
print(generate(start: "11111"))
print(generate(start: "111100001010"))

func fillDisk(size: Int, start: String) -> String {
    var result = start

    while result.count < size {
        result = generate(start: result)
    }

    return String(result.prefix(size))
}

print(fillDisk(size: 20, start: "10000"))

func checksum(s: String) -> String {
    var result = ""

    var iterator = s.makeIterator()
    while let a = iterator.next(), let b = iterator.next() {
        switch (a, b) {
        case ("0", "0"), ("1", "1"): result.append("1")
        case ("0", "1"), ("1", "0"): result.append("0")
        default: fatalError("bad input")
        }
    }

    return result
}

func reducedChecksum(s: String) -> String {
    var result = s
    while result.count % 2 == 0 {
        print(result.count)
        result = checksum(s: result)
    }
    return result
}

print(checksum(s: "110010110100"))
print(reducedChecksum(s: "110010110100"))

print(reducedChecksum(s: fillDisk(size: 20, start: "10000")))

print(reducedChecksum(s: fillDisk(size: 272, start: "01111001100111011")))


print(reducedChecksum(s: fillDisk(size: 35651584, start: "01111001100111011")))

//: [Next](@next)

