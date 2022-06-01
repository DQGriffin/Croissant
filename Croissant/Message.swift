//
//  Message.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/30/22.
//

import Foundation
import AlertToast

struct Message {
    let body: String
    let type: AlertToast.AlertType
    let mode: AlertToast.DisplayMode
    let duration: MessageDuration
}

enum MessageDuration: Int {
    case short
    case long
    case veryLong
    
    var value: Double {
        switch self {
        case .short:
            return 3
        case .long:
            return 5
        case .veryLong:
            return 10
        }
    }
}
