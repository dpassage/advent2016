//: [Previous](@previous)

import Cocoa

struct Button {
    var number: Int = 5

    mutating func move(_ char: Character) {
        switch char {
        case "U": up()
        case "D": down()
        case "L": left()
        case "R": right()
        default: break
        }
    }

    mutating func up() {
        switch number {
        case 3, 13: number -= 2
        case 6...8, 10...12: number -= 4
        default: break
        }
    }

    mutating func down() {
        switch number {
        case 1, 11: number += 2
        case 2...4, 6...8: number += 4
        default: break
        }
    }

    mutating func left() {
        switch number {
        case 1, 2, 5, 10, 13: break
        default: number -= 1
        }
    }

    mutating func right() {
        switch number {
        case 1, 4, 9, 12, 13: break
        default: number += 1
        }
    }

    static func decode(_ code: String) -> String {
        var result = ""
        var current = Button(number: 5)

        for char in code {
            if char == "\n" {
                //                result.append("\(current.number)")
                result.append(String(format: "%X", current.number))
                print("soFar: \(result)")
                //                current = Button(number: 5)
            } else {
                current.move(char)
                print("move: \(char) button: \(current.number)")
            }
        }
        return result
    }
}


let test = "ULL\nRRDDD\nLURDL\nUUUUD\n"

print(Button.decode(test))

let doIt = "RDLULDLDDRLLLRLRULDRLDDRRRRURLRLDLULDLDLDRULDDLLDRDRUDLLDDRDULLLULLDULRRLDURULDRUULLLUUDURURRDDLDLDRRDDLRURLLDRRRDULDRULURURURURLLRRLUDULDRULLDURRRLLDURDRRUUURDRLLDRURULRUDULRRRRRDLRLLDRRRDLDUUDDDUDLDRUURRLLUDUDDRRLRRDRUUDUUULDUUDLRDLDLLDLLLLRRURDLDUURRLLDLDLLRLLRULDDRLDLUDLDDLRDRRDLULRLLLRUDDURLDLLULRDUUDRRLDUDUDLUURDURRDDLLDRRRLUDULDULDDLLULDDDRRLLDURURURUUURRURRUUDUUURULDLRULRURDLDRDDULDDULLURDDUDDRDRRULRUURRDDRLLUURDRDDRUDLUUDURRRLLRR\nRDRRLURDDDDLDUDLDRURRLDLLLDDLURLLRULLULUUURLDURURULDLURRLRULDDUULULLLRLLRDRRUUDLUUDDUDDDRDURLUDDRULRULDDDLULRDDURRUURLRRLRULLURRDURRRURLDULULURULRRLRLUURRRUDDLURRDDUUDRDLLDRLRURUDLDLLLLDLRURDLLRDDUDDLDLDRRDLRDRDLRRRRUDUUDDRDLULUDLUURLDUDRRRRRLUUUDRRDLULLRRLRLDDDLLDLLRDDUUUUDDULUDDDUULDDUUDURRDLURLLRUUUUDUDRLDDDURDRLDRLRDRULRRDDDRDRRRLRDULUUULDLDDDUURRURLDLDLLDLUDDLDLRUDRLRLDURUDDURLDRDDLLDDLDRURRULLURULUUUUDLRLUUUDLDRUDURLRULLRLLUUULURLLLDULLUDLLRULRRLURRRRLRDRRLLULLLDURDLLDLUDLDUDURLURDLUURRRLRLLDRLDLDRLRUUUDRLRUDUUUR\nLLLLULRDUUDUUDRDUUURDLLRRLUDDDRLDUUDDURLDUDULDRRRDDLLLRDDUDDLLLRRLURDULRUUDDRRDLRLRUUULDDULDUUUDDLLDDDDDURLDRLDDDDRRDURRDRRRUUDUUDRLRRRUURUDURLRLDURDDDUDDUDDDUUDRUDULDDRDLULRURDUUDLRRDDRRDLRDLRDLULRLLRLRLDLRULDDDDRLDUURLUUDLLRRLLLUUULURUUDULRRRULURUURLDLLRURUUDUDLLUDLDRLLRRUUDDRLUDUDRDDRRDDDURDRUDLLDLUUDRURDLLULLLLUDLRRRUULLRRDDUDDDUDDRDRRULURRUUDLUDLDRLLLLDLUULLULLDDUDLULRDRLDRDLUDUDRRRRLRDLLLDURLULUDDRURRDRUDLLDRURRUUDDDRDUUULDURRULDLLDLDLRDUDURRRRDLDRRLUDURLUDRRLUDDLLDUULLDURRLRDRLURURLUUURRLUDRRLLULUULUDRUDRDLUL\nLRUULRRUDUDDLRRDURRUURDURURLULRDUUDUDLDRRULURUDURURDRLDDLRUURLLRDLURRULRRRUDULRRULDLUULDULLULLDUDLLUUULDLRDRRLUURURLLUUUDDLLURDUDURULRDLDUULDDRULLUUUURDDRUURDDDRUUUDRUULDLLULDLURLRRLRULRLDLDURLRLDLRRRUURLUUDULLLRRURRRLRULLRLUUDULDULRDDRDRRURDDRRLULRDURDDDDDLLRRDLLUUURUULUDLLDDULDUDUUDDRURDDURDDRLURUDRDRRULLLURLUULRLUDUDDUUULDRRRRDLRLDLLDRRDUDUUURLRURDDDRURRUDRUURUUDLRDDDLUDLRUURULRRLDDULRULDRLRLLDRLURRUUDRRRLRDDRLDDLLURLLUDL\nULURLRDLRUDLLDUDDRUUULULUDDDDDRRDRULUDRRUDLRRRLUDLRUULRDDRRLRUDLUDULRULLUURLLRLLLLDRDUURDUUULLRULUUUDRDRDRUULURDULDLRRULUURURDULULDRRURDLRUDLULULULUDLLUURULDLLLRDUDDRRLULUDDRLLLRURDDLDLRLLLRDLDRRUUULRLRDDDDRUDRUULDDRRULLDRRLDDRRUDRLLDUDRRUDDRDLRUDDRDDDRLLRDUULRDRLDUDRLDDLLDDDUUDDRULLDLLDRDRRUDDUUURLLUURDLULUDRUUUDURURLRRDULLDRDDRLRDULRDRURRUDLDDRRRLUDRLRRRRLLDDLLRLDUDUDDRRRUULDRURDLLDLUULDLDLDUUDDULUDUDRRDRLDRDURDUULDURDRRDRRLLRLDLU\n"

print(Button.decode(doIt))

//: [Next](@next)
