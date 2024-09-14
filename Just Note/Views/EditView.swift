//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftData
import SwiftUI
import SwiftUtils

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State private var noteItem: NoteItemModel
    @State private var noteDate: Date
    @State private var isNew = true
    @State private var isShowRemoveAlert = false
    @State private var isShowAddTagAlert = false
    @State private var newTag = ""
    @State private var newTitle: String = ""
    private let noteType = NoteItemType()
    @FocusState private var isFocused: Bool
    init(editNoteItem: NoteItemModel?) {
        if editNoteItem != nil {
            isNew = false
        }
        let time = DateUtil().getTimestamp()
        let id = UUID().uuidString
        noteItem = editNoteItem ?? NoteItemModel(id: id, text: "", desc: "", type: noteType.TEXT, version: 1, create_time: time, update_time: time, tags: [], url: "")
        noteDate = Date(timeIntervalSince1970: time.toDouble)
    }

    var body: some View {
        VStack {
            Form {
                // TODO: 这里加个Type选择器
                Menu {
                    Button(action: {
                        noteItem.type = noteType.TEXT
                    }) {
                        Label("文本(text)", systemImage: "character")
                    }
                    Button(action: {
                        noteItem.type = noteType.URL
                    }) {
                        Label("链接(url)", systemImage: "link")
                    }
                } label: {
                    SimpleTextItemView(title: "类型", detail: noteItem.type)
                }
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

                if noteItem.type == NoteItemType().URL {
//                    TextEditor(text: $noteItem.url)
                    TextField("链接", text: $noteItem.url)
                        .autocapitalization(.none) // 禁止自动大写
                        .keyboardType(.URL) // 使用 URL 键盘类型
                }
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
                    ForEach(noteItem.tags, id: \.self) { tag in
                        Text("#" + tag)
                    }
                    .onDelete(perform: deleteTag)
//                    List(noteItem.tags, id: \.self) { tagI in
//                        Text("#" + tagI)
//                    }
//                    .onDelete(perform: deleteTag)
                }
                .alert("新增标签", isPresented: $isShowAddTagAlert) {
                    TextField("tag", text: $newTag)
                    Button("YES", action: {
                        debugPrint("newTag:" + newTag)
                        if newTag.isNotEmpty, !noteItem.tags.has(newTag) {
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

    func deleteTag(at offsets: IndexSet) {
        noteItem.tags.remove(atOffsets: offsets)
    }

    func addTag(tag: String) {
        noteItem.tags.append(tag)

        debugPrint(noteItem)
    }

    private func addNewTask() {
        // 1. 确保新任务的标题不是空的
        guard !newTitle.isEmpty else { return }

        // 2. 创建一个新的 Task 对象，使用当前输入的任务标题
        let newTask = NoteTagDataModel(text: newTitle)

        // 3. 使用 modelContext 将新任务插入到数据模型中
        modelContext.insert(newTask)

        // 4. 保存当前上下文的更改，将新任务持久化到存储中
        try? modelContext.save()

        // 5. 清空输入框，准备输入下一个任务 。这里忽略
//        newTitle = ""
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
