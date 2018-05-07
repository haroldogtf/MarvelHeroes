//
//  CharactersAPIConnection.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import UIKit

class CharactersAPIConnection: NSObject {
    
    class func authentication() -> Parameters {

        let apikey = Constants.KEY_API
        let privatekey = Constants.KEY_PRIVATE
        let ts = Date().timeIntervalSince1970.description
        let hash = Util.cryptoToMD5("\(ts)\(privatekey)\(apikey)")
        
        let parameters: Parameters = [
            "apikey": apikey,
            "ts": ts,
            "hash": hash,
            ]

        return parameters
    }

    class func getCharacters(completion: @escaping (_ charecters: [Character], _ error: Error?) -> ()) {
        getCharacters(offset: 0) { (total, characters, error) in
            completion(characters, error)
        }
    }
    
    class func getCharacters(searchText: String, completion: @escaping (_ charecters: [Character], _ error: Error?) -> ()) {
        getCharacters(offset: 0, searchText: searchText) { (total, characters, error) in
            completion(characters, error)
        }
    }
    
    class func getCharacters(offset: Int, completion: @escaping (_ total: Int, _ charecters: [Character], _ error: Error?) -> ()) {
        getCharacters(offset: 0, searchText: "") { (total, characters, error) in
            completion(total, characters, error)
        }
    }

    class func getCharacters(offset: Int, searchText: String, completion: @escaping (_ total: Int, _ charecters: [Character], _ error: Error?) -> ()) {

        var parameters = authentication()
        parameters["offset"] = offset
        if !searchText.isEmpty && searchText != "" { parameters["nameStartsWith"] = searchText }

        let url =  "https://gateway.marvel.com:443/v1/public/characters"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseObject { (response: DataResponse<CharactersResponse>) in
            
            if let results = response.result.value?.results {
               
                var characters: [Character] = []
                
                for result in results {
                    let id = result.id ?? 0
                    
                    var character = CharacterCoreDataManager.fetch(id: id)
                    if character == nil {
                        character = Character(context: CoreDataManager.managedObjectContext)
                    }
                  
                    character?.id = Int32(id)
                    character?.name = result.name
                    character?.photoURL = result.photoURL
                    character?.about = result.description_
                    
                    characters.append(character!)
                }
                CoreDataManager.save()

                completion(response.result.value?.total ?? 0, characters, nil)
            
            } else {
                completion(0, [], response.error)
            }
        }
    }
    
    class func getDetail(kind: String, character: Character, completion: @escaping (_ datails: [Detail], _ error: Error?) -> ()) {
        
        let parameters = authentication()

        let url = "https://gateway.marvel.com:443/v1/public/characters/" + String(character.id) + "/" + kind


        Alamofire.request(url, method: .get, parameters: parameters).responseObject { (response: DataResponse<DetailResponse>) in
            
            if let results = response.result.value?.results {
                completion(results, nil)
            } else {
                completion([], response.error)
            }
        }
    }
    
    class func getComics(character: Character, completion: @escaping (_ datails: [Detail], _ error: Error?) -> ()) {
        getDetail(kind: "comics", character: character) { (details, error) in
            completion(details, error)
        }
    }

    class func getSeries(character: Character, completion: @escaping (_ datails: [Detail], _ error: Error?) -> ()) {
        getDetail(kind: "series", character: character) { (details, error) in
            completion(details, error)
        }
    }
    
    class func getStories(character: Character, completion: @escaping (_ datails: [Detail], _ error: Error?) -> ()) {
        getDetail(kind: "stories", character: character) { (details, error) in
            completion(details, error)
        }
    }
    
    class func getEvents(character: Character, completion: @escaping (_ datails: [Detail], _ error: Error?) -> ()) {
        getDetail(kind: "events", character: character) { (details, error) in
            completion(details, error)
        }
    }
}
