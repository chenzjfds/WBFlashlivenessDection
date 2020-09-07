//
//  LogUtil.swift
//  Pods-webank_ai_sdk
//
//  Created by zhijunchen on 2020/5/18.
//

import Foundation
import CommonCrypto
public class  LogUtil{
    private init() {
       
    }
    static var mDebug=true
    public  static func  setDebug(_ debug: Bool){
        
        LogUtil.mDebug=debug
    }
    public  static func  i(_ items: Any..., separator: String = " ", terminator: String = "\n"){
        if mDebug{
            print(items,separator:separator,terminator:terminator)
        }
    }
    public  static func  d(_ items: Any..., separator: String = " ", terminator: String = "\n"){
           if mDebug{
               print(items,separator:separator,terminator:terminator)
           }
       }
}
