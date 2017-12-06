//: [Previous](@previous)

import Foundation
import SecurityFoundation

func md5(input: String) -> String? {
    guard let inputData = input.data(using: .ascii) as NSData? else { return nil }

    let digester = SecDigestTransformCreate(kSecDigestMD5, 0, nil)

    SecTransformSetAttribute(digester, kSecTransformInputAttributeName, inputData, nil)

    guard let encodedData = SecTransformExecute(digester, nil) as? NSData else { return nil }

    let bytes = encodedData.bytes.assumingMemoryBound(to: UInt8.self)
    var digestHex = ""
    for i in 0..<encodedData.length {
        digestHex += String(format: "%02x", bytes[i])
    }

    return digestHex
}

func md5data(input: String) -> Data {
    let inputData = input.data(using: .ascii)! as NSData

    let digester = SecDigestTransformCreate(kSecDigestMD5, 0, nil)

    SecTransformSetAttribute(digester, kSecTransformInputAttributeName, inputData, nil)

    let encodedData = SecTransformExecute(digester, nil) as! NSData

    return encodedData as Data
}

print(md5(input: "") ?? "nil")

func generate(input: String, length: Int = 8) -> String {
    var result = ""
    var index = 0

    while result.count < length {
        let withIndex = input.appending(String(index))
        let hashData = md5data(input: withIndex)
        hashData.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> Void in
            if bytes[0] == 0 &&
                bytes[1] == 0 &&
                bytes[2] & 0xf0 == 0 {

                let nextChar = String(format: "%x", bytes[2])
                print("nextChar: \(nextChar) index: \(index)")
                result.append(nextChar)
            }
        })

//        let hash = md5(input: withIndex)
//        if hash.hasPrefix("00000") {
//            print("hash is \(hash)")
//            let index = hash.index(hash.startIndex, offsetBy: 5)
//            let nextChar = hash[index]
//            result.append(nextChar)
//        }
        index += 1
        if index % 10000 == 0 {
            print(index, result.count)
        }
    }

    return result
}

extension UInt8 {
    var hex: String {
        return String(format: "%x", self)
    }
}
func generatePartTwo(input: String) -> String {
    var result: [Character] = Array(repeating: "_", count: 8)
    var complete: Bool = false
    var index = 1910965

    while !complete {
        let withIndex = input.appending(String(index))
        let hashData = md5data(input: withIndex)
        complete = hashData.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> Bool in
            if bytes[0] == 0 &&
                bytes[1] == 0 &&
                bytes[2] & 0xf0 == 0 {

                print("interesting hash \(bytes[0].hex) \(bytes[1].hex) \(bytes[2].hex) \(bytes[3].hex)")
                let position = bytes[2] & 0x0f
                guard position < 8 else { return false }
                guard result[Int(position)] == "_" else { return false }
                let nextDigit = (bytes[3] & 0xf0) >> 4
                let nextChar = String(format: "%x", nextDigit).first!
                print("nextChar: \(nextChar) position: \(position) index: \(index)")
                result[Int(position)] = nextChar
                return !result.contains("_")
            } else {
                return false
            }
        })
        index += 1
        if index % 10000 == 0 {
            print(index, String(result))
        }
    }


    return String(result)
}

print(generatePartTwo(input: "abbhdwsy"))


//: [Next](@next)
