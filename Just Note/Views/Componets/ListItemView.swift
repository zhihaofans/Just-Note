//
//  ListItemView.swift
//  Just Note
//
//  Created by zzh on 2024/8/25.
//

import SwiftUI

struct SimpleTextItemView: View {
    var title: String
    var detail: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail).foregroundColor(.gray)
        }
    }
}

struct iconAndTextItemView: View {
    var title: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
    }
}

struct iconAndTextDetailItemView: View {
    var title: String
    var detail: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Text(detail).foregroundColor(.gray)
        }
    }
}
