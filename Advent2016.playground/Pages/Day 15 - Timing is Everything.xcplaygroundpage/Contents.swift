//: [Previous](@previous)

import Foundation

struct Disc {
    var firstMatchTime: Int // first time at which disc is in the correct position
    var period: Int // time thereafter

    init(startPosition: Int, period: Int, distanceFromFront: Int) {
        self.period = period
        var targetPosition = -distanceFromFront
        while targetPosition < startPosition {
            targetPosition += period
        }
        self.firstMatchTime = targetPosition - startPosition
    }

    init(firstMatchTime: Int, period: Int) {
        self.firstMatchTime = firstMatchTime
        self.period = period
    }

    static func + (left: Disc, right: Disc) -> Disc {
        var leftStart = left.firstMatchTime
        var rightStart = right.firstMatchTime

        while leftStart != rightStart {
            if leftStart < rightStart {
                leftStart += left.period
            } else {
                rightStart += right.period
            }
        }

        return Disc(firstMatchTime: leftStart, period: left.period * right.period)
    }
}

let test1 = Disc(startPosition: 4, period: 5, distanceFromFront: 1)
let test2 = Disc(startPosition: 1, period: 2, distanceFromFront: 2)

print(test1 + test2)

/*
 Disc #1 has 13 positions; at time=0, it is at position 11.
 Disc #2 has 5 positions; at time=0, it is at position 0.
 Disc #3 has 17 positions; at time=0, it is at position 11.
 Disc #4 has 3 positions; at time=0, it is at position 0.
 Disc #5 has 7 positions; at time=0, it is at position 2.
 Disc #6 has 19 positions; at time=0, it is at position 17.
 */

let disc1 = Disc(startPosition: 11, period: 13, distanceFromFront: 1)
let disc2 = Disc(startPosition: 0, period: 5, distanceFromFront: 2)
let disc3 = Disc(startPosition: 11, period: 17, distanceFromFront: 3)
let disc4 = Disc(startPosition: 0, period: 3, distanceFromFront: 4)
let disc5 = Disc(startPosition: 2, period: 7, distanceFromFront: 5)
let disc6 = Disc(startPosition: 17, period: 19, distanceFromFront: 6)

let onetwo = disc1 + disc2
print(onetwo)

let all = onetwo + disc3 + disc4 + disc5 + disc6
print(all)

let disc7 = Disc(startPosition: 0, period: 11, distanceFromFront: 7)

print(all + disc7)


//: [Next](@next)
