//
//  CharacterCoreDataManager.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 05/05/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import CoreData

class CharacterCoreDataManager: NSObject {

    class func fetch(id: Int) -> Character? {
        let managedObjectContext = CoreDataManager.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Character", in: managedObjectContext)
        let fetchRequest =  NSFetchRequest<Character>(entityName: "Character")
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        
        do {
            var character = try managedObjectContext.fetch(fetchRequest)
            
            if character.count > 0 {
                return character[0]
            }
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }

}
