//
//  Prompt.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/15/22.
//

import Foundation

struct Prompt: Codable {
    var text: String?
    var name: String?
    var isUsingTextToSpeech: Bool
    
    enum CodingKeys: String, CodingKey {
        case text = "Text"
        case name = "Name"
        case isUsingTextToSpeech = "TextToSpeech"
    }
}
