//
//  MultiplatformView.swift
//  Just Note
//
//  Created by zzh on 2024/9/5.
//

import SwiftUI

struct MPToolbarItem: View {
    let action: () -> Void
    var body: some View {
        #if os(macOS)
        Button("Save", systemImage: "square.and.arrow.down", action: action)
        #else
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: action) {
                Image(systemName: "square.and.arrow.down")
            }
        }
        #endif
    }
}
