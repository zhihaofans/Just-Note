//
//  HomeView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//
import SwiftUI
import SwiftUtils

struct HomeView: View {
    @State private var noteList: [NoteItemModel] = []
    // 默认排序方式
    // @State private var sortOrder = SortDescriptor(\NoteItemModel.update_time, order: .reverse)

    var body: some View {
        NavigationStack {
            VStack {
                if noteList.isEmpty {
                    ContentUnavailableView {
                        Label("什么都没记", systemImage: "questionmark.folder.ar")
                    } actions: {
                        Spacer()
                        NavigationLink(destination: EditView(editNoteItem: nil)) {
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
                    }
                } else {
                    List(noteList, id: \.id) { item in
                        var newTitle = item.title.isEmpty ? "[空白]" : item.title
                        NavigationLink(destination: EditView(editNoteItem: item)) {
                            Text(newTitle)

                            Spacer()

                            // Text(DateUtil().timestampToTimeStr(timestampInt: item.create_time))
                        }
                    }
//                    .onDelete(perform: deletedTodoItem)
                }
            }
            .navigationTitle(AppUtil().getAppName())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        noteList = NoteService().getNoteList()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EditView(editNoteItem: nil)) {
                        Image(systemName: "plus")
                    }
                }
            }.onAppear {
                noteList = NoteService().getNoteList()
            }
        }
    }

    // 2. 删除
    func deletedTodoItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let noteItem = noteList[index]
            // context.delete(noteItem)
        }
    }
}

struct EmptyView: View {
    @State var image: UIImage?
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable() // 允许图片可调整大小
                    .scaledToFit() // 图片将等比缩放以适应框架
                    .frame(width: 120, height: 120) // 设置视图框架的大小
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // 设置圆角矩形形状
                    .shadow(radius: 5) // 添加阴影以增强效果
            } else {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            Text(AppUtil().getAppName())
        }
        .onAppear {
            if let appIcon = AppUtil().getAppIconImage() {
                image = appIcon
            }
        }
        .padding()
    }
}

// #Preview {
//    HomeView()
// }
