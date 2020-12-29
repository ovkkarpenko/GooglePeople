//
//  AppConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Firebase
import Foundation

class AppConfig {
    static let shared = AppConfig()
    
    private let idTokenKey = "idToken"
    private let accessTokenKey = "accessToken"
    
    var currentUser: User?
    
    var idToken: String? {
        get {
            UserDefaults.standard.string(forKey: idTokenKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: idTokenKey)
        }
    }
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: accessTokenKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: accessTokenKey)
        }
    }
}
