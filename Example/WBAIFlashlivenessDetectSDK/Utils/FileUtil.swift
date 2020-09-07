//
//  FileUtil.swift
//  Pods-webank_ai_sdk
//
//  Created by zhijunchen on 2020/5/18.
//

import Foundation
public class FileUtil{
    public static func  readFile2Base64(path:String)->String?{
        
        //获取文件路径
        //        let file = Bundle.main.path(forResource: "Demo", ofType: "xml")
        LogUtil.i("path11 ="+path)
        let url = URL(fileURLWithPath: path)
        //获取文件内容
        let data = try? Data(contentsOf: url)
        //LogUtil.myPrint(String(data:xmlData, encoding:String.Encoding.utf8))
        if data == nil {
            NSLog("读取文件失败！")
            return nil
        }
        return data?.base64EncodedString()
        
        
    }
    private static func getPath()->String{
        
        let htmlBundlePath = Bundle.main.path(forResource:"resource", ofType:"bundle")
        let htmlBundle = Bundle.init(path: htmlBundlePath!)
        //        let path = htmlBundle.path(forResource:"audio_regist", ofType:"wav", inDirectory:"audio")
        let path = htmlBundle?.path(forResource: "audio_regist", ofType: "wav", inDirectory: "audio")
        LogUtil.i("path22="+path!)
        //        var result =  readFile2Base64(path: path!) ?? "nil"
        //         LogUtil.myPrint("result="+result)
        //        recoder_manager.play(file_path: path!)
        return path!
    }
}
