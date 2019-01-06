//: [Previous](@previous)

import Foundation
import AdventLib


let machine = Machine()
let url = Bundle.main.url(forResource: "day25.input", withExtension: "txt")!
let program = try! String(contentsOf: url)
machine.load(program)
machine.debug = false
machine.registers["a"] = 1
machine.run(steps: 50_000)


machine.outputIsValid()

for i in 100..<10_000 {
    let iterMachine = Machine()
    print("trying \(i)")
    iterMachine.load(program)
    iterMachine.registers["a"] = i
    iterMachine.run(steps: 50_000)
    if iterMachine.outputIsValid() { break }
}

//: [Next](@next)
