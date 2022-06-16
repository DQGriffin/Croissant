//
//  Menu.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/16/22.
//

import Foundation

struct Menu: Codable {
    var extensionNumber: String
    var name: String
    var language: String
    var prompt: Prompt
    var callHandling: CallHandling?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case extensionNumber = "Extension"
        case language = "Language"
        case prompt = "Prompt"
        case callHandling = "CallHandling"
    }
}
