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
    @Query(sort: \NoteItemDataModel.create_time) private var notes: [NoteItemDataModel]
    @State private var noteList: [NoteItemModel] = []
    // 默认排序方式
    // @State private var sortOrder = SortDescriptor(\NoteItemModel.update_time, order: .reverse)

    var body: some View {
        NavigationStack {
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

                List(notes) { task in
                    HStack {
                        Text(task.text)
                        Spacer()
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                                .onTapGesture {
//                                    toggleTaskCompletion(task)
//                                }
                    }
                }
//                    .onDelete(perform: deletedTodoItem)
//                }
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
                    NavigationLink(destination: EditView(editNoteItem: nil)) {
                        Image(systemName: "plus")
                    }
                }
                #endif
            }.onAppear {
                if SettingService().getClearNoteNextOpen() {
                    NoteService().removeAllNote()
                    SettingService().setClearNoteNextOpen(value: false)
                }
                //noteList = NoteService().getNoteList()
                print(notes)
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
}

// #Preview {
//    HomeView()
// }
