//
//  String.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/19.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
import CommonCrypto
extension String: WBAIHashable {
    
     func digest(_ algorithm: Algorithm) -> String {
        return digest(algorithm, key: Optional<Data>.none)
    }
    
     func digest(_ algorithm: Algorithm, key: String?) -> String {
        return digest(algorithm, key: key?.data(using: .utf8))
    }
    func digest2Data(_ algorithm: Algorithm, key: String?) -> Data {
        return digest2Data(algorithm, key: key?.data(using: .utf8))
    }
     func digest(_ algorithm: Algorithm, key: Data?) -> String {
        let str = Array(self.utf8CString)
        let strLen = str.count-1
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
        
        if let key = key {
            key.withUnsafeBytes { body in
                CCHmac(algorithm.hmacAlgorithm, body.baseAddress, key.count, str, count, result)
            }
        } else {
            _ = algorithm.digestAlgorithm(str, CC_LONG(strLen), result)
        }
        
        let digest = result.toHexString(count: digestLen)
        let data = Data(Array<UInt8>(hex: digest))
        var result22 = data.toHexString()
        result.deallocate()
        
        return result22
    }
    func digest2Data(_ algorithm: Algorithm, key: Data?) -> Data {
           let str = Array(self.utf8CString)
           let strLen = str.count-1
           let digestLen = algorithm.digestLength
           let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
           
           if let key = key {
               key.withUnsafeBytes { body in
                   CCHmac(algorithm.hmacAlgorithm, body.baseAddress, key.count, str, count, result)
               }
           } else {
               _ = algorithm.digestAlgorithm(str, CC_LONG(strLen), result)
           }
           
           let digest = result.toHexString(count: digestLen)
           let data = Data(Array<UInt8>(hex: digest))
           result.deallocate()
           
           return data
       }
    func sha256(_ key: String?) -> String {
        LogUtil.i("hmac info="+self+"  key="+(key ?? "nil"))
        let hmac = self.digest(.sha256, key: key)
        LogUtil.i("hmac ="+hmac)
        return hmac
    }
    func toBase64() -> String {
        if let data = self.data(using: .utf8) {
//            data.base64EncodedData(options: <#T##Data.Base64EncodingOptions#>)
            return data.base64EncodedString()
        }
        return ""
    }
    
    // base64解码
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
