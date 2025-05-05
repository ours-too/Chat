import Foundation

public struct MessageImp: Message {
    public var id: String
    public var user: User
    public var status: MessageStatus?
    public var createdAt: Date

    public var text: String
    public var attachments: [Attachment]
    public var reactions: [Reaction]
    public var giphyMediaId: String?
    public var recording: Recording?
    public var replyMessage: ReplyMessage?

    public var triggerRedraw: UUID?

    public init(
        id: String,
        user: User,
        status: MessageStatus? = nil,
        createdAt: Date = Date(),
        text: String = "",
        attachments: [Attachment] = [],
        giphyMediaId: String? = nil,
        reactions: [Reaction] = [],
        recording: Recording? = nil,
        replyMessage: ReplyMessage? = nil
    ) {
        self.id = id
        self.user = user
        self.status = status
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.giphyMediaId = giphyMediaId
        self.reactions = reactions
        self.recording = recording
        self.replyMessage = replyMessage
    }

    public static func makeMessage(
        id: String,
        user: User,
        status: MessageStatus? = nil,
        draft: DraftMessage
    ) async -> MessageImp {
            let attachments = await draft.medias.asyncCompactMap { media -> Attachment? in
                guard let thumbnailURL = await media.getThumbnailURL() else {
                    return nil
                }

                switch media.type {
                case .image:
                    return Attachment(id: UUID().uuidString, url: thumbnailURL, type: .image)
                case .video:
                    guard let fullURL = await media.getURL() else {
                        return nil
                    }
                    return Attachment(id: UUID().uuidString, thumbnail: thumbnailURL, full: fullURL, type: .video)
                }
            }

            let giphyMediaId = draft.giphyMedia?.id

            return MessageImp(
                id: id,
                user: user,
                status: status,
                createdAt: draft.createdAt,
                text: draft.text,
                attachments: attachments,
                giphyMediaId: giphyMediaId,
                recording: draft.recording,
                replyMessage: draft.replyMessage
            )
        }
}
