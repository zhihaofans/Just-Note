//
//  TimeService.swift
//  Just Note
//
//  Created by zzh on 2024/9/4.
//

import Foundation
import SwiftUtils

class TimeService {
    class TimeSecond {
        let Minute=60
        let Hour=60 * 60
        let Day=60 * 60 * 24
        let Week=60 * 60 * 24 * 7
    }

    func timestampToShortChinese(timestamp: Int) -> String {
        let nowTime=DateUtil().getTimestamp()
        var timeString="好久之前"
        if timestamp > nowTime {
            timeString="未来时空"
        }
        if timestamp >= nowTime - 600 {
            timeString="刚刚"
        }
        if timestamp >= nowTime - 600 {
            timeString="刚刚"
        }
        return timeString
    }
}
