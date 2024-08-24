//
//  ContentView.swift
//  Just Note
//
//  Created by zzh on 2024/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        MainView()
        #else
        Text("Hello Swift")
        #endif
    }
}

#Preview {
    ContentView()
}
