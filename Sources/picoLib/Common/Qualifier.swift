public enum Qualifier {
    case narrow
    case wide

    init?(_ string: String) {
        switch string.lowercased() {
        case Self.narrow.stringValue: self = .narrow
        case Self.wide.stringValue: self = .wide
        default: return nil
        }
    }

    var stringValue: String {
        switch self {
        case .narrow: return ".n"
        case .wide: return ".w"
        }
    }
}
