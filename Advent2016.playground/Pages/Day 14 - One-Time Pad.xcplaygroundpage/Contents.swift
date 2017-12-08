//: [Previous](@previous)

import Foundation

// The MD5 implementation here uses the `SecDigestTransform` API, which turns out to be pretty slow - it tries
// to do things on background threads, incurring a fair amount of overhead.
// I actually solved part 2 using a command-line program and the CommonCrypto API; however, because the headers
// on that API aren't automatically imported into Swift, they aren't available in a playground.

let test = "abc18"
print(md5(input: test))

let threeRegex = try! Regex(pattern: "(.)\\1{2}")
let fiveRegex = try! Regex(pattern: "(.)\\1{4}")

struct Candidate {
    var index: Int
    var char: Character
    var hash: String
    var fiveHashIndex: Int?
}

func findHashes(salt: String, limit: Int, rounds: Int) {
    var candidates: [Candidate] = []
    var found = 0
    var index = 0

    while found < limit {
        let key = "\(salt)\(index)"
        let hash = md5(input: key, rounds: rounds)

        while let first = candidates.first, (first.index + 1000) < index {
            candidates.removeFirst()
        }

        while let first = candidates.first, let _ = first.fiveHashIndex {
            let candidate = candidates.removeFirst()
            print(found, candidate)
            found += 1
        }

        if let match = threeRegex.match(input: hash) {
            let char = match[0].first!
            let candidate = Candidate(index: index, char: char, hash: hash, fiveHashIndex: nil)
            candidates.append(candidate)
        }

        if let match = fiveRegex.match(input: hash) {
            let char = match[0].first!
            for i in 0..<candidates.count {
                if candidates[i].char == char && candidates[i].fiveHashIndex == nil && candidates[i].index != index {
                    candidates[i].fiveHashIndex = index
                }
            }

        }
        index += 1
    }
    print(found)
}

findHashes(salt: "abc", limit: 64, rounds: 2017)

//: [Next](@next)
