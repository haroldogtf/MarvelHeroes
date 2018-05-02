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

    class func getCharacters(offset: Int) {

        let apikey = "ecb64ae319c4b6027bf0adb6efba4fe0"
        let privatekey = "832cf4a6aa8afa1e4e8c389f7bccb96abffa3061"
        let ts = Date().timeIntervalSince1970.description
        let hash = Util.cryptoToMD5("\(ts)\(privatekey)\(apikey)")
        
        let parameters: Parameters = [
            "apikey": apikey,
            "ts": ts,
            "hash": hash,
            "offset": offset
        ]
        
        let url =  "https://gateway.marvel.com:443/v1/public/characters"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseObject { (response: DataResponse<CharactersResponse>) in
            
            if let characters = response.result.value?.results {
                for character in characters {
                    print(character.name ?? "")
                }
            }
        }
    }

}

class CharactersResponse: Mappable {

    var code: Int?
    var status: String?
    var results: [Character]?

    required init?(map: Map) { }

    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        results <- map["data.results"]
    }

}

class Character: Mappable {

    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["name"]
    }

}
