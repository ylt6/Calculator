import Foundation

func isInteger(_ v: Double) -> Bool {
    return floor(v) == v
}

extension String {
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
