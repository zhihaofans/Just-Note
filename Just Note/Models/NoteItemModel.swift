//
//  NoteItemModel.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftData

class NoteItemType {
    let TEXT="text"
    let URL="url"
    let IMAGE="image"
    let IMAGE_URL="image_url"
    let PASSWORD="password"
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
