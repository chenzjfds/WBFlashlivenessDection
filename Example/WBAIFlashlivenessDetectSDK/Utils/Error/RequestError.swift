//
//  ErrorCode.swift
//  Voiceprintsdk
//
//  Created by zhijunchen on 2020/5/25.
//  Copyright © 2020 webank. All rights reserved.
//

import Foundation
public  class RequestError :NSObject ,Codable {
    public  static let CODE_CONN_ERROR=0  //连接失败
    public  static let CODE_AUTHENTICATION_ERROR=1  //  鉴权失败
    
    public  var code :Int
    public  var msg :String
    init(_ code:Int,_ msg:String) {
        self.code=code
        self.msg=msg
    }
}
