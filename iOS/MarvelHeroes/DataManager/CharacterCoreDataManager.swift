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
    
    class func fetchAll() -> [Character] {
        return fetchAll(predicate: "")
    }
        
    class func fetchAll(predicate: String) -> [Character] {
        let managedObjectContext = CoreDataManager.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Character", in: managedObjectContext)
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: predicate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let array = try managedObjectContext.fetch(fetchRequest) as? [Character]
            return array ?? []
            
        } catch let error as NSError {
            print(error)
        }
        
        return []
    }
    
    class func fetchAllFavorites() -> [Character] {
        return fetchAll(predicate: "favorite == 1")
    }

}
