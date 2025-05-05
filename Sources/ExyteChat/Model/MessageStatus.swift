public enum MessageStatus: Equatable, Hashable, Sendable {
    case sending
    case sent
    case read
    case error(DraftMessage)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .sending:
            return hasher.combine("sending")
        case .sent:
            return hasher.combine("sent")
        case .read:
            return hasher.combine("read")
        case .error:
            return hasher.combine("error")
        }
    }

    public static func == (lhs: MessageStatus, rhs: MessageStatus) -> Bool {
        switch (lhs, rhs) {
        case (.sending, .sending):
            return true
        case (.sent, .sent):
            return true
        case (.read, .read):
            return true
        case ( .error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}
