//
//  SceneDelegate.swift
//  Tracker
//
//  Created by alexander on 09.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let viewController = TabBarController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

