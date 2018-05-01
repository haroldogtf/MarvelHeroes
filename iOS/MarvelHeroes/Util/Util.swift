//
//  Util.swift
//  MarvelHeroes
//
//  Created by Haroldo Gondim on 30/04/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import CryptoSwift
import UIKit

class Util: NSObject {

    class func cryptoToMD5(_ string: String) -> String {
        return string.md5()
    }

}
