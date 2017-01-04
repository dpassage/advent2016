//: [Previous](@previous)

import Foundation
import SecurityFoundation

func md5(input: String) -> String {
    let inputData = input.data(using: .ascii)! as NSData

    let digester = SecDigestTransformCreate(kSecDigestMD5, 0, nil)

    SecTransformSetAttribute(digester, kSecTransformInputAttributeName, inputData, nil)

    let encodedData = SecTransformExecute(digester, nil) as! NSData

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

print(md5(input: ""))

func generate(input: String, length: Int = 8) -> String {
    var result = ""
    var index = 0

    while result.characters.count < length {
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
            print(index, result.characters.count)
        }
    }

    return result
}

print(generate(input: "abbhdwsy", length: 8))

//: [Next](@next)
