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
    let clear_note_items_when_next_open = "clear_note_items_when_next_open"
    let auto_save = "auto_save"
    let exit_after_save = "exit_after_save"
}

class SettingService {
    private let UDUtil = UserDefaultUtil()
    private let UDids = SettingNDIdList()
    init() {}
    func setAutoPasteMode(value: Bool) {
        UDUtil.setBool(key: UDids.auto_paste_in_edit, value: value)
    }

    func getAutoPasteMode() -> Bool {
        return UDUtil.getBool(UDids.auto_paste_in_edit) ?? false
    }

    func setShowKeyboardMode(value: Bool) {
        UDUtil.setBool(key: UDids.show_keyboard_in_edit, value: value)
    }

    func getShowKeyboardMode() -> Bool {
        return UDUtil.getBool(UDids.show_keyboard_in_edit) ?? false
    }

    func setClearNoteNextOpen(value: Bool) {
        UDUtil.setBool(key: UDids.clear_note_items_when_next_open, value: value)
    }

    func getClearNoteNextOpen() -> Bool {
        return UDUtil.getBool( UDids.clear_note_items_when_next_open) ?? false
    }

    func setAutoSave(value: Bool) {
        UDUtil.setBool(key: UDids.auto_save, value: value)
    }

    func getAutoSave() -> Bool {
        return UDUtil.getBool(UDids.auto_save) ?? false
    }

    func setExitAfterSave(value: Bool) {
        UDUtil.setBool(key: UDids.exit_after_save, value: value)
    }

    func getExitAfterSave() -> Bool {
        return UDUtil.getBool(UDids.exit_after_save) ?? false
    }
}
