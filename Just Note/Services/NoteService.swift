//
//  NoteService.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftUtils

class NoteService {
    init() {}

    func addItem() -> NoteItemModel {
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        let noteItem = NoteItemModel(id: id, title: "", desc: "", type: "text", version: 1, create_time: time, update_time: time)
        context.insert(noteItem)
        items = [noteItem]
        return noteItem
    }
}
