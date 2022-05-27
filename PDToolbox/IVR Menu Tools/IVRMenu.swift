//
//  IVRMenu.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/24/22.
//

import Foundation

struct IVRMenu: Codable, Identifiable {
    let id = UUID()
    var extensionNumber: String
    var name: String
    var language: String = "English (United States)"
    var isUsingTextToSpeech = true
    var prompt: String
    var actions: [IVRKeyPress]
}
