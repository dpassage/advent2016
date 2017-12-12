//: [Previous](@previous)

import Foundation

extension Int {
    var isOdd: Bool { return self & 0x1 == 1 }
}

class Elf {
    let name: Int
    var next: Elf!
    var prev: Elf!

    init(name: Int) {
        self.name = name
        self.next = nil
        self.prev = nil
    }
}

func elfPresents(elves: Int) -> Int {

    guard elves > 1 else { return 1 }

    let first = Elf(name: 1)
    first.next = first

    var current = first
    for i in 2...elves {
        let newNode = Elf(name: i)
        newNode.next = current.next
        current.next = newNode
        current = newNode
    }

    current = first
    while !(current.next === current) {
        let newNext = current.next!.next!
        current.next = newNext
        current = newNext
    }

    return current.name
}

//elfPresents(elves: 5)
//elfPresents(elves: 27)
//print(elfPresents(elves: 3005290))

func elfHalfway(elves: Int) -> Int {
    guard elves > 1 else { return 1 }

    let first = Elf(name: 1)
    first.next = first
    first.prev = first

    var current = first
    for i in 2...elves {
        let newNode = Elf(name: i)
        newNode.next = current.next
        newNode.prev = current
        current.next.prev = newNode
        current.next = newNode
        current = newNode
    }

    var elfCount = elves

    current = first
    let jump = elves / 2
    var acrossFromCurrent = current
    for _ in 0..<jump {
        acrossFromCurrent = acrossFromCurrent.next
    }
    print(current.name, acrossFromCurrent.name)

    while !(current.next === current) {
        // remove node at acrossFromCurrent
        acrossFromCurrent.prev.next = acrossFromCurrent.next
        acrossFromCurrent.next.prev = acrossFromCurrent.prev

        // decrement elf count
        elfCount -= 1

        // move current forward
        current = current.next

        // move acrossFromCurrent forward
        acrossFromCurrent = acrossFromCurrent.next
        if !elfCount.isOdd {
            acrossFromCurrent = acrossFromCurrent.next
        }
    }
    return current.name
}

print(elfHalfway(elves: 5))
print(elfHalfway(elves: 3005290))

//: [Next](@next)
