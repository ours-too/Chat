//
//  Message.swift
//  Chat
//
//  Created by Alisa Mylnikova on 20.04.2022.
//

import SwiftUI

public protocol Message: Identifiable, Hashable, Sendable {
    var id: String { get set }
    var user: User { get set }
    var status: MessageStatus? { get set }
    var createdAt: Date { get set }

    var text: String { get set }
    var attachments: [Attachment] { get set }
    var reactions: [Reaction] { get set }
    var giphyMediaId: String? { get set }
    var recording: Recording? { get set }
    var replyMessage: ReplyMessage? { get set }

    var triggerRedraw: UUID? { get set }

    init(
        id: String,
        user: User,
        status: MessageStatus?,
        createdAt: Date,
        text: String,
        attachments: [Attachment],
        giphyMediaId: String?,
        reactions: [Reaction],
        recording: Recording?,
        replyMessage: ReplyMessage?
    )
}

extension Message {
    var time: String {
        DateFormatter.timeFormatter.string(from: createdAt)
    }

    func toReplyMessage() -> ReplyMessage {
        ReplyMessage(id: id, user: user, createdAt: createdAt, text: text, attachments: attachments, recording: recording)
    }
}
