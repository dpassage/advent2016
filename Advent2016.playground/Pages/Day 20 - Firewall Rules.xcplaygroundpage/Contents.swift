//: [Previous](@previous)

import Foundation

extension CountableClosedRange where Bound == Int {
    func isAdjacentTo(other: CountableClosedRange<Int>) -> Bool {
        let (lower, upper) = self.lowerBound < other.lowerBound ? (self, other) : (other, self)

        if lower.upperBound == Int.max { return false }
        return lower.upperBound + 1 == upper.lowerBound
    }

    func overlaps(other: CountableClosedRange<Int>) -> Bool {
        let (lower, upper) = self.lowerBound < other.lowerBound ? (self, other) : (other, self)

        return lower.upperBound > upper.lowerBound
    }
}


struct RangeSet {
    var ranges: [CountableClosedRange<Int>] = []

    mutating func insert(range: CountableClosedRange<Int>) {
        ranges.append(range)
    }

    func firstEmptySlot() -> Int? {
        var candidate = 0

        let sorted = ranges.sorted { (left, right) -> Bool in
            left.lowerBound < right.lowerBound
        }

        for range in sorted {
            print(range, candidate)
            if candidate < range.lowerBound { return candidate }
            guard range.upperBound != Int(UInt32.max) else { return nil }
            let afterRange = (range.upperBound + 1)
            candidate = max(candidate, afterRange)
        }
        return candidate
    }

    func countAllowed() -> Int {
        var sorted = ranges.sorted { (left, right) -> Bool in
            left.lowerBound < right.lowerBound
        }

        guard !sorted.isEmpty else { return Int(UInt32.max) }

        let first = sorted.removeFirst()
        var collapsed: [CountableClosedRange<Int>] = [first]

        while !sorted.isEmpty {
            let next = sorted.removeFirst()
            let last = collapsed.removeLast()
            print("next", next, "last", last)
            if next.isAdjacentTo(other: last) || next.overlaps(last) {
                let newLower = min(next.lowerBound, last.lowerBound)
                let newUpper = max(next.upperBound, last.upperBound)
                collapsed.append(newLower...newUpper)
            } else {
                collapsed.append(contentsOf: [last, next])
            }
        }
        print(collapsed)

        var allowed = Int(UInt32.max) + 1
        for range in collapsed {
            allowed -= range.count
        }
        return Int(allowed)
    }
}

var set = RangeSet()

set.insert(range: 5...8)
set.insert(range: 0...2)
set.insert(range: 4...7)

print(set)

print(set.firstEmptySlot() ?? "not found")
print(set.countAllowed())

var realset = RangeSet()

let input = try! String(contentsOf: #fileLiteral(resourceName: "day20.input.txt"))

for line in input.components(separatedBy: "\n") {
    let nums = line.components(separatedBy: "-")
    guard nums.count == 2 else { continue }
    guard let low = Int(nums[0]), let high = Int(nums[1]) else {
        continue
    }
    realset.insert(range: low...high)
}

print(realset.firstEmptySlot() ?? "not found")
print(realset.countAllowed())

//: [Next](@next)
