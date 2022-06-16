//
//  XMLReader.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/16/22.
//

import Foundation
import XMLCoder

struct XMLReader {
    var ivr: MultiLevelIVR
    
    init() {
        do {
            let xmlData = try String(contentsOfFile: "/Users/dquavius/Downloads/Auto-Receptionist.xml")
            ivr = try! XMLDecoder().decode(MultiLevelIVR.self, from: Data(xmlData.utf8))
            
            print(ivr.menus.count)
            
            for menu in ivr.menus {
                print("Menu --------------------------------------")
                print(menu.name)
                print(menu.extensionNumber)
                print(menu.language)
                print("Prompt Data ===")
                print("Text-to-speech: \(menu.prompt.isUsingTextToSpeech)")
                print("Text: \(menu.prompt.text)")
                print("Filename: \(menu.prompt.name)")
                print("Call Handling ===")
                
                if let callHandling = menu.callHandling {
                    for keyPress in callHandling.keyPresses {
                        print("Key: \(keyPress.key)")
                        print("Action: \(keyPress.action)")
                        print("Destination: \(keyPress.destination)")
                    }
                }
                
            }
            
            let auditWriter = AuditWriter(multiLevelIVR: ivr)
            auditWriter.writeIVR()
            
        }
        catch {
            print("Failed to read XML File")
            print(error)
            ivr = MultiLevelIVR()
        }
    }
}
