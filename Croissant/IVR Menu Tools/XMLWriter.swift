//
//  XMLWriter.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/24/22.
//

import Foundation

struct XMLWriter: IVRFileWriter {
    func write(menus: [IVRMenu], toPath path: URL) {
        var output = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        output += "<MultilevelIVR>\n"
        
        for menu in menus {
            output += "<Menu>\n"
            output += "\t<Extension>\(menu.extensionNumber)</Extension>\n"
            output += "\t<Name>\(menu.name)</Name>\n"
            output += "\t<Language>\(menu.language)</Language>\n"
            output += "\t<Prompt>\n"
            if menu.isUsingTextToSpeech {
                output += "\t\t<Text>\(menu.prompt)</Text>\n"
                output += "\t\t<TextToSpeech>true</TextToSpeech>\n"
            }
            else {
                output += "\t\t<Name>\(menu.prompt)</Name>\n"
                output += "\t\t<Text>\(menu.prompt)</Text>\n"
                output += "\t\t<TextToSpeech>false</TextToSpeech>\n"
            }
            output += "\t</Prompt>\n"
            output += "<CallHandling>\n"
            
            for action in menu.actions {
                output += "\t<DigitKeyInput>\n"
                output += "\t\t<Key>\(action.key)</Key>\n"
                output += "\t\t<Action>\(action.actionType)</Action>\n"
                if action.actionType != "ConnectToDialByNameDirectory" {
                    output += "\t\t<Destination>\(action.destination)</Destination>\n"
                }
                output += "\t</DigitKeyInput>\n"
            }
            
            output += "</CallHandling>\n"
            output += "</Menu>\n"
        }
        
        output += "</MultilevelIVR>\n"
        
        do {
            try output.write(to: path, atomically: false, encoding: .utf8)
        }
        catch {
            print("Failed to write file")
            print(error)
        }
    }
    
    
}
