//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import SDWebImage
import UIKit

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCharacters()
    }

    func loadCharacters() {
        CharactersAPIConnection.getCharacters(offset: 10) { (characters, error) in
            self.characters = characters
            self.collectionView.reloadData()
        }
    }
    
}

extension CharactersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
        cell.fill(character: characters[indexPath.row])

        return cell
    }

}

extension CharactersViewController: UICollectionViewDelegate {
    
}

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func fill(character: Character) {
        let photoURL = (character.photoPath ?? "") + "." + (character.photoExtension ?? "")
        photoImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "placeholder.png"))
        nameLabel.text = character.name
        //favoriteImageView
    }

}
