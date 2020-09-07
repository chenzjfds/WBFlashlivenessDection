//
//  Algorithm.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/19.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
import CommonCrypto
public enum Algorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
   public  var hmacAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:        result = kCCHmacAlgMD5
        case .sha1:        result = kCCHmacAlgSHA1
        case .sha224:    result = kCCHmacAlgSHA224
        case .sha256:    result = kCCHmacAlgSHA256
        case .sha384:    result = kCCHmacAlgSHA384
        case .sha512:    result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
   public  typealias DigestAlgorithm = (UnsafeRawPointer, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>?
    
   public var digestAlgorithm: DigestAlgorithm {
        switch self {
        case .md5:      return CC_MD5
        case .sha1:     return CC_SHA1
        case .sha224:   return CC_SHA224
        case .sha256:   return CC_SHA256
        case .sha384:   return CC_SHA384
        case .sha512:   return CC_SHA512
        }
    }
    
   public  var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .md5:        result = CC_MD5_DIGEST_LENGTH
        case .sha1:        result = CC_SHA1_DIGEST_LENGTH
        case .sha224:    result = CC_SHA224_DIGEST_LENGTH
        case .sha256:    result = CC_SHA256_DIGEST_LENGTH
        case .sha384:    result = CC_SHA384_DIGEST_LENGTH
        case .sha512:    result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
