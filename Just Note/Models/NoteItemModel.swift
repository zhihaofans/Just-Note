//
//  NoteItemModel.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftData

@Model
final class NoteItemData {
    let id: String
    let title: String
    let desc: String
    let type: String
    let version: Int
    let create_time: Int
    let update_time: Int
    init(id: String, title: String, desc: String, type: String, version: Int, create_time: Int, update_time: Int) {
        self.id = id
        self.title = title
        self.desc = desc
        self.type = type
        self.version = version
        self.create_time = create_time
        self.update_time = update_time
    }
}
