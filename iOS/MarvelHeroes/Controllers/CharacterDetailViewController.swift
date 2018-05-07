//
//  CharacterDetailViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 05/05/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import MMBannerLayout
import PKHUD
import SDWebImage
import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!

    @IBOutlet weak var comicsCollectionView: UICollectionView!
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    @IBOutlet weak var comicsLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var seriesLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var eventsLabelHeight: NSLayoutConstraint!

    @IBOutlet weak var comicsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seriesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventsCollectionViewHeight: NSLayoutConstraint!
    
    var comicsImagesURL: [String] = []
    var seriesImagesURL: [String] = []
    var eventsImagesURL: [String] = []

    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCharacter()
        setupCollectionViews()
        setupFavorite()
        
        fetchData()
    }
    
    func setupCharacter() {
        titleNavigationItem.title = character.name
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        descriptionLabel.text = character.about
    }

    func setup(collectionView: UICollectionView) {
        collectionView.showsHorizontalScrollIndicator = false

        if let layout = collectionView.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 5.0
            layout.itemSize = collectionView.frame.insetBy(dx: 80, dy: 20).size
            (collectionView.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: nil)
            (collectionView.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
            layout.angle = 45
        }
    }
    
    func setupCollectionViews() {
        comicsLabelHeight.constant = 0
        seriesLabelHeight.constant = 0
        eventsLabelHeight.constant = 0
        
        comicsCollectionViewHeight.constant = 0
        seriesCollectionViewHeight.constant = 0
        eventsCollectionViewHeight.constant = 0
        
        setup(collectionView: comicsCollectionView)
        setup(collectionView: seriesCollectionView)
        setup(collectionView: eventsCollectionView)
    }
    
    func setupFavorite() {
        favoriteButton.image = character.favorite ? #imageLiteral(resourceName: "star-favorite") : #imageLiteral(resourceName: "star-nofavorite")
    }

    func fetchData() {
        HUD.show(.progress)
        
        CharactersAPIConnection.getComics(character: character) { (details, error) in
            HUD.hide()

            if details.count > 0 {
                
                for detail in details {
                    self.comicsImagesURL.append(detail.photoURL ?? "")
                }
        
                self.comicsLabelHeight.constant = Constants.VALUE_SECTION_HEIGHT
                self.comicsCollectionViewHeight.constant = Constants.VALUE_COLLECTIONVIEW_HEIGHT
                
                self.comicsCollectionView.reloadData()
            }
        }
        
        CharactersAPIConnection.getSeries(character: character) { (details, error) in
            HUD.hide()

            if details.count > 0 {

                for detail in details {
                    self.seriesImagesURL.append(detail.photoURL ?? "")
                }
                
                self.seriesLabelHeight.constant = Constants.VALUE_SECTION_HEIGHT
                self.seriesCollectionViewHeight.constant = Constants.VALUE_COLLECTIONVIEW_HEIGHT

                self.seriesCollectionView.reloadData()
            }
        }
        
        CharactersAPIConnection.getEvents(character: character) { (details, error) in
            HUD.hide()

            if details.count > 0 {

                for detail in details {
                    self.eventsImagesURL.append(detail.photoURL ?? "")
                }

                self.eventsLabelHeight.constant = Constants.VALUE_SECTION_HEIGHT
                self.eventsCollectionViewHeight.constant = Constants.VALUE_COLLECTIONVIEW_HEIGHT

                self.eventsCollectionView.reloadData()
            }
        }
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        character.favorite = !character.favorite
        CoreDataManager.save()

        favoriteButton.image = character.favorite ? #imageLiteral(resourceName: "star-favorite") : #imageLiteral(resourceName: "star-nofavorite")
    }

}

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case Constants.COMICS: return comicsImagesURL.count
        case Constants.SERIES: return seriesImagesURL.count
        case Constants.EVENTS: return eventsImagesURL.count
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var imageURL: String = ""
        switch collectionView.tag {
        case Constants.COMICS: imageURL = comicsImagesURL[indexPath.row]
        case Constants.SERIES: imageURL = seriesImagesURL[indexPath.row]
        case Constants.EVENTS: imageURL = eventsImagesURL[indexPath.row]
        default: break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterDetailCollectionViewCell.self), for: indexPath) as! CharacterDetailCollectionViewCell
        cell.photoImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))

        return cell
    }

}

class CharacterDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
}
