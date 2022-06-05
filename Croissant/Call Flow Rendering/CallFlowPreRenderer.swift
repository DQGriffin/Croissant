//
//  CallFlowPreRenderer.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/3/22.
//

import Foundation

class CallFlowPreRenderer {
    var renderables: [CFRenderable]
    
    var width: Int {
        var calculatedWidth = 0
        
        for renderable in renderables {
            calculatedWidth += (renderable.width + (RenderDefaults.horizontalPadding / 2))
        }
        return calculatedWidth >= height ? calculatedWidth : height
    }
    
    var height = 500
    
    init() {
        renderables = []
    }
    
    init(menus: IVRMenu) {
        renderables = []
        createRenderables(menu: menus)
    }
    
    func createRenderables(menu: IVRMenu) {
        renderables.removeAll()
        let menuRenderable = CFRenderable(label: menu.name, extensionNumber: menu.extensionNumber)
        renderables.append(menuRenderable)
        
        var horizontalOffset = -220
        for keyPress in menu.actions {
            var renderable = CFRenderable(label: keyPress.destination, extensionNumber: keyPress.destination, positionRelativeTo: menuRenderable)
            renderable.yOffset = RenderDefaults.verticalPadding
            renderable.xOffset = RenderDefaults.horizontalPadding
            if keyPress.actionType == "ConnectToDialByNameDirectory" {
                renderable.label = "Dial-by-Name Directory"
            }
            else if keyPress.actionType == "ForwardToExternal" && keyPress.label == "" {
                renderable.label = "External Transfer"
            }
            else if keyPress.label == "" {
                renderable.label = keyPress.destination
            }
            else {
                renderable.label = keyPress.label ?? "???"
            }
            
            renderable.key = keyPress.key
            
            renderables.append(renderable)
            horizontalOffset += RenderDefaults.horizontalPadding
        }
        
//        menuRenderable.y = height / 2
//        menuRenderable.x = (width / 2) - (RenderDefaults.horizontalPadding * 2)
//        print("Renderable y: \(menuRenderable.y)")
    }
}
