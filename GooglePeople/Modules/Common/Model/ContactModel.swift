//
//  ContactModel.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 29.12.2020.
//

import SwiftyXMLParser
import Foundation

struct ContactModel {
    
    var id: String
    var fullName: String
    var email: String
}

extension ContactModel {
    
    static func parseXml(_ xml: XML.Accessor) -> [Self] {
        
        var contacts: [Self] = []
        
        if let entries = xml["feed", "entry"].all {
            entries.forEach { item in
                if let id = item.childElements.first(where: { $0.name == "id" })?.text?.split(separator: "/").last,
                   let fullName = item.childElements.first(where: { $0.name == "title" })?.text,
                   let email = item.childElements.first(where: { $0.name == "gd:email" })?.attributes["address"] {
                    contacts.append(ContactModel(id: "\(id)", fullName: fullName, email: email))
                }
            }
        }
        return contacts
    }
}
