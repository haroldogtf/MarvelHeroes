//
//  CharacterMappable.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 02/05/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import CoreData
import ObjectMapper

class CharactersResponse: Mappable {
    
    var code: Int?
    var status: String?
    var total: Int?
    var results: [CharacterMappable]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        total <- map["data.total"]
        results <- map["data.results"]
    }
    
}

class CharacterMappable: Mappable {
    
    var id: Int?
    var name: String?
    var description_: String?
    var photoURL: String?

    private var photoPath: String?
    private var photoExtension: String?
    
    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description_ <- map["description"]
        photoPath <- map["thumbnail.path"]
        photoExtension <- map["thumbnail.extension"]
        
        photoURL = (photoPath ?? "") + "." + (photoExtension ?? "")
    }

}

class Item: Mappable {

    var available: Int?
    var returned: Int?
    var collectionURI: String?
    //var items: [String]?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        available <- map["available"]
        returned <- map["returned"]
        collectionURI <- map["collectionURI"]
        //items <- map["items"]
    }

}
