//
//  NoteItemModel.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftData

struct NoteItemModel: Codable {
    var id: String
    var text: String
    var desc: String
    var type: String
    var version: Int
    var create_time: Int
    var update_time: Int
    var tags: [String]
    var data_str: String
    var group_id: String
}
