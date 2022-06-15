//
//  GraphObject.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/12/22.
//

import Foundation

protocol GraphObject {
    var name: String { get }
    var extensionNumber: String { get }
    var phoneNumbers: [String]? { get }
    var type: GraphObjectType { get }
    var emailAddress: String { get }
}

enum GraphObjectType: Int, Codable {
    case user
    case limitedExtension
    case callQueue
    case ivrMenu
}
