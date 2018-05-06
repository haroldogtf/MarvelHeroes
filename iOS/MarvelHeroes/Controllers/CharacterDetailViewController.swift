//
//  CharacterDetailViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 05/05/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var titleNavigationItem: UINavigationItem!

    var character: Character!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNavigationItem.title = character.name
    }

}
