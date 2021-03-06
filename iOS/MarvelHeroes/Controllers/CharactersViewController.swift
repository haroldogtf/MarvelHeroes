//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import AZCollectionViewController
import Reachability
import SDWebImage
import UIKit

class CharactersViewController: AZCollectionViewController {

    @IBOutlet weak var tabBar: UITabBar!

    let searchController = UISearchController(searchResultsController: nil)
    
    let reachability = Reachability()!

    var characters: [Character] = []
    var lastIndex = 0
    
    var hasInternetConnection = false

    override func viewDidLoad() {
        super.viewDidLoad()

        loadNewtworkNotification()
        setupCollectionView()
        setupTabBar()
        setupSearch()
        
        fetchData()
    }
    
    deinit {
        unloadNewtworkNotification()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
    }

    func loadNewtworkNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    func unloadNewtworkNotification() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi, .cellular:
            hasInternetConnection = true
            fetchNextData()
        
        case .none:
            hasInternetConnection = false

        }
    }
    
    func setupCollectionView() {
        loadNextPageLoaderCell(nibName: Constants.INDENTIFIER_NEXT_PAGE_LOADER_CELL,
                        cellIdentifier: Constants.INDENTIFIER_NEXT_PAGE_LOADER_CELL)
    }

    func setupTabBar() {
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
    }

    func setupSearch() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.STRING_SEARCH
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func getCharacters() {
        
        characters = CharacterCoreDataManager.fetchAll()

        if characters.count > 0 {
            didfetchData(resultCount: characters.count, haveMoreData: true)
            return
        }
        
        CharactersAPIConnection.getCharacters() { (characters, error) in
            self.characters.removeAll()
            self.characters.append(contentsOf: characters)
            self.didfetchData(resultCount: characters.count, haveMoreData: true)
            
            if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }
    
    func getFavoritesCharacters() {
        self.characters.removeAll()
        self.characters.append(contentsOf: CharacterCoreDataManager.fetchAllFavorites())
        self.didfetchData(resultCount: characters.count, haveMoreData: false)
    }
    
    func getCharactersSearch() {
        CharactersAPIConnection.getCharacters(searchText: searchController.searchBar.text!) { (characters, error) in
            self.characters.removeAll()
            self.characters.append(contentsOf: characters)
            self.didfetchData(resultCount: characters.count, haveMoreData: false)
            
            if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! CharacterDetailViewController
        detail.character = (sender as? Character)
    }

}

extension CharactersViewController {
    
    override func AZCollectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCollectionViewCell.self), for: indexPath) as! CharacterCollectionViewCell
        cell.fill(character: characters[indexPath.row])

        return cell
    }
    
    override func AZCollectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth: CGFloat = 170.0
        
        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsetsMake(10, edgeInsets - 5, 0, edgeInsets - 5)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hasInternetConnection {
            performSegue(withIdentifier: String(describing: CharacterDetailViewController.self), sender: characters[indexPath.row])
        
        } else {
            let alert = UIAlertController(title: Constants.STRING_ERROR_TITLE, message: Constants.STRING_NO_INTERNET_CONNECTION, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: Constants.STRING_OK, style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}

extension CharactersViewController {
    
    override func fetchData() {
        super.fetchData()

        if searchController.searchBar.text == "" {
            switch tabBar.items?.index(of: tabBar.selectedItem!) {
            case 0: getCharacters()
            case 1: getFavoritesCharacters()
            default: break
            }
        } else {
            tabBar.selectedItem = tabBar.items?.first
            getCharactersSearch()
        }
        
        collectionView?.reloadData()
    }

    override func fetchNextData() {
        super.fetchNextData()

        CharactersAPIConnection.getCharacters(offset: characters.count, searchText: searchController.searchBar.text!) { (total, characters, error) in
            
            if self.tabBar.items?.index(of: self.tabBar.selectedItem!) == 0 {
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
    
}

extension CharactersViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        searchController.searchBar.text = ""
        fetchData()
        collectionView?.reloadData()
    }
    
}

extension CharactersViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetchData()
    }

}

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var character: Character?

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
        self.character = character
        
        photoImageView.sd_setImage(with: URL(string: character.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-heroes"))
        nameLabel.text = character.name
        favoriteButton.setImage(character.favorite ? #imageLiteral(resourceName: "star-favorite") : #imageLiteral(resourceName: "star-nofavorite"), for: .normal)
    }

    @IBAction func favoriteAction(_ sender: UIButton) {
        if let character = character {
            character.favorite = !character.favorite
            CoreDataManager.save()

            sender.setImage(character.favorite ? #imageLiteral(resourceName: "star-favorite") : #imageLiteral(resourceName: "star-nofavorite"), for: .normal)            
        }
    }
    
}
