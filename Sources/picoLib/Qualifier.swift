public enum Qualifier {
    case narrow
    case wide

    init?(_ string: String) {
        switch string.lowercased() {
        case ".n":
            self = .narrow

        case ".w":
            self = .wide

        default:
            return nil
        }
    }
}
