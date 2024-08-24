//
//  MainView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    var body: some View {
        switch selectedTab {
        case 2:
            SettingView()
        default:
            HomeView()
        }
        TabView(selection: $selectedTab) {
            Text("")
                .tabItem {
                    Label("主页", systemImage: "house")
                }
                .tag(0)

            Text("")
                .fixedSize(horizontal: false, vertical: true) // 纵向固定大小
                .tabItem {
                    Label("时间线", systemImage: "chart.xyaxis.line")
                }
                .tag(1)

            Text("")
                .fixedSize(horizontal: false, vertical: true) // 纵向固定大小
                .tabItem {
                    Label("更多", systemImage: "ellipsis")
                }
                .tag(2)
        }
        .frame(maxHeight: 50) // 限制最大高度
    }
}

#Preview {
    MainView()
}
