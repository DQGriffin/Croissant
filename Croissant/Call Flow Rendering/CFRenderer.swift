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
        let format = ImageRendererFormat(flipped: false)
        format.scale = 1
        let image = ImageRenderer(size: CGSize(width: prerenderer.width, height: prerenderer.height), format: format).image { ctx in
            //NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
            NSColor.white.setFill()
            //NSColor.black.setFill()
            NSColor.black.setStroke()
            //ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setLineWidth(0.2)
            
            let backgroundRectangle = CGRect(x: 0, y: 0, width: prerenderer.width, height: prerenderer.height)
            ctx.cgContext.addRect(backgroundRectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            ctx.cgContext.setAllowsAntialiasing(true)
            ctx.cgContext.setAllowsFontSmoothing(true)
            ctx.cgContext.setAllowsFontSubpixelPositioning(true)
            ctx.cgContext.setAllowsFontSubpixelQuantization(true)
            
            // Add menu
            let menuRenderable = prerenderer.renderables[0]
            menuRenderable.y = (ctx.cgContext.height / 3) - menuRenderable.height
            menuRenderable.x = (ctx.cgContext.width / 4) - (menuRenderable.width / 2)
            
            // Add vertical line
            if prerenderer.renderables.count >= 2 {
                ctx.cgContext.setLineWidth(1)
                ctx.cgContext.move(to: CGPoint(x: menuRenderable.x + (menuRenderable.width  / 2), y: menuRenderable.y))
                ctx.cgContext.addLine(to: CGPoint(x: menuRenderable.x + (menuRenderable.width  / 2), y: menuRenderable.y - 60))
            }
            
            // Add Key Presses
            var index = 1
            var offset = getInitialOffset(forRenderables: prerenderer.renderables)
            while index < prerenderer.renderables.count {
                let ren = prerenderer.renderables[index]
                let rect = CGRect(x: menuRenderable.x + offset, y: menuRenderable.y - ren.yOffset, width: ren.width, height: ren.height)
                ren.x = menuRenderable.x + offset
                ren.y = menuRenderable.y - ren.yOffset
                ctx.cgContext.setLineWidth(0.2)
                ctx.cgContext.addRect(rect)
                offset += RenderDefaults.horizontalPadding
                ctx.cgContext.drawPath(using: .fillStroke)
                
                //ctx.cgContext.setLineWidth(1)
                ctx.cgContext.move(to: CGPoint(x: rect.minX + (rect.width / 2), y: rect.minY + rect.height))
                ctx.cgContext.addLine(to: CGPoint(x: rect.minX + (rect.width / 2), y: (rect.minY + rect.height + CGFloat((RenderDefaults.verticalPadding / 3)) )))
                ctx.cgContext.drawPath(using: .fillStroke)
                
                index += 1
            }
            NSColor.white.setFill()
            //ctx.cgContext.drawPath(using: .fillStroke)
            
            // Add horizontal line
            if prerenderer.renderables.count > 2 {
                let firstActionAnchorPoint = CGPoint(x: prerenderer.renderables[1].x + (prerenderer.renderables[1].width / 2), y: (prerenderer.renderables[1].y + prerenderer.renderables[1].height) + (RenderDefaults.verticalPadding / 3))
                let last = CGPoint(x: prerenderer.renderables[prerenderer.renderables.count - 1].x + (prerenderer.renderables[prerenderer.renderables.count - 1].width / 2), y: (prerenderer.renderables[prerenderer.renderables.count - 1].y + prerenderer.renderables[prerenderer.renderables.count - 1].height) + (RenderDefaults.verticalPadding / 3))
                ctx.cgContext.move(to: firstActionAnchorPoint)
                ctx.cgContext.addLine(to: last)
            }
            
            NSColor.white.setFill()
            NSColor.black.setStroke()
            ctx.cgContext.setLineWidth(0.2)
            let rectangle = CGRect(x: menuRenderable.x, y: menuRenderable.y, width: menuRenderable.width, height: menuRenderable.height)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            var i = 0
            while i < prerenderer.renderables.count {
                let ren = prerenderer.renderables[i]
                
                // Add text
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                var attrs = [NSAttributedString.Key.font: NSFont(name: "Avenir", size: 8)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                let extensionAttributes = [NSAttributedString.Key.font: NSFont(name: "Avenir", size: 8)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                
                if ren.label.count > 24 && ren.label.count < 32 {
                    attrs = [NSAttributedString.Key.font: NSFont(name: "Avenir", size: 7)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                }
                else if ren.label.count >= 32 {
                    attrs = [NSAttributedString.Key.font: NSFont(name: "Avenir", size: 6)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                }
                
                //ren.label.trunc(length: 24, trailing: "\n").draw(with: CGRect(x: ren.x + 5, y: ren.y - 15, width: 448, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                ren.label.draw(with: CGRect(x: ren.x + 3, y: ren.y - 13, width: 448, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                ren.extensionNumber.draw(with: CGRect(x: ren.x + 3, y: ren.y - 35, width: 448, height: 50), options: .usesLineFragmentOrigin, attributes: extensionAttributes, context: nil)
                
                i += 1
            }
            
            // Add key press labels
            var keyPressIndex = 1
            while keyPressIndex < prerenderer.renderables.count {
                let keyPressRenderable = prerenderer.renderables[keyPressIndex]
                let keyPressRect = CGRect(x: keyPressRenderable.x + ((keyPressRenderable.width / 2) - 7), y: keyPressRenderable.y + ((RenderDefaults.verticalPadding / 2) - 20), width: 14, height: 14)
                ctx.cgContext.addEllipse(in: keyPressRect)
//                NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
                NSColor.white.setFill()
                ctx.cgContext.drawPath(using: .fillStroke)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                let attrs = [NSAttributedString.Key.font: NSFont(name: "HelveticaNeue", size: 8)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                keyPressRenderable.key!.draw(with: CGRect(x: Int(keyPressRect.midX - 2), y: keyPressRenderable.y + ((RenderDefaults.verticalPadding / 3) - 33), width: 50, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                
                keyPressIndex += 1
            }
            
            // Add color bars
            var renderablesIndex = 0
            while renderablesIndex < prerenderer.renderables.count {
                let ren = prerenderer.renderables[renderablesIndex]
                let colorBarRect = CGRect(x: ren.x, y: ren.y, width: ren.width, height: 3)
                ctx.cgContext.addRect(colorBarRect)
                //NSColor(cgColor: CGColor(red: 100 / 255, green: 211 / 255, blue: 188 / 255, alpha: 1.0))?.setFill()
                switch ren.type {
                    
                case .forwardToExtension:
                    RenderDefaults.transferToExtensionColor.setFill()
                case .forwardToVoicemail:
                    RenderDefaults.transferToVoicemailColot.setFill()
                case .forwardToExternal:
                    RenderDefaults.externalTransferColor.setFill()
                case .dialByNameDirectory:
                    RenderDefaults.dialByNameColor.setFill()
                default:
                    RenderDefaults.transferToExtensionColor.setFill()
                }
                ctx.cgContext.drawPath(using: .fill)
                renderablesIndex += 1
            }
            
            NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        if let pngData = image.png {
            do {
                let manager = FileManager()
                var path = manager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
                path.appendPathComponent("Call Flow Documentation")
                createFolder()
                path.appendPathComponent("\(menu.name).png")
                try pngData.write(to: path)
            }
            catch {
                print("Bruh, writing the image failed")
                print(error)
            }
        }
    }
    
    func createFolder() {
        let manager = FileManager()
        var path = manager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        path.appendPathComponent("Call Flow Documentation")
        
        if !manager.fileExists(atPath: path.path) {
            do {
                try manager.createDirectory(atPath: path.path, withIntermediateDirectories: false)
            }
            catch {
                print("Failed to create folder")
            }
        }
    }
    
    func renderImage(forMenu menu: IVRMenu) -> Image {
        prerenderer.createRenderables(menu: menu)
        print("Width: \(prerenderer.width) Height: \(prerenderer.height)")
        let format = ImageRendererFormat(flipped: false)
        format.scale = 1
        let image = ImageRenderer(size: CGSize(width: prerenderer.width, height: prerenderer.height), format: format).image { ctx in
            NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
            //NSColor.black.setFill()
            NSColor.black.setStroke()
            ctx.cgContext.setLineWidth(10)
            
            let backgroundRectangle = CGRect(x: 0, y: 0, width: prerenderer.width, height: prerenderer.height)
            ctx.cgContext.addRect(backgroundRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setAllowsAntialiasing(true)
            ctx.cgContext.setAllowsFontSmoothing(true)
            ctx.cgContext.setAllowsFontSubpixelPositioning(true)
            ctx.cgContext.setAllowsFontSubpixelQuantization(true)
            
            // Add menu
            let menuRenderable = prerenderer.renderables[0]
            menuRenderable.y = (ctx.cgContext.height / 3) - menuRenderable.height
            menuRenderable.x = (ctx.cgContext.width / 4) - (menuRenderable.width / 2)
            print("Menu X: \(menuRenderable.x) Menu y: \(menuRenderable.y)")
            
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
                ctx.cgContext.addLine(to: CGPoint(x: rect.minX + (rect.width / 2), y: (rect.minY + rect.height + CGFloat((RenderDefaults.verticalPadding / 3)) )))
                
//                let keyPressRect = CGRect(x: rect.minX + ((rect.width / 2) - 7), y: rect.maxY + CGFloat((RenderDefaults.verticalPadding / 4) - 14), width: 14, height: 14)
//                ctx.cgContext.addEllipse(in: keyPressRect)
                //ctx.cgContext.addRect(keyPressRect)
                
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
            
            var i = 0
            while i < prerenderer.renderables.count {
                let ren = prerenderer.renderables[i]
                
                // Add text
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                let attrs = [NSAttributedString.Key.font: NSFont(name: "HelveticaNeue", size: 8)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                ren.label.draw(with: CGRect(x: ren.x + 5, y: ren.y - 5, width: 448, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                ren.extensionNumber.draw(with: CGRect(x: ren.x + 5, y: ren.y - 35, width: 448, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                
                i += 1
            }
            
            // Add key press labels
            var keyPressIndex = 1
            while keyPressIndex < prerenderer.renderables.count {
                let keyPressRenderable = prerenderer.renderables[keyPressIndex]
                let keyPressRect = CGRect(x: keyPressRenderable.x + ((keyPressRenderable.width / 2) - 7), y: keyPressRenderable.y + ((RenderDefaults.verticalPadding / 2) - 6), width: 14, height: 14)
                ctx.cgContext.addEllipse(in: keyPressRect)
                NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
                ctx.cgContext.drawPath(using: .fillStroke)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                let attrs = [NSAttributedString.Key.font: NSFont(name: "HelveticaNeue-Thin", size: 8)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                keyPressRenderable.key!.draw(with: CGRect(x: Int(keyPressRect.midX - 2), y: keyPressRenderable.y + ((RenderDefaults.verticalPadding / 3) - 19), width: 50, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                
                keyPressIndex += 1
            }
            NSColor(cgColor: CGColor(red: 233 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1.0))?.setFill()
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        return image
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
