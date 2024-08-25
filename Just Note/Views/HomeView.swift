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
    @Environment(\.modelContext) private var context // 上下文
    @Query private var items: [NoteItemData] // 查询
    // 默认排序方式
    @State private var sortOrder = SortDescriptor(\NoteItemData.update_time, order: .reverse)

    var body: some View {
        VStack {
            NoteListView(sort: sortOrder)
        }
        .navigationTitle(AppUtil().getAppName())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddView()) {
                    // TODO: 这里跳转到个人页面或登录界面
                    Image(systemName: "plus")
                }
            }
        }.modelContainer(for: NoteItemData.self) // 这里和Environment变量的使用方式也非常类似
    }
}

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    // 4. 查询并排序
    @Query private var reminderItems: [NoteItemData]

    init(sort: SortDescriptor<NoteItemData>) {
        _reminderItems = Query(sort: [sort])
    }

    var body: some View {
        if reminderItems.isEmpty {
            ContentUnavailableView.search
        } else {
            List {
                ForEach(reminderItems) { reminderItem in
                    NavigationLink(value: reminderItem) {
                        HStack {
                            Text(reminderItem.title)

                            Spacer()

                            Text(DateUtil().timestampToTimeStr(timestampInt: reminderItem.timestamp))
                        }
                    }
                }
                .onDelete(perform: deletedTodoItem)
            }
        }
    }

    // 2. 删除
    func deletedTodoItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let reminderItem = reminderItems[index]
            modelContext.delete(reminderItem)
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

#Preview {
    HomeView()
}
