//
//  HomeView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//
import SwiftData
import SwiftUI
import SwiftUtils

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NoteItemDataModel.create_time, order: .reverse) private var notes: [NoteItemDataModel]
    @State private var noteList = [NoteItemDataModel]()
    // 默认排序方式
    // @State private var sortOrder = SortDescriptor(\NoteItemModel.update_time, order: .reverse)
    private let noteType = NoteItemType()
    var body: some View {
        NavigationStack(path: $noteList) {
            VStack {
                //                if false {
                ////                    Text("点右上角记点东西").font(.largeTitle)
                //
                //                    NavigationLink(destination: EditView(editNoteItem: nil)) {
                //                        //                        Button("随便记一下") {
                //                        //                            // TODO: add note
                //                        //                        }
                //                        //                        .buttonStyle(.borderedProminent)
                //                        Text("随便记一下")
                //                            .padding()
                //                            .background(Color.blue)
                //                            .foregroundColor(.white)
                //                            .cornerRadius(8)
                //                    }
                //                TODO: 下面代码在实机ios 18 Beta失效（应该是ContentUnavailableView）
                //                    ContentUnavailableView {
                //                        Label("什么都没记", systemImage: "questionmark.folder.ar")
                //                    } actions: {
                //                        Spacer()
                //                        NavigationLink(destination: EditView(editNoteItem: nil)) {
                //                            //                        Button("随便记一下") {
                //                            //                            // TODO: add note
                //                            //                        }
                //                            //                        .buttonStyle(.borderedProminent)
                //                            Text("随便记一下")
                //                                .padding()
                //                                .background(Color.blue)
                //                                .foregroundColor(.white)
                //                                .cornerRadius(8)
                //                        }
                //                    }
                //                } else {
                // 下面是老代码
                //                    List(noteList, id: \.id) { item in
                //                        NoteItemView(item: item)
                //                            .swipeActions {
                //                                Button {
                //                                    // TODO: 打开链接
                //                                    // deleteItem(item: item)
                //                                    openLink(link: item.url)
                //                                } label: {
                //                                    Text("打开链接") // 自定义删除文本
                //                                }
                //                                .tint(.green) // 自定义删除按钮颜色
                //                                //
                //                                //                        Button {
                //                                //                            print("Pinned \(item)")
                //                                //                        } label: {
                //                                //                            Text("Pin") // 自定义"Pin"操作
                //                                //                        }
                //                                //                        .tint(.blue) // 自定义操作颜色
                //                            }
                //                    }

                // 下面是新代码SwiftData
                // 显示所有任务
                if notes.isEmpty {
                    NavigationLink(destination: EditView(path: noteList)) {
                        //                        Button("随便记一下") {
                        //                            // TODO: add note
                        //                        }
                        //                        .buttonStyle(.borderedProminent)
                        Text("随便记一下")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    List(notes) { item in
                        NoteItemView(path: noteList, item: item)
                            .swipeActions {
                                if item.type.lowercased() == noteType.URL && item.url.isNotEmpty {
                                    Button {
                                        // TODO: 打开链接
                                        // deleteItem(item: item)
                                        openLink(link: item.url)
                                    } label: {
                                        Text("打开链接") // 自定义删除文本
                                    }
                                    .tint(.green) // 自定义删除按钮颜色
                                } else if item.type.lowercased() == noteType.TEXT && item.text.isNotEmpty {
                                    ShareLink(item: item.text) {
//                                        Label("Share Text", systemImage: "square.and.arrow.up")
                                        Button {
                                            // TODO: 打开链接
                                            // deleteItem(item: item)
//                                                openLink(link: item.url)
                                        } label: {
                                            Text("分享文本") // 自定义删除文本
                                        }
                                    }
                                }
//                                else if item.type.lowercased() == noteType.IMAGE && item.image != nil, let uimage = UIImage(data: item.image!) {
//                                    ShareLink(item: uimage) {
                                ////                                        Label("Share Text", systemImage: "square.and.arrow.up")
//                                        Button {
//                                            // TODO: 打开链接
//                                            // deleteItem(item: item)
                                ////                                                openLink(link: item.url)
//                                        } label: {
//                                            Text("分享图片") // 自定义删除文本
//                                        }
//                                    }
//                                }
                                //
                                //                        Button {
                                //                            print("Pinned \(item)")
                                //                        } label: {
                                //                            Text("Pin") // 自定义"Pin"操作
                                //                        }
                                //                        .tint(.blue) // 自定义操作颜色
                            }
                    }
                }
            }
            .navigationTitle(AppUtil().getAppName())
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: EditView(editNoteItem: nil)) {
//                        Image(systemName: "doc.on.clipboard")
//                    }
//                }

                #if os(macOS)
                NavigationLink(destination: EditView(editNoteItem: nil)) {
                    Button("Save", systemImage: "square.and.arrow.down", action: {})
                }
                #else
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EditView(path: noteList, editNoteItem: nil)) {
                        Image(systemName: "plus")
                    }
                }
                #endif
            }.onAppear {
                if SettingService().getClearNoteNextOpen() {
                    NoteService().removeAllNote()
                    SettingService().setClearNoteNextOpen(value: false)
                }
                // noteList = NoteService().getNoteList()
                print(notes)
                manualFetchTasks()
            }
        }
    }

    private func openLink(link: String) {
        if link.isNotEmpty {
            Task {
                // 在这里执行耗时的任务
                let openSu = await AppUtil().openUrl(urlString: link)
                // 完成后，在主线程更新 UI
                DispatchQueue.main.async {
                    // 更新 UI
                    print("打开app：" + openSu.string(trueStr: "Su", falseStr: "fail"))
                }
            }
        }
    }

    private func testAddNote() {
        // 1. 确保新任务的标题不是空的
//        guard !noteItem.text.isEmpty else { return }

        // 2. 创建一个新的 Task 对象，使用当前输入的任务标题
//        let newTask = NoteItemDataModel(text: noteItem.text)
        let noteItem = NoteItemDataModel(text: "haha")
        print(noteItem)
        // 3. 使用 modelContext 将新任务插入到数据模型中
        modelContext.insert(noteItem)

        // 4. 保存当前上下文的更改，将新任务持久化到存储中
//        try? modelContext.save()
        do {
            try modelContext.save()
//            isNew = false
        } catch {
            print("Failed to save context: \(error)")
        }
        print(modelContext)
        // 5. 清空输入框，准备输入下一个任务 。这里忽略
//        newTitle = ""
    }

    // 手动查询所有任务
    private func manualFetchTasks() {
        // 使用 modelContext.fetch() 手动查询 Task 实体
        let fetchRequest = FetchDescriptor<NoteItemDataModel>(sortBy: [SortDescriptor(\.create_time)])

        do {
            let tasks = try modelContext.fetch(fetchRequest)
            print("Fetched Tasks: " + tasks.length.toString)
            for task in tasks {
                print("Title: \(task.text), Completed: \(task.isCompleted)")
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
}

// #Preview {
//    HomeView()
// }
