//
//  UnsafeMutablePointer.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/19.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
extension UnsafeMutablePointer where Pointee == CUnsignedChar {
    
    func toHexString(count: Int) -> String {
        var result = String()
        for i in 0..<count {
            let s = String(self[i], radix: 16)
            if s.count % 2 == 1 {
                result.append("0"+s)
            } else {
                result.append(s)
            }
        }
        return result
    }
    
}
