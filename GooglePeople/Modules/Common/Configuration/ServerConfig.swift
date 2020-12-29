//
//  ServerConfig.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 29.12.2020.
//

import Foundation

let baseUrl = "https://www.google.com"

enum ServerConfig {
    case contact
    case contactProfileImage(contactId: String)
    
    func url() -> String {
        switch self {
        case .contact:
            return "\(baseUrl)/m8/feeds/contacts/default/full"
        case .contactProfileImage(let contactId):
            return "\(baseUrl)/m8/feeds/photos/media/default/\(contactId)"
        }
    }
}
