//
//  SettingView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI

import SwiftUtils

// private class SettingData {
//    @State var isAutoPaste = false
//    @State var isAutoKeyboard = false
//    @State var clearNoteNextOpen = false
//    init(isAutoPaste: Bool = false, isAutoKeyboard: Bool = false, clearNoteNextOpen: Bool = false) {
//        self.isAutoPaste = isAutoPaste
//        self.isAutoKeyboard = isAutoKeyboard
//        self.clearNoteNextOpen = clearNoteNextOpen
//    }
// }

struct SettingView: View {
    @State private var isAutoPaste = false
    @State private var isAutoKeyboard = false
    @State private var clearNoteNextOpen = false
    @State private var isAutoSave = false
//    @State private var setData = SettingData()
    private let setSerivce = SettingService()
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if let appIcon = AppUtil().getAppIconImage() {
                        AppIconAndNameView(image: appIcon)
                    } else {
                        Text("加载应用图标失败：可能未设置")
                    }
                    Section(header: Text("关于")) {
                        SimpleTextItemView(title: "开发者", detail: "zhihaofans")
                        SimpleTextItemView(title: "版本号", detail: "\(AppUtil().getAppVersion()) (\(AppUtil().getAppBuild()))" /* "0.0.1" */ )
                        NavigationLink(destination: FeatureView()) {
                            SimpleTextItemView(title: "功能更新", detail: "点击看更新到哪了")
                        }
                    }
                    Section(header: Text("驱动引擎")) {
                        SimpleTextItemView(title: "开发工具", detail: "强大的Xcode")
                        SimpleTextItemView(title: "开发语言", detail: "先进的Swift")
                        SimpleTextItemView(title: "数据储存", detail: "落后的UserDefaults")
                    }
                    Section(header: Text("编辑")) {
                        Toggle(isOn: $isAutoPaste) {
                            Text("新增自动粘贴")
                        }
                        Toggle(isOn: $isAutoKeyboard) {
                            Text("新增/编辑时自动弹出键盘")
                        }
                        Toggle(isOn: $isAutoSave) {
                            Text("自动保存")
                        }
                        Toggle(isOn: $clearNoteNextOpen) {
                            Text("下次启动清空数据")
                        }
                    }
                }
            }.onAppear {
                isAutoPaste = setSerivce.getAutoPasteMode()
                isAutoKeyboard = setSerivce.getShowKeyboardMode()
                clearNoteNextOpen = setSerivce.getClearNoteNextOpen()
            }
            .toolbar {
                #if os(macOS)
                Button("Save", systemImage: "square.and.arrow.down", action: {
                    saveSetting()
                })
                #else
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveSetting()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                #endif
            }
            .navigationTitle("更多")
            #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
            #endif
        }
    }

    private func saveSetting() {
        setSerivce.setAutoPasteMode(value: isAutoPaste)
        setSerivce.setShowKeyboardMode(value: isAutoKeyboard)
        setSerivce.setClearNoteNextOpen(value: clearNoteNextOpen)
    }
}

struct AppIconAndNameView: View {
    #if os(macOS)
    let image: NSImage
    #else
    let image: UIImage
    #endif
    var body: some View {
        VStack(alignment: .center) {
            // Text(s)
            #if os(macOS)
            Image(nsImage: image)
                .resizable() // 允许图片可调整大小
                .scaledToFit() // 图片将等比缩放以适应框架
                .frame(width: 120, height: 120) // 设置视图框架的大小
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // 设置圆角矩形形状
                .shadow(radius: 5) // 添加阴影以增强效果
            #else
            Image(uiImage: image)
                .resizable() // 允许图片可调整大小
                .scaledToFit() // 图片将等比缩放以适应框架
                .frame(width: 120, height: 120) // 设置视图框架的大小
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // 设置圆角矩形形状
                .shadow(radius: 5) // 添加阴影以增强效果
            #endif

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
