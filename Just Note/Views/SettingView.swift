//
//  SettingView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI

import SwiftUtils

struct SettingView: View {
    var body: some View {
        VStack {
            List {
                if let appIcon = AppUtil().getAppIconImage() {
                    AppIconAndNameView(image: appIcon)
                    // 你可以在你的UI中展示这个appIcon, 比如在UIImageView中
                } else {
                    Text("加载应用图标失败：可能未设置")
                }
                Section(header: Text("关于")) {
                    SimpleTextItemView(title: "开发者", detail: "zhihaofans")
                    SimpleTextItemView(title: "版本号", detail: "\(AppUtil().getAppVersion()) (\(AppUtil().getAppBuild()))" /* "0.0.1" */ )
                }
            }
        }
    }
}

struct AppIconAndNameView: View {
    let image: UIImage
    var body: some View {
        VStack(alignment: .center) {
            // Text(s)
            Image(uiImage: image)
                .resizable() // 允许图片可调整大小
                .scaledToFit() // 图片将等比缩放以适应框架
                .frame(width: 120, height: 120) // 设置视图框架的大小
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // 设置圆角矩形形状
                .shadow(radius: 5) // 添加阴影以增强效果
            // .overlay(Circle().stroke(Color.gray, lineWidth: 4)) // 可选的白色边框
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
            Text(AppUtil().getAppName())
                .font(.largeTitle)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center) // 设置对齐方式
    }
}

#Preview {
    SettingView()
}
