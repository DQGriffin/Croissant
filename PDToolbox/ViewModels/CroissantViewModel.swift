//
//  CroissantViewModel.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/26/22.
//

import Foundation

class CroissantViewModel: ObservableObject {
    
    let reader = IVRReader()
    let writer = XMLWriter()
    @Published var status = ""
    @Published var error = ""
    @Published var hasMenus = false
    @Published var isDone = false
    @Published var isInsertNewlineEnabled = false
    @Published var isIsolateExtensionNumberEnabled = false
    @Published var isSanitizePrompsEnabled = true
    var menus: [IVRMenu] = []
    
    init() {
    }
    
    func readCSV(atPath path: URL) {
        setStatus(to: "Reading file at \(path.path)")
        menus = reader.readCSV(atPath: path)
        setStatus(to: "Read \(menus.count) IVR Menus")
    }
    
    func setStatus(to newStatus: String) {
        Task {
            await MainActor.run {
                status = newStatus
                print(newStatus)
            }
        }
    }
    
    func writeXML() {
        setStatus(to: "Writing XML file")
        let manager = FileManager()
        var path = manager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        path.appendPathComponent("Auto-Receptionist.xml")
        print("Constructed Path: \(path.path)")
        writer.write(menus: menus, toPath: path)
        setStatus(to: "Auto-Receptionist.xml exported to downloads folder")
        
    }
    
    func transformCSV(atPath path: URL) {
        readCSV(atPath: path)
        if isSanitizePrompsEnabled {
            sanitizePrompts()
        }
        writeXML()
        Task {
            await MainActor.run {
                //hasMenus = true
                isDone = true
            }
        }
    }
    
    func sanitizePrompts() {
        var index = 0
        
        while index < menus.count {
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
            index += 1
        }
    }
    
}
