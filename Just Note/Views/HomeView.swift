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
                if $noteList.isEmpty {
                    Text("点右上角记点东西").font(.largeTitle)
//                TODO: 下面代码在实机ios 18 Beta失效
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
                } else {
                    List(noteList, id: \.id) { item in
                        let newTitle = item.title.isEmpty ? "[空白]" : item.title
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
                print(noteList)
            }
        }
    }
}

// #Preview {
//    HomeView()
// }
