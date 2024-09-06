//
//  FeatureView.swift
//  Just Note
//
//  Created by zzh on 2024/9/7.
//

import SwiftUI

struct FeatureView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("功能更新")) {
                        SimpleTextItemView(title: "纯文本记录", detail: "✅")
                        SimpleTextItemView(title: "链接记录", detail: "❌")
                        SimpleTextItemView(title: "数据重构，改用SwiftData", detail: "❌")
                        SimpleTextItemView(title: "图文记录", detail: "❌")
                        SimpleTextItemView(title: "适配macOS", detail: "❌")
                        SimpleTextItemView(title: "适配iPad", detail: "❌")
                    }
                }
            }
        }
        .navigationTitle("不是bug是feature")
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
        #endif
    }
}

#Preview {
    FeatureView()
}
