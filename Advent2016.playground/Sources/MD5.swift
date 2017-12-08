import Foundation
import SecurityFoundation

public func md5(input: String) -> String {
    return md5(input: input, rounds: 1)
}

public func md5(input: String, rounds: Int) -> String {
    let inputData = input.data(using: .ascii)!

    let resultData = md5data(input: inputData, rounds: rounds)

    return String(data: resultData, encoding: .ascii)!
}

let ascii: [UInt8] = [
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    97,
    98,
    99,
    100,
    101,
    102
]

public func md5data(input: Data, rounds: Int) -> Data {
    var input = input

    for _ in 0..<rounds {
        let encodedData = md5data(input: input)

        let encodedCount = encodedData.count
        if input.count != encodedCount * 2 {
            let newData = Data(count: encodedData.count * 2)
            let inputCount = input.count
            input.replaceSubrange(0..<inputCount, with: newData)
        }

        input.withUnsafeMutableBytes { (input: UnsafeMutablePointer<UInt8>) -> Void in
            encodedData.withUnsafeBytes { (encodedData: UnsafePointer<UInt8>) -> Void in
                for i in 0..<encodedCount {
                    let byte = encodedData[i]
                    input[2 * i] = ascii[Int(byte >> 4)]
                    input[(2 * i) + 1] = ascii[Int(byte & 0xf)]
                }
            }
        }
    }

    return input
}


public func md5data(input: Data) -> Data {

    let digester = SecDigestTransformCreate(kSecDigestMD5, 0, nil)

    SecTransformSetAttribute(digester, kSecTransformInputAttributeName, input as NSData, nil)

    let encodedData = SecTransformExecute(digester, nil) as! NSData

    return encodedData as Data
}
