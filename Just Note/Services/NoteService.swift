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
        let itemJsonList = UDUtil.getArrayString( UDids.note_item_list)
        let itemList = itemJsonList.compactMap {
            try? JSONDecoder().decode(NoteItemModel.self, from: $0.data(using: .utf8)!)
        }
        return itemList
    }

    func setNoteList(noteList: [NoteItemModel]) {
        print("setNoteList")
        print(noteList)
        let jsonList = noteList.compactMap {
            try? String(data: JSONEncoder().encode($0), encoding: .utf8)
        }
        UDUtil.setArrayString(key: UDids.note_item_list, value: jsonList)
//        if jsonList.isNotEmpty {
//            UDUtil.setArrayString(key: UDids.note_item_list, value: jsonList)
//        }
    }

    func addNote(noteItem: NoteItemModel) {
        print("addNote")
        print(noteItem)
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
        UDUtil.remove(UDids.note_item_list)
    }

    func updateNote(noteItem: NoteItemModel) -> Bool {
        print("updateNote")
        print(noteItem)
        var oldList = getNoteList()
        var newItem = noteItem
        if newItem.type.isEmpty {
            newItem.type = "text"
        }
        if let index = oldList.firstIndex(where: { $0.id == noteItem.id }) {
            if index < 0 || index >= oldList.count {
                return false
            }
            oldList[index] = newItem
            setNoteList(noteList: oldList)
            return true
        } else {
            addNote(noteItem: noteItem)
            return true
        }
    }

    func hasNote(noteItemId: String) -> Bool {
        return getNoteList().contains { $0.id == noteItemId }
    }
}
