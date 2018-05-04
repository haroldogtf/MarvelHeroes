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

extension CharactersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth: CGFloat = 170.0
        
        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsetsMake(15, edgeInsets, 0, edgeInsets)
    }

}

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLayout()
    }
    
    func cellLayout() {
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true;
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false;
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    func fill(character: Character) {
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        nameLabel.text = character.name
        //favoriteImageView
    }

}
