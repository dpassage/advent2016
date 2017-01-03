import Foundation

public class Regex {
    let regex: NSRegularExpression

    public init(pattern: String) throws {
        regex = try! NSRegularExpression(pattern: pattern, options: [])
    }

    // returns nil if match failed, otherwise returns array of groups matched.
    // if no groups in pattern, returns empty array on match
    public func match(input: String) -> [String]? {
        let inputString = input as NSString
        guard let match = regex.matches(in: input, options: [], range: NSRange(location: 0, length: inputString.length)).first else { return nil }

        var result = [String]()
        let results = match.numberOfRanges

        for i in 1..<results {
            result.append(inputString.substring(with: match.rangeAt(i)))
        }

        return result
    }
}
