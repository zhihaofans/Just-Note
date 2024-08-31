//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI
import SwiftUtils

struct EditView: View {
    @State var noteItem: NoteItemModel?
    @State var noteTitle = ""
    @State var noteTime = 0
    var body: some View {
        VStack {
            List {
                Menu("模式") {
                    Button("Copy", action: {})
                    Button("Copy Formatted", action: {})
                    Button("Copy Library Path", action: {})
                }
            }
            Form {
                // 3. 修改

                Text("请输入标题!").font(.largeTitle)
                TextField("标题:", text: $noteTitle)
                Text("创建时间:" + DateUtil().timestampToTimeStr(timestampInt: noteTime)).font(.largeTitle)
                Button(action: {}) {
                    Text("").font(.title)
                }
            }
        }
        .navigationTitle("记点啥")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EmptyView()) {
                    // TODO: 这里跳转到个人页面或登录界面
                    Image(systemName: "plus")
                }
            }
        }.onAppear {
            if noteItem == nil {
                noteItem = addItem()
            }
            noteTitle = noteItem?.title ?? ""
            noteTime = noteItem?.create_time ?? 0
        }
    }

    func addItem() -> NoteItemModel {
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        let noteItem = NoteItemModel(id: id, title: "", desc: "", type: "text", version: 1, create_time: time, update_time: time)
        return noteItem
    }
}

// #Preview {
//    EditView()
// }
