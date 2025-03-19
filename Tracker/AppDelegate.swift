//
//  AppDelegate.swift
//  Tracker
//
//  Created by alexander on 09.03.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.storyboard = nil
        sceneConfiguration.sceneClass = UIWindowScene.self
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

