//
//  NoteItemModel.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftData

class NoteItemType {
    let TEXT = "text"
    let URL = "url"
    let IMAGE = "image"
    let IMAGE_URL = "image_url"
    let PASSWORD = "password"
}

struct NoteItemModel: Codable {
    var id: String
    var text: String
    var desc: String
    var type: String
    var version: Int
    var create_time: Int
    var update_time: Int
    var tags: [String]
    var data_json: String?
    var group_id: String?
    var url: String
    var img_url: String?
}

struct ItemPasswordModel: Codable {
    var user: String
    var password: String
    var site: String
}

// 下面是用SwiftData重构，后续可能会将[Note]词改成[纪录Log]
// Note记录本身
@Model
class NoteItemDataModel {
    var id: UUID
    var text: String
    var isCompleted: Bool
    var desc: String
    var type: String
    var version: Int
    var create_time: Int
    var update_time: Int
    var tags: [String]
    var data_json: String
    var group_id: String
    var url: String
    var img_url: String
    var image: Data?
    var end_time: Int
    init(id: UUID = UUID(), text: String, isCompleted: Bool = false, desc: String = "", type: String = "text", version: Int = 1, create_time: Int = 0, update_time: Int = 0, tags: [String] = [], data_json: String = "", group_id: String = "", url: String = "", img_url: String = "", image: Data? = nil, end_time: Int = -1) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.desc = desc
        self.type = type.lowercased()
        self.version = version
        self.create_time = create_time
        self.update_time = update_time
        self.tags = tags
        self.data_json = data_json
        self.group_id = group_id
        self.url = url
        self.img_url = img_url
        self.image = image
        self.end_time = end_time
    }
//    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
//        self.id = id
//        self.title = title
//        self.isCompleted = isCompleted
//    }
}

// 标签，方便后续搜索
@Model
class NoteTagDataModel {
    var id: UUID
    var text: String
    var type: String
    init(id: UUID = UUID(), text: String, type: String = "") {
        self.id = id
        self.text = text
        self.type = type
    }
}
