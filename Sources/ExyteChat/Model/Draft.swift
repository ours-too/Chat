//
//  Created by Alex.M on 17.06.2022.
//

import Foundation
import GiphyUISDK

// TODO: Временный мок, чтобы иметь возможность забилдить проект. Посмотреть в исходниках логику методов
public struct Media {
    let type: MediaType

    func getThumbnailURL() -> URL? {
        return nil
    }

    func getURL() -> URL? {
        return nil
    }
}

public struct DraftMessage: Sendable {
    public var id: String?
    public let text: String
    public let medias: [Media]
    public let giphyMedia: GPHMedia?
    public let recording: Recording?
    public let replyMessage: ReplyMessage?
    public let createdAt: Date
    
    public init(id: String? = nil,
                text: String,
                medias: [Media],
                giphyMedia: GPHMedia?,
                recording: Recording?,
                replyMessage: ReplyMessage?,
                createdAt: Date) {
        self.id = id
        self.text = text
        self.medias = medias
        self.giphyMedia = giphyMedia
        self.recording = recording
        self.replyMessage = replyMessage
        self.createdAt = createdAt
    }
}

