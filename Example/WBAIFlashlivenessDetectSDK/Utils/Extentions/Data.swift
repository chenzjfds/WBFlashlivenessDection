//
//  Data.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/18.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
import CommonCrypto
//data hexstr互转
extension Data: WBAIHashable {
    public init(_ hex: String) {
        self.init(bytes: Array<UInt8>(hex: hex))
    }
    
    public var bytes: Array<UInt8> {
        return Array(self)
    }
    public func toHexString() -> String {
        return bytes.toHexString()
    }
    
    public func digest(_ algorithm: Algorithm) -> Data {
        return digest(algorithm, key: Optional<Data>.none)
    }
    
    public func digest(_ algorithm: Algorithm, key: String?) -> Data {
        return digest(algorithm, key: key?.data(using: .utf8))
    }
    
    public func digest(_ algorithm: Algorithm, key: Data?) -> Data {
        let count = self.count
        let digestLen = algorithm.digestLength
        
        return self.withUnsafeBytes { bytes -> Data in
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            defer {
                result.deallocate()
            }
            
            if let key = key {
                key.withUnsafeBytes { body in
                    CCHmac(algorithm.hmacAlgorithm, body.baseAddress, key.count, bytes.baseAddress, count, result)
                }
            } else if let address = bytes.baseAddress {
                _ = algorithm.digestAlgorithm(address, CC_LONG(count), result)
            } else {
                fatalError("Invalid bytes base address")
            }
            
            return Data(bytes: result, count: digestLen)
        }
    }
}
