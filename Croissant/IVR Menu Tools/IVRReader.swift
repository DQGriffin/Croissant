//
//  IVRReader.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/24/22.
//

import Foundation
import SwiftCSV

struct IVRReader {
    
    init() {}
    
    func readCSV(atPath url: URL) -> [IVRMenu] {
        do {
            //let url = URL(fileURLWithPath: path)
            let csv = try CSV(url: url)
            var index = 0
            var menus: [IVRMenu] = []
            
            while index < csv.namedRows.count {
                let name = csv.namedRows[index]["Menu Name"]!
                let extensionNumber = csv.namedRows[index]["Menu Ext"]!
                let prompt = csv.namedRows[index]["Prompt Name/Script"]!
                var menu = IVRMenu(extensionNumber: extensionNumber, name: name, prompt: prompt, actions: [])
                
                if menu.prompt.lowercased().contains(".wav") || menu.prompt.lowercased().contains(".mp3") {
                    menu.isUsingTextToSpeech = false
                }
                
                var keyPress = 0
                
                while keyPress < 10 {
                    if let rawActionType = csv.namedRows[index]["Key \(keyPress) Action"] {
                        if rawActionType != "" {
                            let actionType = getActionType(forRawActionType: rawActionType)
                            let keyPressDestination = csv.namedRows[index]["Key \(keyPress) Destination"]!
                            //print("Destination: \(keyPressDestination)")
                            let menuKeyPress = IVRKeyPress(key: "\(keyPress)", actionType: actionType, destination: keyPressDestination)
                            menu.actions.append(menuKeyPress)
                            //menus.append(menu)
                        }
                    }
                    keyPress += 1
                }
                menus.append(menu)
                index += 1
            }
            return menus
            
        } catch {
            print("IVRReader: Failed to read CSV file")
            print(error)
            return []
        }
    }
    
    fileprivate func getActionType(forRawActionType rawActionType: String) -> String {
        switch rawActionType {
        case "Connect To Extension":
            return "ForwardToExtension"
            
        case "Connect To IVR":
            return "ForwardToExtension"
            
        case "Connect To Queue":
            return "ForwardToExtension"
            
        case "Connect to Dial-by-Name Directory":
            return "ConnectToDialByNameDirectory"
            
        case "Transfer to Voicemail of":
            return "ForwardToVoiceMail"
            
        case "External Transfer":
            return "ForwardToExternal"
            
        default:
            return rawActionType
        }
    }
    
}
