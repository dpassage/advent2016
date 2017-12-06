//
//  main.swift
//  rtg
//
//  Created by David Paschich on 12/5/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import Foundation

//: [Previous](@previous)

import Foundation

enum Element {
    case hydrogen
    case lithium
    case prometheum
    case cobalt
    case curium
    case ruthenium
    case plutonium
    case elerium
    case dilithium
}

extension Element: Hashable {

}

enum ComponentType {
    case chip
    case generator
}

extension ComponentType: Hashable {

}

struct Component {
    var type: ComponentType
    var elem: Element
}

extension Component: Hashable {
    var hashValue: Int {
        return (elem.hashValue << 1) ^ type.hashValue
    }

    static func ==(lhs: Component, rhs: Component) -> Bool {
        return lhs.type == rhs.type && lhs.elem == rhs.elem
    }

    // Returns true iff the components can be alone together
    static func ~=(lhs: Component, rhs: Component) -> Bool {
        return lhs.type == rhs.type || lhs.elem == rhs.elem
    }
}

struct BuildingState {
    var elevatorFloor: Int = 0

    var floors: [Set<Component>] = []
}

extension Set where Element == Component {
    var safe: Bool {
        let generators = self.filter { $0.type == .generator }
        if generators.isEmpty { return true }
        let generatorElements = generators.map { $0.elem }
        let chips = self.filter { $0.type == .chip }
        for chip in chips {
            if generatorElements.contains(chip.elem) {
                continue
            } else {
                return false
            }
        }
        return true
    }

    func pairs() -> [(Component, Component)] {
        guard self.count > 1 else { return [] }
        var result: [(Component, Component)] = []
        let items = Array(self)
        for i in 0..<(self.count - 1) {
            for j in (i + 1)..<self.count {
                if items[i] ~= items[j] {
                    result.append((items[i], items[j]))
                }
            }
        }

        return result
    }

    // swiftlint:disable large_tuple
    func counts() -> (Int, Int, Int) {
        var pairCount = 0
        var chipcount = 0
        let chips = self.filter { $0.type == .chip }
        let gens = self.filter { $0.type == .generator }

        for chip in chips {
            if gens.contains(where: { $0.elem == chip.elem }) {
                pairCount += 1
            } else {
                chipcount += 1
            }
        }
        let genCount = count - ((2 * pairCount) + chipcount)
        return (pairCount, chipcount, genCount)
    }
    // swiftlint:enable large_tuple

    func countsHash() -> Int {
        let (one, two, three) = counts()
        return (one << 4) ^ (two << 2) ^ three
    }
}

extension BuildingState: Hashable {
    var hashValue: Int {
        return floors.map { $0.countsHash() }.reduce(elevatorFloor, ^)
    }

    static func == (lhs: BuildingState, rhs: BuildingState) -> Bool {
        if lhs.elevatorFloor != rhs.elevatorFloor { return false }
        for (leftFloor, rightFloor) in zip(lhs.floors, rhs.floors) {
            if leftFloor.counts() != rightFloor.counts() { return false }
        }
        return true
    }

    var safe: Bool {
        return floors.map { $0.safe }.reduce(true, { $0 && $1 })
    }

    var done: Bool {
        return floors[0].isEmpty && floors[1].isEmpty && floors[2].isEmpty
    }

    func next() -> [BuildingState] {
        var ret = [BuildingState]()
        let pairs = floors[elevatorFloor].pairs()
        let singles = floors[elevatorFloor]
        if elevatorFloor < 3 {
            for pair in pairs {
                var new = self
                new.floors[new.elevatorFloor].remove(pair.0)
                new.floors[new.elevatorFloor].remove(pair.1)
                new.elevatorFloor += 1
                new.floors[new.elevatorFloor].insert(pair.0)
                new.floors[new.elevatorFloor].insert(pair.1)
                if new.safe { ret.append(new) }
            }
            if ret.isEmpty {
                for single in singles {
                    var new = self
                    new.floors[new.elevatorFloor].remove(single)
                    new.elevatorFloor += 1
                    new.floors[new.elevatorFloor].insert(single)
                    if new.safe { ret.append(new) }
                }
            }
        }

        if elevatorFloor > 0 {
            var belowRet = [BuildingState]()
            let emptyBelow = floors[0..<elevatorFloor].map { $0.isEmpty }.reduce(true, { $0 && $1 })
            if !emptyBelow {
                for pair in pairs {
                    var new = self
                    new.floors[new.elevatorFloor].remove(pair.0)
                    new.floors[new.elevatorFloor].remove(pair.1)
                    new.elevatorFloor -= 1
                    new.floors[new.elevatorFloor].insert(pair.0)
                    new.floors[new.elevatorFloor].insert(pair.1)
                    if new.safe { belowRet.append(new) }
                }
                for single in singles {
                    var new = self
                    new.floors[new.elevatorFloor].remove(single)
                    new.elevatorFloor -= 1
                    new.floors[new.elevatorFloor].insert(single)
                    if new.safe { belowRet.append(new) }
                }

            }
            ret.append(contentsOf: belowRet)
        }

        return ret
    }
}

func solve(startState: BuildingState) -> Int {
    var queue: [(Int, BuildingState)] = [(0, startState)]
    var seenStates: Set<BuildingState> = [startState]
    var count = 0
    while !queue.isEmpty {
        count += 1
        if (count % 1_000) == 0 { print(count, queue.count) }
        let (moves, currentState) = queue.removeFirst()
        for state in currentState.next() {
            if state.done { return moves + 1 }
            if !seenStates.contains(state) {
                queue.append((moves + 1, state))
                seenStates.insert(state)
            } else {
            }
        }
    }
    return -1
}

let testState = BuildingState(elevatorFloor: 0, floors: [
    [Component(type: .chip, elem: .hydrogen), Component(type: .chip, elem: .lithium)],
    [Component(type: .generator, elem: .hydrogen)],
    [Component(type: .generator, elem: .lithium)],
    []
    ])

print(solve(startState: testState))

/*
 The first floor contains a promethium generator and a promethium-compatible microchip.
 The second floor contains a cobalt generator, a curium generator, a ruthenium generator, and a plutonium generator.
 The third floor contains a cobalt-compatible microchip, a curium-compatible microchip, a ruthenium-compatible
     microchip, and a plutonium-compatible microchip.
 The fourth floor contains nothing relevant.
 */

let startState = BuildingState(elevatorFloor: 0, floors: [
    [Component(type: .generator, elem: .prometheum),
     Component(type: .chip, elem: .prometheum),
     Component(type: .generator, elem: .elerium),
     Component(type: .chip, elem: .elerium),
     Component(type: .generator, elem: .dilithium),
     Component(type: .chip, elem: .dilithium)],
    [Component(type: .generator, elem: .cobalt), Component(type: .generator, elem: .curium),
     Component(type: .generator, elem: .ruthenium),Component(type: .generator, elem: .plutonium)],
    [Component(type: .chip, elem: .cobalt), Component(type: .chip, elem: .curium),
     Component(type: .chip, elem: .ruthenium), Component(type: .chip, elem: .plutonium)],
    []
    ])

print(solve(startState: startState))

//: [Next](@next)
