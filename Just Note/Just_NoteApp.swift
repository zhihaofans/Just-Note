//
//  Just_NoteApp.swift
//  Just Note
//
//  Created by zzh on 2024/8/24.
//

import SwiftUI

import SwiftData

@main
struct Just_NoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.modelContainer(for: NoteItemDataModel.self) // 注入模型容器
                .modelContainer(for: [NoteItemDataModel.self, NoteTagDataModel.self])
//                .modelContainer(for: NoteTagDataModel.self) // 注入模型容器
        }
    }
}
