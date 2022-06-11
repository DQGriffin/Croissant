//
//  CFRenderable.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/3/22.
//

import Foundation

class CFRenderable {
    var x: Int
    var y: Int
    var height: Int
    var width: Int
    var extensionNumber: String
    var label: String
    var relativeTo: CFRenderable?
    var id = UUID()
    var yOffset = 0
    var xOffset = 0
    var anchorPoint: CGPoint?
    var key: String?
    var type: IVRActionType?
    
    init(label name: String, extensionNumber number: String, actionType: String? = nil, positionRelativeTo anchor: CFRenderable? = nil) {
        x = 0
        y = 0
        height = RenderDefaults.height
        width = RenderDefaults.width
        extensionNumber = number
        label = name
        type = .forwardToExtension
        if let safeActionType = actionType {
            type = getActionType(actionTypeString: safeActionType)
        }
        calculateAnchorPoint()
    }
    
    func getActionType(actionTypeString: String) -> IVRActionType {
        switch actionTypeString {
        case "ConnectToDialByNameDirectory":
            return.dialByNameDirectory
        case "ForwardToExternal":
            return .forwardToExternal
        case "ForwardToVoiceMail":
            return .forwardToVoicemail
        case "ForwardToExtension":
            return .forwardToExtension
        default:
            return .forwardToExtension
        }
    }
    
    func calculateAnchorPoint() {
        anchorPoint = CGPoint(x: x + (width / 2), y: y)
    }
}
