//
//  SettingService.swift
//  Just Note
//
//  Created by zzh on 2024/9/3.
//

import Foundation
import SwiftUtils

private class SettingNDIdList {
    let auto_paste_in_edit = "auto_paste_in_edit"
    let show_keyboard_in_edit = "show_keyboard_in_edit"
}

class SettingService {
    private let UDUtil = UserDefaultUtil()
    private let UDids = SettingNDIdList()
    init() {}
    func setAutoPasteMode(value: Bool) {
        UDUtil.setBool(key: UDids.auto_paste_in_edit, value: value)
    }

    func getAutoPasteMode() -> Bool {
        return UDUtil.getBool(key: UDids.auto_paste_in_edit) ?? false
    }

    func setShowKeyboardMode(value: Bool) {
        UDUtil.setBool(key: UDids.show_keyboard_in_edit, value: value)
    }

    func getShowKeyboardMode() -> Bool {
        return UDUtil.getBool(key: UDids.show_keyboard_in_edit) ?? false
    }
}
