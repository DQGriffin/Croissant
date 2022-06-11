//
//  ExcelIVRReader.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/28/22.
//

import Foundation
import CoreXLSX

struct ExcelIVRReader {
    
    let columnMap: [String : String] = ["A":"Menu Name", "B":"Menu Ext", "C":"?", "D":"Prompt", "E":"?", "F":"Key 1 Action", "G": "Key 1 Destination", "H":"Key 2 Action","I":"Key 2 Destination",
                                        "J":"Key 3 Action", "K":"Key 3 Destination", "L":"Key 4 Action", "M":"Key 4 Destination", "N":"Key 5 Action", "O":"Key 5 Destination",
                                        "P":"Key 6 Action", "Q":"Key 6 Destination", "R":"Key 7 Action", "S":"Key 7 Destination", "T":"Key 8 Action", "U":"Key 8 Destination",
                                        "V":"Key 9 Action", "W":"Key 9 Destination", "X":"Key 0 Action", "Y":"Key 0 Destination", "Z":"?", "AA":"?"]
    
    init() {}
    
    func readExcel(atPath url: URL) throws -> [IVRMenu] {
        guard let file = XLSXFile(filepath: url.path) else {
            throw ExcelError.BadFile
        }
        
        guard let sharedStrings = try file.parseSharedStrings() else {
            throw ExcelError.BadSharedStrings
        }
        
        var menus: [IVRMenu] = []
        
        for wbk in try file.parseWorkbooks() {
            for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                if let worksheetName = name {
                    if worksheetName == "IVRs" {
                        let worksheet = try file.parseWorksheet(at: path)
                        for row in worksheet.data?.rows ?? [] {
                            var rowData = ""
                            for c in row.cells {
                                if let value = c.value {
                                    let rowIndex = "\(c.reference)".filter("ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains)
                                    rowData += "\(columnMap[rowIndex]!);\(c.stringValue(sharedStrings)!) ^ "
                                }
                            }
                            if let menu = createMenu(fromString: rowData) {
                                menus.append(menu)
                            }
                        }
                    }
                }
            }
        }
        print("Menus Read: \(menus.count)")
        return menus
    }
    
    func createMenu(fromString rawData: String) -> IVRMenu? {
        var menu: IVRMenu? = nil
        
        if rawData != "" && !rawData.contains("Prompt Name/Script"){
            var ivrDataPoints = rawData.split(separator: "^")
            var ivrData: [String : String] = [:]
            
            var index = 0
            while index < ivrDataPoints.count {
                ivrDataPoints[index] = ivrDataPoints[index].dropLast()
                if ivrDataPoints[index].starts(with: " ") {
                    ivrDataPoints[index] = ivrDataPoints[index].dropFirst()
                }
                
                let dataPoint = ivrDataPoints[index].split(separator: ";")
                
                if dataPoint.count > 0 {
                    ivrData[String(dataPoint[0])] = String(dataPoint[1])
                }
            
                index += 1
            }
            
            menu = IVRMenu(extensionNumber: ivrData["Menu Ext"]!, name: ivrData["Menu Name"]!, prompt: ivrData["Prompt"]!, actions: [])
            
            if menu!.prompt.lowercased().contains(".wav") || menu!.prompt.lowercased().contains(".mp3") {
                menu?.isUsingTextToSpeech = false
            }
            
            var key = 0
            while key < 10 {
                let keyPressActionKey = "Key \(key) Action"
                let keyPressDestinationKey = "Key \(key) Destination"
                if ivrData.keys.contains(keyPressActionKey) {
                    let actionType = getActionType(forRawActionType: ivrData[keyPressActionKey]!)
                    let destination = ivrData[keyPressDestinationKey] ?? ""
                    
                    
                    let action = IVRKeyPress(key: "\(key)", actionType: actionType, destination: destination)
                    menu?.actions.append(action)
                }
                key += 1
            }
        }
        return menu
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
            return "ForwardToExtension"
        }
    }
    
}


enum ExcelError: Error {
    case BadFile
    case BadSharedStrings
}
