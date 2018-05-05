//
//  Character.swift
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
    var results: [Character]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        total <- map["data.total"]
        results <- map["data.results"]
    }
    
}

@objc(Character)
class Character: NSManagedObject, Mappable {
    
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var photoURL: String?

    private var photoPath: String?
    private var photoExtension: String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: CoreDataManager.managedObjectContext)
    }
    
    required init?(map: Map) {
        let ctx = CoreDataManager.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Character", in: ctx)
        super.init(entity: entity!, insertInto: ctx)
        
        mapping(map: map)
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        photoPath <- map["thumbnail.path"]
        photoExtension <- map["thumbnail.extension"]
        
        photoURL = (photoPath ?? "") + "." + (photoExtension ?? "")
    }

}
