import Foundation

extension String {
    func byAddingRightPadding(_ n: Int) -> String {
        guard self.count < n else { return self }
        return self + String(repeating: " ", count: n - self.count)
    }
}
