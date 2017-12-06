//: [Previous](@previous)


import Foundation

let copyLiteralRg = try! Regex(pattern: "cpy (\\d+) ([a-z]+)")
let copyRg = try! Regex(pattern: "cpy ([a-z]+) ([a-z]+)")
let incRg = try! Regex(pattern: "inc ([a-z]+)")
let decRg = try! Regex(pattern: "dec ([a-z]+)")
let jnzRg = try! Regex(pattern: "jnz ([a-z]+) (-?\\d+)")
let jnzLiteralRg = try! Regex(pattern: "jnz (\\d+) (-?\\d+)")

enum Instr {
    case copyLiteral(Int, String)
    case copy(String, String)
    case inc(String)
    case dec(String)
    case jnz(String, Int)
    case jnzLiteral(Int, Int)

    init?(s: String) {
        if let match = copyLiteralRg.match(input: s) {
            self = .copyLiteral(Int(match[0])!, match[1])
        } else if let match = copyRg.match(input: s) {
            self = .copy(match[0], match[1])
        } else if let match = incRg.match(input: s) {
            self = .inc(match[0])
        } else if let match = decRg.match(input: s) {
            self = .dec(match[0])
        } else if let match = jnzRg.match(input: s) {
            self = .jnz(match[0], Int(match[1])!)
        } else if let match = jnzLiteralRg.match(input: s) {
            self = .jnzLiteral(Int(match[0])!, Int(match[1])!)
        } else {
            return nil
        }
    }
}

extension Instr: CustomStringConvertible {
    var description: String {
        switch self {
        case let .copyLiteral(num, reg):
            return "copy \(num) \(reg)"
        case let .copy(src, dest):
            return "copy \(src) \(dest)"
        case let .inc(reg):
            return "inc \(reg)"
        case let .dec(reg):
            return "dec \(reg)"
        case let .jnz(reg, jump):
            return "jnz \(reg) \(jump)"
        case let .jnzLiteral(num, jump):
            return "jnz \(num) \(jump)"
        }
    }
}

class Machine {
    var ip: Int = 0
    var instructions: [Instr] = []
    var registers: [String: Int] = [:]

    func run() {
        var count = 0
        while ip >= 0 && ip < instructions.count {
            count += 1
            if (count % 1_000) == 0 { print(count) }
            switch instructions[ip] {
            case let .copyLiteral(num, reg):
                registers[reg] = num
                ip += 1
            case let .copy(src, dest):
                registers[dest] = registers[src] ?? 0
                ip += 1
            case let .inc(reg):
                registers[reg] = (registers[reg] ?? 0) + 1
                ip += 1
            case let .dec(reg):
                registers[reg] = (registers[reg] ?? 0) - 1
                ip += 1
            case let .jnz(reg, jump):
                let value = registers[reg] ?? 0
                if value == 0 {
                    ip += 1
                } else {
                    ip += jump
                }
            case let .jnzLiteral(num, jump):
                if num == 0 {
                    ip += 1
                } else {
                    ip += jump
                }
            }
        }
        print(registers)
    }

    func load(_ prog: String) {
        instructions = prog.split(separator: "\n").map(String.init).flatMap(Instr.init)
        ip = 0
        registers = [:]
    }
}

let test = """
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
"""

let machine = Machine()

let input = """
cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 14 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5
"""

machine.load(input)
machine.registers["c"] = 1
machine.run()


//: [Next](@next)
