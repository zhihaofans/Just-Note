//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI
import SwiftUtils

struct EditView: View {
    @State private var noteItem: NoteItemModel
    init(editNoteItem: NoteItemModel?) {
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        self.noteItem = editNoteItem ?? NoteItemModel(id: id, title: "", desc: "", type: "", version: 1, create_time: time, update_time: time)
    }

    var body: some View {
        VStack {
            Form {
                // TODO: 修改
                TextField("标题:", text: $noteItem.title)
                Text("创建时间:" + DateUtil().timestampToTimeStr(timestampInt: noteItem.create_time)).font(.largeTitle)
                Button(action: {
                    saveItem()
                }) {
                    Text("保存").font(.title)
                }
            }
        }
        .navigationTitle("记点啥")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EmptyView()) {
                    // TODO: 这里跳转到个人页面或登录界面
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
    }

    func saveItem() {
        let nowTime = DateUtil().getTimestamp()
        noteItem.update_time = nowTime
//       TODO: NoteService().updateNote(noteItem: noteItem)
    }
}

// #Preview {
//    EditView()
// }
