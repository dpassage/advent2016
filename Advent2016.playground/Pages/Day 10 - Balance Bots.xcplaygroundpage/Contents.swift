//: [Previous](@previous)

import Foundation

enum Dest: CustomStringConvertible {
    case bot(Int)
    case output(Int)

    var description: String {
        switch self {
        case .bot(let num): return "bot \(num)"
        case .output(let num): return "output \(num)"
        }
    }
}

let botRegex = try! Regex(pattern: "bot (\\d+) gives low to (\\w+) (\\d+) and high to (\\w+) (\\d+)")
struct BotInst: CustomStringConvertible {
    var bot: Int
    var low: Dest
    var high: Dest

    var description: String {
        return "bot \(bot) gives low to \(low) and high to \(high)"
    }
    init?(s: String) {
        guard let matches = botRegex.match(input: s) else {
            return nil
        }
        print("BotInst", matches)
        self.bot = Int(matches[0])!

        let lowTarget = Int(matches[2])!
        let highTarget = Int(matches[4])!
        switch matches[1] {
        case "bot":
            low = .bot(lowTarget)
        case "output":
            low = .output(lowTarget)
        default:
            return nil
        }

        switch matches[3] {
        case "bot":
            high = .bot(highTarget)
        case "output":
            high = .output(highTarget)
        default:
            return nil
        }
    }
}

let output = BotInst(s: "bot 74 gives low to output 16 and high to bot 57")
print("\(String(describing: output))")

let valueRegex = try! Regex(pattern: "value (\\d+) goes to bot (\\d+)")
struct ValueInst: CustomStringConvertible {
    var value: Int
    var bot: Int

    init?(s: String) {
        guard let matches = valueRegex.match(input: s) else {
            return nil
        }
        print("ValueInst", matches)
        self.value = Int(matches[0])!
        self.bot = Int(matches[1])!
    }

    var description: String {
        return "value \(value) goes to bot \(bot)"
    }
}

ValueInst(s: "value 37 goes to bot 97")

class BotRunner {
    // Contains chips held by each bot.
    // Since bots always give both away once they receive their second
    // chip, only need to keep one
    var botChips: [Int: Int] = [:]
    var botInstructions: [Int: BotInst] = [:]
    var valueInstructions: [ValueInst] = []

    var outputChips: [Int: Int] = [:]

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        for line in lines {
            print(line)
            if let botInstruction = BotInst(s: line) {
                botInstructions[botInstruction.bot] = botInstruction
            } else if let valueInstruction = ValueInst(s: line) {
                valueInstructions.append(valueInstruction)
            } else {
                print("unknown instruction \(line)")
            }
        }
    }

    var target: [Int] = []
    var found = false
    func give(chip newChip: Int, to bot: Int) {
        guard let currentChip = botChips[bot] else {
            botChips[bot] = newChip; return
        }
        guard let inst = botInstructions[bot] else {
            fatalError("bot \(bot) doesn't know what to do")
        }
        botChips.removeValue(forKey: bot)
        let chips = [newChip, currentChip].sorted()
        if chips == target {
            print("bot \(bot) has chips \(chips)")
            found = true
        }
        print("\(chips[0]) to \(inst.low) and \(chips[1]) to \(inst.high)")
        switch inst.low {
        case .bot(let targetBot):
            give(chip: chips[0], to: targetBot)
        case .output(let outputSlot):
            outputChips[outputSlot] = chips[0]
        }
        switch inst.high {
        case .bot(let targetBot):
            give(chip: chips[1], to: targetBot)
        case .output(let outputSlot):
            outputChips[outputSlot] = chips[1]
        }
   }

    func run(first: Int, second: Int) {
        target = [first, second].sorted()

        for valueInst in valueInstructions {
            print(valueInst)
            give(chip: valueInst.value, to: valueInst.bot)
        }
        print(outputChips)
    }
}

let testInput = """
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
"""

let testRunner = BotRunner(input: testInput)
testRunner.run(first: 5, second: 2)

//let day10file = URL(fileURLWithPath: "Resources/day10.input.txt")
let day10file = #fileLiteral(resourceName: "day10.input.txt")

let input = try! String(contentsOf: day10file, encoding: .ascii)
let runner = BotRunner(input: input)
runner.run(first: 61, second: 17)

print(runner.outputChips[0]! * runner.outputChips[1]! * runner.outputChips[2]!)
//: [Next](@next)
