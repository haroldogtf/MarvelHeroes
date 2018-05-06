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

    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!

    @IBOutlet weak var comicsCollectionView: UICollectionView!
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!

    var comicsImagesURL: [String] = []
    var seriesImagesURL: [String] = []
    var storiesImagesURL: [String] = []
    var eventsImagesURL: [String] = []

    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCharacter()
        setupCollectionViews()
        
        fetchData()
    }
    
    func setupCharacter() {
        titleNavigationItem.title = character.name
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        descriptionLabel.text = character.about
    }

    func setup(collectionView: UICollectionView) {
        if let layout = collectionView.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 5.0
            layout.itemSize = collectionView.frame.insetBy(dx: 80, dy: 20).size
            (collectionView.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: nil)
            (collectionView.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
            layout.angle = 45
        }
    }
    
    func setupCollectionViews() {
        setup(collectionView: comicsCollectionView)
        setup(collectionView: seriesCollectionView)
        setup(collectionView: storiesCollectionView)
        setup(collectionView: eventsCollectionView)
    }
    
    func fetchData() {
        CharactersAPIConnection.getComics(character: character) { (details, error) in
            for detail in details { self.comicsImagesURL.append(detail.photoURL ?? "") }
            self.comicsCollectionView.reloadData()
        }
        
        CharactersAPIConnection.getSeries(character: character) { (details, error) in
            for detail in details { self.seriesImagesURL.append(detail.photoURL ?? "") }
            self.seriesCollectionView.reloadData()
        }
        
        CharactersAPIConnection.getStories(character: character) { (details, error) in
            for detail in details { self.storiesImagesURL.append(detail.photoURL ?? "") }
            self.storiesCollectionView.reloadData()
        }
        
        CharactersAPIConnection.getEvents(character: character) { (details, error) in
            for detail in details { self.eventsImagesURL.append(detail.photoURL ?? "") }
            self.eventsCollectionView.reloadData()
        }
    }

}

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case Constants.COMICS: return comicsImagesURL.count
        case Constants.SERIES: return seriesImagesURL.count
        case Constants.STORIES: return storiesImagesURL.count
        case Constants.EVENTS: return eventsImagesURL.count
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var imageURL: String = ""
        switch collectionView.tag {
        case Constants.COMICS: imageURL = comicsImagesURL[indexPath.row]
        case Constants.SERIES: imageURL = seriesImagesURL[indexPath.row]
        case Constants.STORIES: imageURL = storiesImagesURL[indexPath.row]
        case Constants.EVENTS: imageURL = eventsImagesURL[indexPath.row]
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
