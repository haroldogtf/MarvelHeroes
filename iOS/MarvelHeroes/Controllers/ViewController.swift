//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCharacters()
    }

    func loadCharacters() {
        CharactersAPIConnection.getCharacters()
    }
    
}

