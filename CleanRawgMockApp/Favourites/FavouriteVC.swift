//
//  FavouriteVC.swift
//  CleanRawgMockApp
//
//  Created by Farhandika Zahrir Mufti guenia on 30/08/21.
//

import Foundation
import UIKit
import CoreData

class FavVC: UIViewController {
    var container: NSPersistentContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarVC = self.tabBarController as? TabBar {
            self.container = tabBarVC.container
        }
        guard container != nil else { fatalError("This view needs a persistent container.") }
        NSLayoutConstraint.activate([
        ])
    }
}
