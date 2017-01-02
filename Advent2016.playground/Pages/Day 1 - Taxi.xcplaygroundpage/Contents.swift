//: [Previous](@previous)

import Cocoa

enum Direction {
    case north
    case south
    case east
    case west

    func left() -> Direction {
        switch self {
        case .north: return .west
        case .south: return .east
        case .east: return .north
        case .west: return .south
        }
    }

    func right() -> Direction {
        switch self {
        case .north: return .east
        case .south: return .west
        case .east: return .south
        case .west: return .north
        }
    }

    func turn(_ dir: Turn) -> Direction {
        switch dir {
        case .left: return left()
        case .right: return right()
        }
    }
}

enum Turn {
    case left
    case right
}

struct TaxiState {
    var x: Int = 0
    var y: Int = 0
    var pointing: Direction = .north

    var distance: Int { return abs(x) + abs(y) }

    func move(turn: Turn, distance: Int) -> TaxiState {
        let newDirection = pointing.turn(turn)

        var newX = x
        var newY = y

        switch newDirection {
        case .north: newX += distance
        case .south: newX -= distance
        case .east: newY += distance
        case .west: newY -= distance
        }
        return TaxiState(x: newX, y: newY, pointing: newDirection)
    }

    mutating func turn(_ turn: Turn) {
        pointing = pointing.turn(turn)
    }

    mutating func step() {
        switch pointing {
        case .north: x += 1
        case .south: x -= 1
        case .east: y += 1
        case .west: y -= 1
        }
    }

    static func parse(string: String) -> (Turn, Int)? {
        guard let first = string.characters.first else { return nil }
        let turn: Turn
        switch first {
        case "L": turn = .left
        case "R": turn = .right
        default: return nil
        }

        let index = string.characters.startIndex
        let next = string.characters.index(after: index)
        let rest = String(string.characters.suffix(from: next))

        let distance = Int(rest) ?? 0

        return (turn, distance)
    }

    func move(string: String) -> TaxiState {
        guard let first = string.characters.first else { return TaxiState() }
        let turn: Turn
        switch first {
        case "L": turn = .left
        case "R": turn = .right
        default: return TaxiState()
        }

        let index = string.characters.startIndex
        let next = string.characters.index(after: index)
        let rest = String(string.characters.suffix(from: next))

        let distance = Int(rest) ?? 0

        return move(turn: turn, distance: distance)
    }

    static func moves(_ input: String) -> TaxiState {
        let moves = input.components(separatedBy: ", ")
        let finalSpot = moves.reduce(TaxiState()) { current, move -> TaxiState in

            return current.move(string: move)
        }

        return finalSpot
    }

    static func movesFirstRevistedSpot(_ input: String) -> TaxiState {
        var visited: Set<String> = []
        var cur = TaxiState()

        let moves = input.components(separatedBy: ", ")

        for move in moves {
            let (turn, distance) = parse(string: move)!
            print("turn: \(turn) distance: \(distance)")
            cur.turn(turn)
            for _ in 0..<distance {
                cur.step()
                let curString = "\(cur.x), \(cur.y)"
                print("move: \(move) cur: \(curString)")
                if visited.contains(curString) {
                    return cur
                } else {
                    visited.insert(curString)
                }

            }
        }

        return cur
    }
}

let firstInput = "L2, L5, L5, R5, L2, L4, R1, R1, L4, R2, R1, L1, L4, R1, L4, L4, R5, R3, R1, L1, R1, L5, L1, R5, L4, R2, L5, L3, L3, R3, L3, R4, R4, L2, L5, R1, R2, L2, L1, R3, R4, L193, R3, L5, R45, L1, R4, R79, L5, L5, R5, R1, L4, R3, R3, L4, R185, L5, L3, L1, R5, L2, R1, R3, R2, L3, L4, L2, R2, L3, L2, L2, L3, L5, R3, R4, L5, R1, R2, L2, R4, R3, L4, L3, L1, R3, R2, R1, R1, L3, R4, L5, R2, R1, R3, L3, L2, L2, R2, R1, R2, R3, L3, L3, R4, L4, R4, R4, R4, L3, L1, L2, R5, R2, R2, R2, L4, L3, L4, R4, L5, L4, R2, L4, L4, R4, R1, R5, L2, L4, L5, L3, L2, L4, L4, R3, L3, L4, R1, L2, R3, L2, R1, R2, R5, L4, L2, L1, L3, R2, R3, L2, L1, L5, L2, L1, R4"
//let firstInput = "R8, R4, R4, R8"
let firstSpot = TaxiState.moves(firstInput)

print(firstSpot.distance)

let secondSport = TaxiState.movesFirstRevistedSpot(firstInput)
print(secondSport.distance)

//: [Next](@next)