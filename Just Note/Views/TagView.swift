//
//  TagView.swift
//  Just Note
//
//  Created by zzh on 2024/9/7.
//

import SwiftData
import SwiftUI
import SwiftUtils

struct TagView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NoteTagDataModel.create_time, order: .reverse) private var tags: [NoteTagDataModel]
    @State private var tagList = [NoteTagDataModel]()
    @State private var isShowAddTagAlert = false
    @State private var newTag: String = ""
    @State private var isShowInfoAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    var body: some View {
        NavigationStack(path: $tagList) {
            VStack {
                // 下面是新代码SwiftData
                // 显示所有任务
                if tags.isEmpty {
                    Text("没有标签")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    List(tags) { item in
                        Text("#" + item.text)
                        //                        NoteItemView(path: tagList, item: item)
                        //                            .swipeActions {}
                    }
                }
            }
        }
        .navigationTitle(AppUtil().getAppName())
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
#endif
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    NavigationLink(destination: EditView(editNoteItem: nil)) {
                //                        Image(systemName: "doc.on.clipboard")
                //                    }
                //                }

                // #if os(macOS)
//                NavigationLink(destination: EditView(editNoteItem: nil)) {
//                    Button("Save", systemImage: "square.and.arrow.down", action: {})
//                }
                // #else
//                ToolbarItem(placement: .navigationBarTrailing) {
//                                        NavigationLink(destination: EditView(path: tags, editNoteItem: nil)) {
//                                            Image(systemName: "plus")
//                                        }
//                }
                // #endif

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowAddTagAlert = true
                    }) {
                        Image(systemName: "plus")
                    }.alert("新增标签", isPresented: $isShowAddTagAlert) {
                        TextField("tag", text: $newTag)
                        Button("YES", action: {
                            debugPrint("newTag:" + newTag)
                            let hasTag = tags.contains {
                                $0.text.lowercased() == newTag.lowercased()
                            }
                            if newTag.isNotEmpty {
                                if hasTag {
                                    // TODO: 重复添加提示
                                    alertTitle = "添加标签失败"
                                    alertMessage = "标签\(newTag)已存在，标签不区分大小写"
                                    isShowInfoAlert = true
                                    newTag = ""
                                } else {
                                    self.addTag(tag: newTag)
                                    newTag = ""
                                }
                            }
                        })
                        Button("NO", action: {
                            isShowAddTagAlert = false
                        })
                    }.alert(alertTitle, isPresented: $isShowInfoAlert) {
                        Text(alertMessage)
                        Button("YES", action: {
                            isShowInfoAlert = false
                            alertTitle = ""
                            alertMessage = ""
                        })
                        Button("NO", action: {
                            isShowInfoAlert = false
                        })
                    }
                }
            }.onAppear {
                print(tags)
                // manualFetchTasks()
            }
    }

    private func addTag(tag: String) {
        let time = DateUtil().getTimestamp()
        let tagItem = NoteTagDataModel(text: tag, create_time: time)
        modelContext.insert(tagItem)
        tagList = [tagItem]
//        isNew = false
        // 4. 保存当前上下文的更改，将新任务持久化到存储中
//        try? modelContext.save()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        print(modelContext)
    }

    // 手动查询所有任务
    private func manualFetchTasks() {
        // 使用 modelContext.fetch() 手动查询 Task 实体
        let fetchRequest = FetchDescriptor<NoteTagDataModel>(sortBy: [SortDescriptor(\.create_time)])

        do {
            let tasks = try modelContext.fetch(fetchRequest)
            print("Fetched Tasks: " + tasks.length.toString)
//            for task in tasks {
//                print("Title: \(task.text), Completed: \(task.isCompleted)")
//            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
}

// #Preview {
//    TagView()
// }
