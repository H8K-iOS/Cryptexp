import Foundation

extension String {
    var removingHTMLOccurances: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
