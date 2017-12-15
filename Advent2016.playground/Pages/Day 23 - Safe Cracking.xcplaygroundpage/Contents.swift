//: [Previous](@previous)

import Foundation


import Foundation

let copyRg = try! Regex(pattern: "cpy (-?[0-9a-z]+) ([a-z]+)")
let incRg = try! Regex(pattern: "inc ([a-z]+)")
let decRg = try! Regex(pattern: "dec ([a-z]+)")
let jnzRg = try! Regex(pattern: "jnz (-?[0-9a-z]+) (-?[0-9a-z]+)")
let tglRg = try! Regex(pattern: "tgl ([0-9a-z]+)")

enum Arg {
    case literal(Int)
    case reg(String)

    init(s: String) {
        if let num = Int(s) {
            self = .literal(num)
        } else {
            self = .reg(s)
        }
    }
}

extension Arg: CustomStringConvertible {
    var description: String {
        switch self {
        case .literal(let n): return "\(n)"
        case .reg(let s): return s
        }
    }
}

enum Instr {
    case copy(Arg, Arg)
    case inc(Arg)
    case dec(Arg)
    case jnz(Arg, Arg)
    case tgl(Arg)

    init?(s: String) {
        if let match = copyRg.match(input: s) {
            self = .copy(Arg(s: match[0]), Arg(s: match[1]))
        } else if let match = incRg.match(input: s) {
            self = .inc(Arg(s: match[0]))
        } else if let match = decRg.match(input: s) {
            self = .dec(Arg(s: match[0]))
        } else if let match = jnzRg.match(input: s) {
            self = .jnz(Arg(s: match[0]), Arg(s: match[1]))
        } else if let match = tglRg.match(input: s) {
            self = .tgl(Arg(s: match[0]))
        } else {
            return nil
        }
    }

    func toggled() -> Instr {
        switch self {
        case let .copy(arg1, arg2):
            return .jnz(arg1, arg2)
        case let .inc(arg1):
            return .dec(arg1)
        case let .dec(arg1):
            return .inc(arg1)
        case let .jnz(arg1, arg2):
            return .copy(arg1, arg2)
        case let .tgl(arg1):
            return .inc(arg1)
        }
    }
}

extension Instr: CustomStringConvertible {
    var description: String {
        switch self {
         case let .copy(src, dest):
            return "cpy \(src) \(dest)"
        case let .inc(reg):
            return "inc \(reg)"
        case let .dec(reg):
            return "dec \(reg)"
        case let .jnz(reg, jump):
            return "jnz \(reg) \(jump)"
         case let .tgl(n):
            return "tgl \(n)"
        }
    }
}

class Machine {
    var ip: Int = 0
    var instructions: [Instr] = []
    var registers: [String: Int] = [:]
    var breakpoints: [Int] = []

    func run1() {
        let instr = instructions[ip]
        switch instr {
        case let .copy(src, dest):
            guard case Arg.reg(let dreg) = dest else { print("illegal instr \(instr)"); break }
            let num: Int
            switch src {
            case .literal(let n): num = n
            case .reg(let s): num = registers[s] ?? 0
            }
            registers[dreg] = num
            ip += 1
        case let .inc(arg):
            guard case Arg.reg(let reg) = arg else { print("illegal instr \(instr)"); break }
            registers[reg] = (registers[reg] ?? 0) + 1
            ip += 1
        case let .dec(arg):
            guard case Arg.reg(let reg) = arg else { print("illegal instr \(instr)"); break }
            registers[reg] = (registers[reg] ?? 0) - 1
            ip += 1
        case let .jnz(val, jump):
            let dest: Int
            switch jump {
            case .literal(let n): dest = n
            case .reg(let s): dest = registers[s] ?? 0
            }
            let value: Int
            switch val {
            case .literal(let n): value = n
            case .reg(let s): value = registers[s] ?? 0
            }
            if value == 0 {
                ip += 1
            } else {
                ip += dest
            }
        case let .tgl(arg):
            let offset: Int
            switch arg {
            case .literal(let n): offset = n
            case .reg(let s): offset = registers[s] ?? 0
            }
            let target = ip + offset
            if instructions.indices.contains(target) {
                instructions[target] = instructions[target].toggled()
            }
            ip += 1
        }
    }

    func printState() {
        print(ip, registers)
        for (n, instr) in instructions.enumerated() {
            print(n, instr)
        }
    }
    func run() {
        var count = 0
        while ip >= 0 && ip < instructions.count && !breakpoints.contains(ip) {
            count += 1
            if (count % 1_000) == 0 { print(count) }
            run1()
        }
        printState()
    }

    func load(_ prog: String) {
        instructions = prog.split(separator: "\n").map(String.init).flatMap({ (s) -> Instr? in
            if let i = Instr(s: s) {
                return i
            } else {
                print("bad instr: \(s)")
                return nil
            }
        })
        ip = 0
        registers = [:]
    }
}

let testMachine = Machine()
let testProg = """
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
"""

//testMachine.load(testProg)
//testMachine.run()

let machine = Machine()
let prog = """
cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 94 c
jnz 80 d
inc a
inc d
jnz d -2
inc c
jnz c -5
"""

machine.load(prog)
machine.registers["a"] = 12
machine.printState()
machine.run()
//: [Next](@next)
