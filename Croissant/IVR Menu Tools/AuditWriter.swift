//
//  AuditWriter.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/15/22.
//

import Foundation
import SwiftCSV

struct AuditWriter {
    
    let menus: [IVRMenu]
    var csvData: String
    
    init(menus: [IVRMenu]) {
        self.menus = menus
        csvData = "Menu Name,Menu Ext,Prompt Name/Script,"
        
        var keyPressIndex = 1
        while keyPressIndex < 10 {
            csvData += "Key \(keyPressIndex) Action,Key \(keyPressIndex) Destination,"
            keyPressIndex += 1
        }
        csvData += "Key 0 Action,Key 0 Destination,"
        csvData += "\n"
        generateAudit()
        print(csvData)
    }
    
    mutating func generateAudit() {
        for menu in menus {
            csvData += "\(menu.name),\(menu.extensionNumber),\(menu.prompt),"
            
            var actionMap: [String: String] = [:]
            
            for action in menu.actions {
                actionMap[action.key] = "\(action.actionType),\(action.destination),"
            }
            
            var index = 1
            while index < 10 {
                if actionMap.keys.contains("\(index)") {
                    csvData += actionMap["\(index)"]!
                }
                else {
                    csvData += ",,"
                }
                index += 1
            }
            
            
            if menu.actions.count > 0 {
                for action in menu.actions {
                    if action.key == "0" {
                        csvData += "\(action.actionType),\(action.destination),"
                    }
                }
            }
            csvData += "\n"
        }
    }
    
    func write() {
        let manager = FileManager()
        var path = manager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        path.appendPathComponent("Audit.csv")
        
        do {
            try csvData.write(to: path, atomically: false, encoding: .utf8)
        }
        catch {
            print("Failed to write audit file")
        }
        
    }
    
}
