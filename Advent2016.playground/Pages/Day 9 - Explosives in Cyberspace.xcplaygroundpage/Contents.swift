//: [Previous](@previous)

import Foundation

enum State {
    case normal
    case firstnum(Int)
    case secondnum(Int, Int)
}

func decompressCount(input: String) -> Int {
    let chars = Array(input)

    var length = 0
    var cur = 0
    var state: State = .normal
    while cur < chars.count {
        let char = chars[cur]

        guard !" \n".contains(char) else { cur += 1; continue }
        
        switch state {
        case .normal:
            switch char {
            case "(":
                state = .firstnum(0)
            default:
                length += 1
            }
            cur += 1
        case .firstnum(let soFar):
            switch char {
            case "0"..."9":
                let digit = Int(String(char))!
                state = .firstnum(soFar * 10 + digit)
            case "x":
                state = .secondnum(soFar, 0)
            default:
                fatalError("syntax error")
            }
            cur += 1
        case .secondnum(let count, let rep):
            switch char {
            case "0"..."9":
                let digit = Int(String(char))!
                state = .secondnum(count, rep * 10 + digit)
                cur += 1
            case ")":
                length += count * rep
                cur += 1 + count // 1 for the parens, then the count
                state = .normal
            default:
                fatalError("syntax error")

            }
        }
    }
    return length
}

decompressCount(input: "ADVENT")
decompressCount(input: "A(1x5)BC")
decompressCount(input: "(3x3)XYZ")
decompressCount(input: "A(2x2)BCD(2x2)EFG")
decompressCount(input: "(6x1)(1x3)A")
decompressCount(input: "X(8x2)(3x3)ABCY")

let day9 = try! String(contentsOf: #fileLiteral(resourceName: "day9.input.txt"), encoding: .ascii)

decompressCount(input: day9)


func decompress2(input: String) -> Int {
    return decompress2recur(input: Array(input))
}

func decompress2recur(input: [Character]) -> Int {
    let chars = Array(input)
    var length = 0
    var cur = 0
    var state: State = .normal
    while cur < chars.count {
        let char = chars[cur]

        guard !" \n".contains(char) else { cur += 1; continue }

        switch state {
        case .normal:
            switch char {
            case "(":
                state = .firstnum(0)
            default:
                length += 1
            }
            cur += 1
        case .firstnum(let soFar):
            switch char {
            case "0"..."9":
                let digit = Int(String(char))!
                state = .firstnum(soFar * 10 + digit)
            case "x":
                state = .secondnum(soFar, 0)
            default:
                fatalError("syntax error")
            }
            cur += 1
        case .secondnum(let count, let rep):
            switch char {
            case "0"..."9":
                let digit = Int(String(char))!
                state = .secondnum(count, rep * 10 + digit)
                cur += 1
            case ")":
                let range = (cur + 1)..<(cur + 1 + count)
                let recur = input[range]
                let recurCount = decompress2recur(input: Array(recur))
                length += recurCount * rep
                cur += 1 + count // 1 for the parens, then the count
                state = .normal
            default:
                fatalError("syntax error")
            }
        }
    }
    return length
}

decompress2(input: "(3x3)XYZ") // 9
decompress2(input: "X(8x2)(3x3)ABCY") // 20
decompress2(input: "(27x12)(20x12)(13x14)(7x10)(1x12)A") // 241920
decompress2(input: "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") // 445

decompress2(input: day9)

//: [Next](@next)
