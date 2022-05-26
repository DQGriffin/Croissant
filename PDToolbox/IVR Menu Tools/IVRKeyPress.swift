//
//  IVRKeyPress.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/24/22.
//

import Foundation

struct IVRKeyPress: Codable {
    var key: String
    var actionType: String
    var destination: String
}

enum IVRActionType: Int, Codable {
    case forwardToExtension
    case forwardToVoicemail
    case forwardToExternal
    case dialByNameDirectory
    
    var description: String {
        switch self {
        case .forwardToExtension:
            return "ForwardToExtension"
        case .dialByNameDirectory:
            return "ConnectToDialByNameDirectory"
        case .forwardToVoicemail:
            return "ForwardToVoiceMail"
        case .forwardToExternal:
            return "ForwardToExternal"
        }
    }
}
