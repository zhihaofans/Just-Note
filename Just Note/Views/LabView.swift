//
//  LabView.swift
//  Just Note
//
//  Created by zzh on 2024/9/7.
//

import SwiftUI

struct LabView: View {
    var body: some View {
        NavigationView {
            VStack {
//                Image(systemName: "flask")
//                Text("实验室装修中...")
                List {
                    Section(header: Text("测试功能")) {
                        NavigationLink(destination: TagView()) {
                            Text("标签")
                        }
                    }
                }
            }
            .navigationTitle("实验室")
            #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
            #endif
        }
    }
}

#Preview {
    LabView()
}
