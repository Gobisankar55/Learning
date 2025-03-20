//
//  ApperanceManager.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//

import UIKit

class ApperanceManager {
    
    static func setupAppearance() {
        let navBar = UINavigationBar.appearance(for: UITraitCollection(verticalSizeClass: .unspecified))
        navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.red]
        
        let navBarCompact = UINavigationBar.appearance(for: UITraitCollection(verticalSizeClass: .compact))
        navBarCompact.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.orange]
    }
}
