//
//  HomeView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI
import SwiftUtils

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section("界面UI") {
                    NavigationLink("列表List", destination: EmptyView())
                    NavigationLink("弹窗Alert", destination: EmptyView())
                    NavigationLink("图片Image", destination: EmptyView())
                    Text("学习中")
                }
                Section("功能API") {
                    NavigationLink("剪贴板", destination: EmptyView())
                    Text("学习中")
                }
            }
            .navigationTitle(AppUtil().getAppName())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddView()) {
                        // TODO: 这里跳转到个人页面或登录界面
                        Image(systemName: "plus")
                    }
                }
            }
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
