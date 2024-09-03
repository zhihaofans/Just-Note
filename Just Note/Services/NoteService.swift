//
//  NoteService.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import Foundation
import SwiftUtils

private class NoteNDIdList {
    let note_item_list = "note_item_list"
}

class NoteService {
    private let UDUtil = UserDefaultUtil()
    private let UDids = NoteNDIdList()
    init() {}
    func getNoteList() -> [NoteItemModel] {
        let itemJsonList = UDUtil.getArrayString(key: UDids.note_item_list)
        let itemList = itemJsonList.compactMap {
            try? JSONDecoder().decode(NoteItemModel.self, from: $0.data(using: .utf8)!)
        }
        return itemList
    }

    func setNoteList(noteList: [NoteItemModel]) {
        let jsonList = noteList.compactMap {
            try? String(data: JSONEncoder().encode($0), encoding: .utf8)
        }
        if jsonList.isNotEmpty {
            UDUtil.setArrayString(key: UDids.note_item_list, value: jsonList)
        }
    }

    func addNote(noteItem: NoteItemModel) {
        var oldList = getNoteList()
        oldList.append(noteItem)
        setNoteList(noteList: oldList)
    }

    func removeNote(id: String) {
        var oldList = getNoteList()
        oldList.removeAll(where: { $0.id == id })
        setNoteList(noteList: oldList)
    }
    func removeAllNote() {
        UDUtil.remove(key: UDids.note_item_list)
    }
    func updateNote(noteItem: NoteItemModel) - Bool {
        var oldList = getNoteList()
        //oldList.append(noteItem)
        if let index = oldList.firstIndex(where: { $0.id == noteItem.id }) {
            // 更新title
            oldList[index] = noteItem
            setNoteList(noteList: oldList)
            return true
        } else {
            print("未找到指定id的元素")
            return false
        }
        
    }
    func hasNote(noteItemId: String) -> Bool {
        var oldList = getNoteList()
        return oldList.contains { $0.id == noteItem.id }
    }
}
