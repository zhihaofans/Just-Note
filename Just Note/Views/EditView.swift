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
    @State private var noteDate: Date
    @State private var isNew = true
    @State private var isShowAlert = false
    @FocusState private var isFocused: Bool
    init(editNoteItem: NoteItemModel?) {
        if editNoteItem != nil {
            isNew = false
        }
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        noteItem = editNoteItem ?? NoteItemModel(id: id, text: "", desc: "", type: "", version: 1, create_time: time, update_time: time, tags: [], data_str: "", group_id: "")
        noteDate = Date(timeIntervalSince1970: time.toDouble)
    }

    var body: some View {
        VStack {
            Form {
                // TODO: 修改
//                TextField("标题:", text: $noteItem.text)
                DatePicker(selection: $noteDate,
                           displayedComponents: [.date, .hourAndMinute], label: { Text("日期") })

                TextEditor(text: $noteItem.text)
                    .padding()
                    .frame(height: 200) // 设置高度来容纳多行文本
                    // .border(Color.gray, width: 1)
                    .cornerRadius(8)
//                    .focused($isFocused) // 绑定 TextField 的焦点状态
//                Text("创建时间:" + Date(timeIntervalSince1970: noteItem.create_time.toDouble).timestampToTimeStrMinute)
//                Text("最后变动:" + DateUtil().timestampToTimeStr(timestampInt: noteItem.update_time))
                if ClipboardUtil().hasString() {
                    PasteButton(payloadType: String.self) { strings in
                        noteItem.text = strings[0]
                    }
                }
            }
//            Button(action: {
//                saveItem()
//            }) {
//                Text("保存").font(.title)
//            }
        }
        .navigationTitle("记点啥")
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
                noteItem.text = ClipboardUtil().getString()
            }
            // 视图出现时自动聚焦到 TextField
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = SettingService().getShowKeyboardMode()
            }
        }
    }

    func createItem() -> NoteItemModel {
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        return NoteItemModel(id: id, text: "", desc: "", type: "", version: 1, create_time: time, update_time: time, tags: [], data_str: "", group_id: "")
    }

    func saveItem() {
        print("saveItem")
        noteItem.create_time = noteDate.timestamp
        noteItem.update_time = DateUtil().getTimestamp()
        let saveRe = NoteService().updateNote(noteItem: noteItem)
        print(saveRe)
        isNew = false
        if SettingService().getExitAfterSave() {
            presentationMode.wrappedValue.dismiss() // 退出当前视图
        }
    }
}

// #Preview {
//    EditView()
// }
