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
        let newTitle = item.text.isEmpty ? "[空白]" : item.text
        NavigationLink(destination: EditView(editNoteItem: item)) {
            DoubleTextItemView(title: newTitle, subTitle: DateUtil().timestampToTimeStr(timestampInt: item.create_time), text: item.tags.isNotEmpty ? item.tags.joined(separator: ",") : TimeService().timestampToShortChinese(timestamp: item.create_time))
        }
    }
}
