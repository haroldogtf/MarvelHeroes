//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import AZCollectionViewController
import SDWebImage
import UIKit

class CharactersViewController: AZCollectionViewController {

    @IBOutlet weak var tabBar: UITabBar!

    let searchController = UISearchController(searchResultsController: nil)

    var characters: [Character] = []
    var lastIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        loadSearch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
    }

    func loadSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

extension CharactersViewController {
    
    override func AZCollectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
        cell.fill(character: characters[indexPath.row])

        return cell
    }
    
    override func AZCollectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
}

extension CharactersViewController {
    
    override func fetchData() {
        super.fetchData()
        
        loadNextPageLoaderCell(nibName: "NextPageLoaderCell", cellIdentifier: "NextPageLoaderCell")

        CharactersAPIConnection.getCharacters() { (characters, error) in
            self.characters.removeAll()
            self.characters.append(contentsOf: characters)
            self.didfetchData(resultCount: characters.count, haveMoreData: true)

             if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }

    override func fetchNextData() {
        super.fetchNextData()

        CharactersAPIConnection.getCharacters(offset: characters.count) { (total, characters, error) in
            self.characters.append(contentsOf: characters)
            if self.characters.count < total {
                self.didfetchData(resultCount: characters.count, haveMoreData: true)
            
            } else {
                self.didfetchData(resultCount: characters.count, haveMoreData: false)
            }

            if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }
    
}

extension CharactersViewController {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = 170.0

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsetsMake(10, edgeInsets - 5, 0, edgeInsets - 5)
    }

}

extension CharactersViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

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
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        nameLabel.text = character.name
        favoriteImageView.image = #imageLiteral(resourceName: "star-nofavorite")
    }

}
