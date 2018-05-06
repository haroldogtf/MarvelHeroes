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

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var character: Character!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCharacter()
    }
    
    func setupCharacter() {
        titleNavigationItem.title = character.name
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        descriptionLabel.text = character.about
    }

}
