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
        writeXML()
        Task {
            await MainActor.run {
                //hasMenus = true
                isDone = true
            }
        }
    }
}
