//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import PhotosUI
import SwiftData
import SwiftUI
import SwiftUtils

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State private var noteList = [NoteItemDataModel]()
    @State private var noteItem: NoteItemDataModel
    @State private var noteDate: Date
    @State private var isNew = true
    @State private var isShowRemoveAlert = false
    @State private var isShowAddTagAlert = false
    @State private var newTag: String = ""
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var imageData: Data?
//    @State private var newTitle: String = ""
//    @State private var newType: String = "text"
//    @State private var newUrl: String = "text"
    private let noteType = NoteItemType()
    @FocusState private var isFocused: Bool
    @State private var pickerResult: [PHPickerResult] = []
    @State private var isPickerPresented = false
    init(path: [NoteItemDataModel], editNoteItem: NoteItemDataModel? = nil) {
        noteList = path
        if editNoteItem != nil {
            isNew = false
        }
        let time = DateUtil().getTimestamp()
        noteItem = editNoteItem ?? NoteItemDataModel(text: "", type: "text", create_time: time, update_time: time)
        noteDate = Date(timeIntervalSince1970: time.toDouble)
    }

    var body: some View {
        VStack {
            Form {
                // TODO: 这里加个Type选择器
                Menu {
                    Button(action: {
                        noteItem.type = noteType.TEXT
                        noteItem.url = ""
                    }) {
                        Label("文本(text)", systemImage: "character")
                    }
                    Button(action: {
                        noteItem.type = noteType.URL
                    }) {
                        Label("链接(url)", systemImage: "link")
                    }
                    Button(action: {
                        noteItem.type = noteType.IMAGE
                    }) {
                        Label("图片", systemImage: "photo.artframe")
                    }.disabled(true)
                    Button(action: {
                        noteItem.type = noteType.URL
                    }) {
                        Label("网络图片", systemImage: "network")
                    }.disabled(true)
                    Button(action: {
                        noteItem.type = noteType.URL
                    }) {
                        Label("TODO", systemImage: "list.bullet.clipboard")
                    }.disabled(true)
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
                    TextField("链接", text: $noteItem.url, onEditingChanged: { isEditing in
                        if !isEditing {
                            // 当编辑结束时执行
                            print("编辑结束: \(noteItem.url)")
                            self.checkUrl()
                        }
                    }, onCommit: {
                        // 提交动作，如按下键盘的完成按钮
                        print("提交输入: \(noteItem.url)")
                        self.checkUrl()
                    })
                    .autocapitalization(.none) // 禁止自动大写
                    .keyboardType(.URL) // 使用 URL 键盘类型
                }
                if noteItem.type == NoteItemType().IMAGE {
                    Section(header: Text("图片")) {
                        Button("选择照片") {
                            pickerResult = []
                            isPickerPresented = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .sheet(isPresented: $isPickerPresented) {
                            PhotoPicker(pickerResult: $pickerResult, isPresented: $isPickerPresented)
                        }
//                        if noteItem.image != nil, let imageData = noteItem.image, let image = UIImage(data: imageData) {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 200, height: 200)
//                                .padding()
//                        }
                        // 显示选择的图片（如果有的话）
                        if let firstItem = pickerResult.first {
                            PhotoThumbnail(photoItem: firstItem, uiImage: $image)
                        }
                    }
                }
//                if ClipboardUtil().hasString() {
//                    PasteButton(payloadType: String.self) { strings in
//                        noteItem.text = strings[0]
//                    }
//                }
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
                            .foregroundColor(.red) // 将颜色改为红色
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    addNewTask()
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
        .alert("确定删除⚠️", isPresented: $isShowRemoveAlert) {
            Button("YES", action: {
                // NoteService().removeNote(id: noteItem.id)
                // TODO: 用SwiftData重构
                modelContext.delete(noteItem)
                do {
                    try modelContext.save()
                    isNew = false
                } catch {
                    print("Failed to delete context: \(error)")
                }
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
        // guard !noteItem.text.isEmpty else { return }

        // 2. 创建一个新的 Task 对象，使用当前输入的任务标题
//        let newTask = NoteItemDataModel(text: noteItem.text)
        noteItem.image = image?.heicData()
        print(noteItem)
        // 3. 使用 modelContext 将新任务插入到数据模型中
        modelContext.insert(noteItem)
        noteList = [noteItem]
//        isNew = false
        // 4. 保存当前上下文的更改，将新任务持久化到存储中
//        try? modelContext.save()
        do {
            try modelContext.save()
            isNew = false
        } catch {
            print("Failed to save context: \(error)")
        }
        print(modelContext)
        // 5. 清空输入框，准备输入下一个任务 。这里忽略
//        newTitle = ""
    }

    private func checkUrl() {
        if noteItem.text.isEmpty && noteItem.url.isNotEmpty {
            if noteItem.url.isUrl {
            } else {
                noteItem.text = "[错误链接]"
            }
        }
    }
//    func saveItem() {
//        print("saveItem")
//        noteItem.create_time = noteDate.timestamp
//        noteItem.update_time = DateUtil().getTimestamp()
//        let saveRe = NoteService().updateNote(noteItem: noteItem)
//        print(saveRe)
//        isNew = false
//        if SettingService().getExitAfterSave() {
//            presentationMode.wrappedValue.dismiss() // 退出当前视图
//        }
//    }
}

struct PhotoThumbnail: View {
    let photoItem: PHPickerResult
    @Binding var uiImage: UIImage?

    var body: some View {
        Image(uiImage: uiImage ?? UIImage())
            .resizable()
            .scaledToFit()
            .onAppear {
                loadImage()
            }
    }

    private func loadImage() {
        guard uiImage == nil else { return }

        photoItem.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
            if let uiImage = image as? UIImage {
                DispatchQueue.main.async {
                    self.uiImage = uiImage
                }
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var pickerResult: [PHPickerResult]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // 可以根据需要调整
        config.filter = .images // 只选取图片

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.pickerResult = results
            parent.isPresented = false
        }
    }
}

// #Preview {
//    EditView()
// }
