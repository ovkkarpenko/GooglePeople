//
//  AppDelegate.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 28.12.2020.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance()?.scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance()?.scopes.append("https://www.googleapis.com/auth/contacts.readonly")
        
        let rootVc = AuthViewController()
        
        window = UIWindow()
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

