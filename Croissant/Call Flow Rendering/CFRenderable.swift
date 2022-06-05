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
    
    init(label name: String, extensionNumber number: String, positionRelativeTo anchor: CFRenderable? = nil) {
        x = 0
        y = 0
        height = RenderDefaults.height
        width = RenderDefaults.width
        extensionNumber = number
        label = name
        calculateAnchorPoint()
    }
    
    func calculateAnchorPoint() {
        anchorPoint = CGPoint(x: x + (width / 2), y: y)
    }
}
