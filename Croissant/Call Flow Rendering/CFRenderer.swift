//
//  CFRenderer.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/3/22.
//

import Foundation
import CoreGraphics
import GraphicsRenderer
import AppKit

class CFRenderer {
    
    let prerenderer: CallFlowPreRenderer
    
    init(menu: IVRMenu) {
        prerenderer = CallFlowPreRenderer(menus: menu)
        print("Width: \(prerenderer.width) Height: \(prerenderer.height)")
        let image = ImageRenderer(size: CGSize(width: prerenderer.width, height: prerenderer.height)).image { ctx in
            NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
            //NSColor.black.setFill()
            NSColor.black.setStroke()
            ctx.cgContext.setLineWidth(10)
            
            let backgroundRectangle = CGRect(x: 0, y: 0, width: prerenderer.width, height: prerenderer.height)
            ctx.cgContext.addRect(backgroundRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Add menu
            let menuRenderable = prerenderer.renderables[0]
            menuRenderable.y = ctx.cgContext.height / 4
            menuRenderable.x = (ctx.cgContext.width / 4) - (menuRenderable.width / 2)
            print("Menu X: \(menuRenderable.x) Menu y: \(menuRenderable.y)")
            var horizontalLine = CGRect()
            
            // Add vertical line
            if prerenderer.renderables.count >= 2 {
                ctx.cgContext.move(to: CGPoint(x: menuRenderable.x + (menuRenderable.width  / 2), y: menuRenderable.y))
                ctx.cgContext.addLine(to: CGPoint(x: menuRenderable.x + (menuRenderable.width  / 2), y: menuRenderable.y - (RenderDefaults.verticalPadding / 3)))
            }
            
            // Add Key Presses
            var index = 1
            var offset = getInitialOffset(forRenderables: prerenderer.renderables)
            while index < prerenderer.renderables.count {
                let ren = prerenderer.renderables[index]
                let rect = CGRect(x: menuRenderable.x + offset, y: menuRenderable.y - ren.yOffset, width: ren.width, height: ren.height)
                ren.x = menuRenderable.x + offset
                ren.y = menuRenderable.y - ren.yOffset
                ctx.cgContext.addRect(rect)
                offset += RenderDefaults.horizontalPadding
                
                ctx.cgContext.move(to: CGPoint(x: rect.minX + (rect.width / 2), y: rect.minY + rect.height))
//                ctx.cgContext.addLine(to: CGPoint(x: menuRenderable.x + (menuRenderable.width / 2), y: menuRenderable.y))
                ctx.cgContext.addLine(to: CGPoint(x: rect.minX + (rect.width / 2), y: (rect.minY + rect.height + CGFloat((RenderDefaults.verticalPadding / 3)) )))
                
                index += 1
            }
            
            // Add horizontal line
            if prerenderer.renderables.count > 2 {
                let firstActionAnchorPoint = CGPoint(x: prerenderer.renderables[1].x + (prerenderer.renderables[1].width / 2), y: (prerenderer.renderables[1].y + prerenderer.renderables[1].height) + (RenderDefaults.verticalPadding / 3))
                let last = CGPoint(x: prerenderer.renderables[prerenderer.renderables.count - 1].x + (prerenderer.renderables[prerenderer.renderables.count - 1].width / 2), y: (prerenderer.renderables[prerenderer.renderables.count - 1].y + prerenderer.renderables[prerenderer.renderables.count - 1].height) + (RenderDefaults.verticalPadding / 3))
                ctx.cgContext.move(to: firstActionAnchorPoint)
                ctx.cgContext.addLine(to: last)
            }
            
            NSColor.white.setFill()
            NSColor.black.setStroke()
            ctx.cgContext.setLineWidth(1)
            let rectangle = CGRect(x: menuRenderable.x, y: menuRenderable.y, width: menuRenderable.width, height: menuRenderable.height)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        if let pngData = image.png {
            do {
                try pngData.write(to: URL(fileURLWithPath: "/Users/dquavius/Downloads/\(menu.name).png"))
            }
            catch {
                print("Bruh, writing the image failed")
            }
        }
    }
    
    func getInitialOffset(forRenderables renderables: [CFRenderable]) -> Int {
        switch renderables.count - 1 {
        case 1:
            return 0
        case 2:
            return -70
        case 3:
            return -150
        case 4:
            return -220
        case 5:
            return -300
        case 6:
            return -375
        case 7:
            return -450
        case 8:
            return -530
        case 9:
            return -600
        case 10:
            return -680
        default:
            return 0
        }
    }
    
}
