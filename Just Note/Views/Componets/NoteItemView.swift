//
//  NoteItemView.swift
//  Just Note
//
//  Created by zzh on 2024/9/7.
//

import SwiftUI
import SwiftUtils

struct NoteItemView: View {
    private let item: NoteItemModel
    init(item: NoteItemModel) {
        self.item = item
    }

    var body: some View {
        let newTitle = item.text.isEmpty ? "[空白]" : item.text.removeLeftSpaceAndNewLine() // 这里会删除文本最前面的空格和换行，这样才能在列表显示东西
        NavigationLink(destination: EditView(editNoteItem: item)) {
            // DoubleTextItemView(title: String(newTitle), subTitle: DateUtil().timestampToTimeStr(timestampInt: item.create_time), text: item.tags.isNotEmpty ? item.tags.joined(separator: ",") : TimeService().timestampToShortChinese(timestamp: item.create_time))
            TextTagItemView(text: newTitle, tags: item.tags)
        }
    }
}
