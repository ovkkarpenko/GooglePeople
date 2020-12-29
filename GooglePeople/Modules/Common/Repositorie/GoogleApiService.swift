//
//  GoogleApiService.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 29.12.2020.
//

import Alamofire
import GoogleSignIn
import SwiftyXMLParser
import Foundation

class GoogleApiService {
    
    static let shared = GoogleApiService()
    
    func getContacts(_ completion: (([ContactModel]) -> ())? = nil) {
        guard let token = AppConfig.shared.accessToken else { return }
        
        AF.request(ServerConfig.contact.url(), headers: ["Authorization": "Bearer \(token)"])
            .responseString { (response) in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode))")
                    if let string = response.value?.data(using: .utf8) {
                        let xml = XML.parse(string)
                        let contacts = ContactModel.parseXml(xml)
                        completion?(contacts)
                        print("XML: \(string)")
                    }
                case .failure(let error):
                    statusCode = error._code
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
            }
    }
}
