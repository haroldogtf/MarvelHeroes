//
//  CharacterDetailViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 05/05/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import MMBannerLayout
import SDWebImage
import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var titleNavigationItem: UINavigationItem!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    @IBOutlet weak var seriesCollectionView: UICollectionView!

    var comicsImagesURL: [String] = []
    var seriesImagesURL: [String] = []

    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCharacter()
        setupCollectionView()
        
        fetchData()
    }
    
    func setupCharacter() {
        titleNavigationItem.title = character.name
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        descriptionLabel.text = character.about
    }

    func setupCollectionView() {
        if let layout = comicsCollectionView.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 5.0
            layout.itemSize = comicsCollectionView.frame.insetBy(dx: 80, dy: 20).size
            (comicsCollectionView.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: nil)
            (comicsCollectionView.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
            layout.angle = 45
        }
        
        if let layout = seriesCollectionView.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 5.0
            layout.itemSize = seriesCollectionView.frame.insetBy(dx: 80, dy: 20).size
            (seriesCollectionView.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: nil)
            (seriesCollectionViews.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
            layout.angle = 45
        }
    }
    
    func fetchData() {
        CharactersAPIConnection.getComics(character: character) { (details, error) in
            for detail in details {
                self.comicsImagesURL.append(detail.photoURL ?? "")
            }
            self.comicsCollectionView.reloadData()
        }
        
        CharactersAPIConnection.getSeries(character: character) { (details, error) in
            for detail in details {
                self.seriesImagesURL.append(detail.photoURL ?? "")
            }
            self.seriesCollectionView.reloadData()
        }
    }

}

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1: return comicsImagesURL.count
        case 2: return seriesImagesURL.count
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var imageURL: String = ""
        switch collectionView.tag {
        case 1: imageURL = comicsImagesURL[indexPath.row]
        case 2: imageURL = seriesImagesURL[indexPath.row]
        default: break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterDetailCollectionViewCell", for: indexPath) as! CharacterDetailCollectionViewCell
        cell.photoImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))

        return cell
    }

}

class CharacterDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
}
