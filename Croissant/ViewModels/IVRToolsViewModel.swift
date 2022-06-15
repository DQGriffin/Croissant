//
//  CroissantViewModel.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/26/22.
//

import Foundation
import GraphicsRenderer


class IVRToolsViewModel: ObservableObject {
    
    let csvReader = IVRReader()
    let excelReader = ExcelIVRReader()
    let writer = XMLWriter()
    @Published var status = ""
    @Published var error = ""
    @Published var message = ""
    @Published var hasMenus = false
    @Published var isDone = false
    @Published var isInsertNewlineEnabled = false
    @Published var isIsolateExtensionNumberEnabled = true
    @Published var isSanitizePrompsEnabled = true
    @Published var hasMessage = false
    var menus: [IVRMenu] = []
    
    init() { }
    
    func readCSV(atPath path: URL) {
        setStatus(to: "Reading file at \(path.path)")
        menus = csvReader.readCSV(atPath: path)
        setStatus(to: "Read \(menus.count) IVR Menus")
    }
    
    func setStatus(to newStatus: String) {
        Task {
            await MainActor.run {
                status = newStatus
            }
        }
    }
    
    func writeXML() {
        setStatus(to: "Writing XML file")
        let manager = FileManager()
        var path = manager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        path.appendPathComponent("Auto-Receptionist.xml")
        writer.write(menus: menus, toPath: path)
        setStatus(to: "Auto-Receptionist.xml exported to downloads folder")
        
    }
    
    func transform(atPath path: URL) {
        if path.path.contains("xlsx") {
            do {
                menus = try excelReader.readExcel(atPath: path)
                setLabelsForKeyPresses()
                if isSanitizePrompsEnabled {
                    sanitizePrompts()
                }
                if isIsolateExtensionNumberEnabled {
                    isolateExtensionNumbers()
                }
                writeXML()
                postMessage("Success! XML file exported to downloads folder")
            }
            catch {
                print(error)
                postMessage("Something went wrong when trying to read the BRD")
            }
        }
        else if path.path.contains("csv") {
            readCSV(atPath: path)
            setLabelsForKeyPresses()
            if isSanitizePrompsEnabled {
                sanitizePrompts()
            }
            if isIsolateExtensionNumberEnabled {
                isolateExtensionNumbers()
            }
            writeXML()
            postMessage("Success! XML file exported to downloads folder")
        }
        else {
            postMessage("Hmmm. That doesn't look like a BRD")
        }
        getImages(forMenus: menus)
    }
    
    func transformCSV(atPath path: URL) {
        readCSV(atPath: path)
        if isSanitizePrompsEnabled {
            sanitizePrompts()
        }
        if isIsolateExtensionNumberEnabled {
            isolateExtensionNumbers()
        }
        writeXML()
        Task {
            await MainActor.run {
                //hasMenus = true
                isDone = true
            }
        }
    }
    
    func getImages(forMenus: [IVRMenu]) {
        
        for menu in menus {
            let renderer = CFRenderer(menu: menu)
        }
        
    }
    
    func sanitizePrompts() {
        var index = 0
        
        while index < menus.count {
            if menus[index].isUsingTextToSpeech {
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "_", with: "-")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "*", with: "star")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "#", with: "pound")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "@", with: "at")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "&", with: "and")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "(", with: "")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: ")", with: "")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "%", with: "percent")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "$", with: "")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "!", with: ".")
                menus[index].prompt = menus[index].prompt.replacingOccurrences(of: "?", with: ".")
            }
            index += 1
        }
    }
    
    func isolateExtensionNumbers() {
        var menuIndex = 0
        
        while menuIndex < menus.count {
            var actionIndex = 0
            
            while actionIndex < menus[menuIndex].actions.count {
                menus[menuIndex].actions[actionIndex].destination = menus[menuIndex].actions[actionIndex].destination.filter("0123456789".contains)
                actionIndex += 1
            }
            
            menuIndex += 1
        }
    }
    
    func setLabelsForKeyPresses() {
        var menuIndex = 0
        
        while menuIndex < menus.count {
            var actionIndex = 0
            
            while actionIndex < menus[menuIndex].actions.count {
                menus[menuIndex].actions[actionIndex].label = menus[menuIndex].actions[actionIndex].destination.filter("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ".contains)
                
                while menus[menuIndex].actions[actionIndex].label!.starts(with: " ") {
                    menus[menuIndex].actions[actionIndex].label = String( menus[menuIndex].actions[actionIndex].label!.dropFirst())
                }
                
                actionIndex += 1
            }
            
            menuIndex += 1
        }
    }
    
    func postMessage(_ messageToPost: String) {
        Task {
            await MainActor.run {
                message = messageToPost
                hasMessage = true
            }
        }
    }
    
}
