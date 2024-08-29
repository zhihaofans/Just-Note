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
    @State var noteItem: NoteItemModel
    @State var noteType = "纯文本"
    var body: some View {
        VStack {
            List {
                Menu("模式") {
                    Button("Copy", action: {})
                    Button("Copy Formatted", action: {})
                    Button("Copy Library Path", action: {})
                }
            }
            Form {
                // 3. 修改

                Text("请输入标题!").font(.largeTitle)
                TextField("标题:", text: $noteItem.title)
                Text("创建时间:" + DateUtil().timestampToTimeStr(timestampInt: noteItem.create_time)).font(.largeTitle)
                Button(action: {}) {
                    Text("").font(.title)
                }
            }
        }
        .navigationTitle("记点啥")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EmptyView()) {
                    // TODO: 这里跳转到个人页面或登录界面
                    Image(systemName: "plus")
                }
            }
        }
    }
}

//#Preview {
//    EditView()
//}
