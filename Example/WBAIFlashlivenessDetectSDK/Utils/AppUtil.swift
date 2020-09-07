//
//  LogUtil.swift
//  Pods-webank_ai_sdk
//
//  Created by zhijunchen on 2020/5/18.
//

import Foundation
import CommonCrypto
import UIKit
public class  AppUtil{
    private init() {
       
    }
    public  static func  getAppVersion()->String{
        
        let infoDictionary = Bundle.main.infoDictionary
        let appDisplayName:AnyObject = infoDictionary!["CFBundleDisplayName"] as AnyObject //程序名称
        let majorVersion :AnyObject = infoDictionary! ["CFBundleShortVersionString"] as AnyObject//主程序版本号
        let minorVersion :AnyObject = infoDictionary! ["CFBundleVersion"] as AnyObject//版本号（内部标示）
        return minorVersion as! String
       }
    public  static func  getPhoneModel()->String{
          
       
        let deviceName = UIDevice.current.name  //获取设备名称 例如：梓辰的手机
        let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
        let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
        let deviceUUID = UIDevice.current.identifierForVendor?.uuid //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
        let deviceModel = UIDevice.current.model //获取设备的型号 例如：iPhone
//        UIDevice.identifierForVendor?
        
        return UIDevice.current.modelName
         }
}
