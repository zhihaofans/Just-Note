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

struct DoubleTextItemView: View {
    var title: String
    var subTitle: String
    var text: String

    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(text)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
            }
            Spacer()
            // Text(text).foregroundColor(.gray)
        }
    }
}

struct TextTagItemView: View {
    var text: String
    var tags: [String]

    var body: some View {
        HStack {
            VStack {
                Text(text)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(tags.compactMap { "#" + $0 }.joined(separator: " , "))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            // Text(text).foregroundColor(.gray)
        }
    }
}
struct TextTagImageItemView: View {
    var text: String
    var tags: [String]
    var image_data: Data

    var body: some View {
        HStack {
            VStack {
                Text(text)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(tags.compactMap { "#" + $0 }.joined(separator: " , "))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                }
                Image(data: image_data)
                    .resizable() // 允许图片可调整大小
                    .scaledToFit() // 图片将等比缩放以适应框架
                    .frame(width: 120, height: 120) // 设置视图框架的大小
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // 设置圆角矩形形状
                    .shadow(radius: 5) // 添加阴影以增强效果
            }
            Spacer()
            // Text(text).foregroundColor(.gray)
        }
    }
}

// 下面是设置界面用
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
