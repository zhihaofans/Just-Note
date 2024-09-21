//
//  LabView.swift
//  Just Note
//
//  Created by zzh on 2024/9/7.
//

import NaturalLanguage
import SwiftUI
import SwiftUtils
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
                        NavigationLink(destination: FenciView()) {
                            Text("文本分词")
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

struct FenciView: View {
    @State private var inputText: String
    @State private var textList: [String]
    @State private var fenciUnit: NLTokenUnit
    @State private var fenciUnitTitle: String
    init(inputText: String = "") {
        self.inputText = inputText
        self.textList = []
        self.fenciUnit = .word
        self.fenciUnitTitle = "按单词分词"
    }

    var body: some View {
        NavigationView {
            VStack {
                Menu {
                    Button(action: {
                        fenciUnit = .word
                        fenciUnitTitle = "按单词分词"
                    }) {
                        Label("按单词分词", systemImage: "character")
                    }
                } label: {
                    SimpleTextItemView(title: "分词类型", detail: fenciUnitTitle)
                }
                TextField("Placeholder", text: $inputText)
                    .onChange(of: inputText) {
                        textList = FenciUtil(fenciUnit).fenci(inputText)
                    }
                List(textList, id: \.self) {
                    Text($0)
                }
            }
        }
        .navigationTitle("文本分词")
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline) // 标题保持较小尺寸，始终在导航栏中显示
        #endif
    }

    private func fenci(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: fenciUnit)
        tokenizer.string = text

        var tokens: [String] = []

        tokenizer.enumerateTokens(in: text.startIndex ..< text.endIndex) { tokenRange, _ in
            let token = String(text[tokenRange])
            tokens.append(token)
            return true
        }

        return tokens
    }
}

#Preview {
    LabView()
}
