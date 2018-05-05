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

    class func getCharacters(completion: @escaping (_ result: [Character], _ error: Error?) -> ()) {
        getCharacters(offset: 0) { (total, result, error) in
            completion(result, error)
        }
    }

    class func getCharacters(offset: Int, completion: @escaping (_ total: Int, _ result: [Character], _ error: Error?) -> ()) {

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
                CoreDataManager.save()
                completion(response.result.value?.total ?? 0, characters, nil)
            } else {
                completion(0, [], response.error)
            }
        }
    }

}
