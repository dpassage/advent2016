//: [Previous](@previous)

import Foundation


struct Screen {
    var rows: [[Bool]]

    init(rows: Int, columns: Int) {
        let row = Array<Bool>(repeating: false, count: columns)
        self.rows = Array<Array<Bool>>(repeating: row, count: rows)
    }

    subscript(row: Int, column: Int) -> Bool {
        get {
            return rows[row][column]
        }
        set {
            rows[row][column] = newValue
        }
    }

    mutating func rect(width: Int, height: Int) {
        for row in 0..<height {
            for column in 0..<width {
                self[row, column] = true
            }
        }
    }

    mutating func rotate(column: Int, by: Int) {
        guard by > 0 else { return }
        let bottomRow = rows.count - 1
        let bottom = self[bottomRow, column]
        var row = rows.count - 2
        while row >= 0 {
            self[row + 1, column] = self[row, column]
            row -= 1
        }
        self[0, column] = bottom
        rotate(column: column, by: by - 1)
    }

    mutating func rotate(row: Int, by: Int) {
         guard by > 0 else { return }
        let columns = rows[0].count
        let rightColumn = columns - 1
        let right = self[row, rightColumn]
        var column = columns - 2
        while column >= 0 {
            self[row, column + 1] = self[row, column]
            column -= 1
        }
        self[row, 0] = right
        rotate(row: row, by: by - 1)
    }

    var lit: Int {
        return rows
            .map { (row) -> Int in
                return row.map { $0 ? 1 : 0 }.reduce(0, +)
            }
            .reduce(0, +)
    }
}

let rectCommand = try! Regex(pattern: "rect ([0-9]+)x([0-9]+)")

let rotateColumnCommand = try! Regex(pattern: "rotate column x=([0-9]+) by ([0-9]+)")
let rotateRowCommand = try! Regex(pattern: "rotate row y=([0-9]+) by ([0-9]+)")

extension Screen {
    mutating func command(_ input: String) {
        if let rectMatch = rectCommand.match(input: input) {
            let x = Int(rectMatch[0])!
            let y = Int(rectMatch[1])!
            self.rect(width: x, height: y)
        } else if let columnMatch = rotateColumnCommand.match(input: input) {
            let column = Int(columnMatch[0])!
            let by = Int(columnMatch[1])!
            self.rotate(column: column, by: by)
        } else if let rowMatch = rotateRowCommand.match(input: input) {
            let row = Int(rowMatch[0])!
            let by = Int(rowMatch[1])!
            self.rotate(row: row, by: by)
        }
    }
}

extension Screen {
    var output: String {
        return rows.map { (row) -> String in
            return String(row.map { (pixel) -> Character in pixel ? "#" : "." })
        }.joined(separator: "\n")
    }
}

var screen = Screen(rows: 3, columns: 7)
print(screen)
print("")
screen.command("rect 3x2")
print(screen)
print("")
screen.command("rotate column x=1 by 1")
print(screen)
print("")
screen.command("rotate row y=0 by 4")
print(screen)
print("")
screen.command("rotate column x=1 by 1")
print(screen); print("")
print(screen.lit)

let day8 = try! String(contentsOf: #fileLiteral(resourceName: "day8.input.txt"), encoding: .ascii)
let day8lines = day8.components(separatedBy: "\n")

var finalScreen = Screen(rows: 6, columns: 50)
for line in day8lines {
    finalScreen.command(line)
}

finalScreen.lit

print(finalScreen.output)


//: [Next](@next)
