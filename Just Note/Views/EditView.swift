//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI
import SwiftUtils

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var noteItem: NoteItemModel
    @State private var viewTitle = "记点啥"
    @State private var isNew = true
    @State private var isShowAlert = false
    init(editNoteItem: NoteItemModel?) {
        if editNoteItem != nil {
            isNew = false
        }
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        noteItem = editNoteItem ?? NoteItemModel(id: id, title: "", desc: "", type: "", version: 1, create_time: time, update_time: time)
    }

    var body: some View {
        VStack {
            Form {
                // TODO: 修改
                TextField("标题:", text: $noteItem.title)
                Text("创建时间:" + DateUtil().timestampToTimeStr(timestampInt: noteItem.create_time))
                Text("最后变动:" + DateUtil().timestampToTimeStr(timestampInt: noteItem.update_time))
            }
//            Button(action: {
//                saveItem()
//            }) {
//                Text("保存").font(.title)
//            }
        }
        .navigationTitle($viewTitle)
        .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
        .toolbar {
            if !isNew {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowAlert = true
                    }) {
                        Image(systemName: "trash.fill")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    saveItem()
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
        .alert("确定删除⚠️", isPresented: $isShowAlert) {
            Button("YES", action: {
                NoteService().removeNote(id: noteItem.id)
                presentationMode.wrappedValue.dismiss() // 退出当前视图
            })
            Button("NO", action: {
                isShowAlert = false
            })
        } message: {
            Text("删了就找不回了！")
        }.onAppear {
            if isNew && SettingService().getAutoPasteMode() {
                noteItem.title = ClipboardUtil().getString()
            }
        }
    }

    func saveItem() {
        print("saveItem")
        noteItem.update_time = DateUtil().getTimestamp()
        let saveRe = NoteService().updateNote(noteItem: noteItem)
        print(saveRe)
    }
}

// #Preview {
//    EditView()
// }
