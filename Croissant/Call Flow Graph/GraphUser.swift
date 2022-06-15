//
//  GraphUser.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/12/22.
//

import Foundation

struct GraphUser: GraphObject, Codable {
    
    // MARK: GraphObject properties
    var extensionNumber: String
    var phoneNumbers: [String]?
    var type: GraphObjectType
    var emailAddress: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: GraphUser properties
    var firstName: String
    var lastName: String
    var countryCode: String?
    var portingNumber: String?
    var role: UserRole = .standardInternational
    var costCode: String?
    
    init() {
        firstName = ""
        lastName = ""
        extensionNumber = ""
        phoneNumbers = []
        type = .user
        emailAddress = ""
    }
    
    init(firstName: String, lastName: String, extensionNumber: String, emailAddress: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.extensionNumber = extensionNumber
        self.emailAddress = emailAddress
        type = .user
    }
    
    init(firstName: String, lastName: String, extensionNumber: String, emailAddress: String, countryCode: String, portingNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.extensionNumber = extensionNumber
        self.emailAddress = emailAddress
        self.countryCode = countryCode
        self.portingNumber = portingNumber
        type = .user
    }
}


// MARK: UserRole enum
enum UserRole: Int, Codable {
    case standard
    case standardInternational
    case manager
    case phoneSystemAdmin
    case userAdmin
    case superAdmin
    
    var description: String {
        switch self {
        case .standard:
            return "Standard"
        case .standardInternational:
            return "Standard (International)"
        case .manager:
            return "Manager"
        case .phoneSystemAdmin:
            return "Phone System Admin"
        case .userAdmin:
            return "User Admin"
        case .superAdmin:
            return "Super Admin"
        }
    }
}
