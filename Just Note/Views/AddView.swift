//
//  AddView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI

struct AddView: View {
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

#Preview {
    AddView()
}
