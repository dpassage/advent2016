import Foundation
import AdventLib

public enum Arg {
    case literal(Int)
    case reg(String)

    public init(s: String) {
        if let num = Int(s) {
            self = .literal(num)
        } else {
            self = .reg(s)
        }
    }
}

extension Arg: CustomStringConvertible {
    public var description: String {
        switch self {
        case .literal(let n): return "\(n)"
        case .reg(let s): return s
        }
    }
}

let copyRg = try! Regex(pattern: "cpy (-?[0-9a-z]+) ([a-z]+)")
let incRg = try! Regex(pattern: "inc ([a-z]+)")
let decRg = try! Regex(pattern: "dec ([a-z]+)")
let jnzRg = try! Regex(pattern: "jnz (-?[0-9a-z]+) (-?[0-9a-z]+)")
let tglRg = try! Regex(pattern: "tgl ([0-9a-z]+)")
let outRg = try! Regex(pattern: "out (-?[0-9a-z]+)")

public enum Instr {
    case copy(Arg, Arg)
    case inc(Arg)
    case dec(Arg)
    case jnz(Arg, Arg)
    case tgl(Arg)
    case out(Arg)

    public init?(s: String) {
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
        } else if let match = outRg.match(input: s) {
            self = .out(Arg(s: match[0]))
        } else {
            return nil
        }
    }

    public func toggled() -> Instr {
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
        case .out:
            return self
        }
    }
}

extension Instr: CustomStringConvertible {
    public var description: String {
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
        case let .out(n):
            return "out \(n)"
        }
    }
}


public class Machine {
    var ip: Int = 0
    var instructions: [Instr] = []
    public var registers: [String: Int] = [:]
    public var breakpoints: [Int] = []
    public var output: [Int] = []
    public var debug: Bool = false

    public init() {}

    public func run1() {
        let instr = instructions[ip]
        if debug { print(instr) }
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
        case let .out(arg):
            let outValue: Int
            switch arg {
            case .literal(let n): outValue = n
            case .reg(let s): outValue = registers[s] ?? 0
            }
            print("output: \(outValue)")
            output.append(outValue)
            ip += 1
        }
    }

    public func printState() {
        print(ip, registers, output)
    }

    public func run(steps: Int = Int.max) {
        var count = 0
        while ip >= 0 && ip < instructions.count && !breakpoints.contains(ip) && count < steps && outputIsValid() {
            count += 1
            if (count % 1_000) == 0 { print(count) }
            if debug { printState() }
            run1()
        }
        printState()
    }

    public func load(_ prog: String) {
        instructions = prog.split(separator: "\n").map(String.init).compactMap({ (s) -> Instr? in
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


    public func outputIsValid() -> Bool {
        for (index, value) in output.enumerated() {
            let expected = index % 2
            if value != expected { return false }
        }
        return true
    }
}
