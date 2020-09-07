//
//  Hashable.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/19.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
 protocol WBAIHashable {
    associatedtype Hash
    func digest(_ algorithm: Algorithm, key: String?) -> Hash
    
    var md5: Hash { get }
    var sha1: Hash { get }
    var sha224: Hash { get }
    var sha256: Hash { get }
    var sha384: Hash { get }
    var sha512: Hash { get }
}
 extension WBAIHashable {
    
     var md5: Hash {
        return digest(.md5, key: nil)
    }
    
     var sha1: Hash {
        return digest(.sha1, key: nil)
    }
    
     var sha224: Hash {
        return digest(.sha224, key: nil)
    }
    
     var sha256: Hash {
        return digest(.sha256, key: nil)
    }
    
     var sha384: Hash {
        return digest(.sha384, key: nil)
    }
    
     var sha512: Hash {
        return digest(.sha512, key: nil)
    }
    
}
