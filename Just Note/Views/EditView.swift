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
    @State private var isShowRemoveAlert = false
    @State private var isShowAddTagAlert = false
    @State private var newTag = ""
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
                Section(header: Text("标签")) {
                    Button(action: {
                        newTag = ""
                        isShowAddTagAlert = true
                    }) {
                        Text("添加标签")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    List(noteItem.tags, id: \.self) { tagI in
                        Text("#" + tagI)
                    }
                }
                .alert("新增标签", isPresented: $isShowAddTagAlert) {
                    TextField("tag", text: $newTag)
                    Button("YES", action: {
                        debugPrint("newTag:" + newTag)
                        if !noteItem.tags.has(newTag) {
                            addTag(tag: newTag)
                        }
                    })

                    Button("NO", action: {
                        isShowAddTagAlert = false
                    })
                }
//            message: {
//                    Text("删了就找不回了！")
//                }
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
                        isShowRemoveAlert = true
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
        .alert("确定删除⚠️", isPresented: $isShowRemoveAlert) {
            Button("YES", action: {
                NoteService().removeNote(id: noteItem.id)
                presentationMode.wrappedValue.dismiss() // 退出当前视图
            })

            Button("NO", action: {
                isShowRemoveAlert = false
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

    func addTag(tag: String) {
        noteItem.tags.append(tag)

        debugPrint(noteItem)
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
