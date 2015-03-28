//
//  TabBarController.swift
//  ChatterBuzz
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 sfm. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.delegate = self
        self.selectedIndex = 2
    }
}
