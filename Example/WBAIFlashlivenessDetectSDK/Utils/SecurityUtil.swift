//
//  SecurityUtil.swift
//  Pods-webank_ai_sdk
//
//  Created by zhijunchen on 2020/5/18.
//

import Foundation
import CommonCrypto
public class  SecurityUtil{
    
    static    func getMd5(url: URL) -> String? {
        let bufferSize = 1024 * 1024
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            //初始化内容
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
            
            //计算Md5摘要
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &context)
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
            
        } catch {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
        
        
    }
    static func  getmd5(path:String)->String?{
        let handle = FileHandle(forReadingAtPath: path)
        
        if handle == nil {
            return nil
        }
        
        let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: MemoryLayout<CC_MD5_CTX>.size)
        
        CC_MD5_Init(ctx)
        
        var done = false
        
        while !done {
            let fileData = handle?.readData(ofLength: 256)
            
            fileData?.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
                //Use `bytes` inside this closure
                //...
                CC_MD5_Update(ctx, bytes, CC_LONG(fileData!.count))
            }
            
            if fileData?.count == 0 {
                done = true
            }
        }
        
        //unsigned char digest[CC_MD5_DIGEST_LENGTH];
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5_Final(digest, ctx);
        
        var hash = ""
        for i in 0..<digestLen {
            hash +=  String(format: "%02x", (digest[i]))
        }
        
        digest.deinitialize(count: 1)
        ctx.deinitialize(count: 1)
        
        return hash;
    }
    static func getMd5(md5:String)->String {
        let utf8 = md5.cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    func sha256(data:String) -> String{
        if let stringData = data.data(using: .utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    func toBase64(info:String) -> String? {
        if let data = info.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    // base64解码
    func fromBase64(info:String) -> String? {
        if let data = Data(base64Encoded: info) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    //    static func getSHA256(data:String,key:String)->String {
    //        let cKey = key.cString(using: String.Encoding.utf8)
    //        let cData = data.cString(using: String.Encoding.utf8)
    //          var result = [CUnsignedChar](count: Int(algorithm.digestLength()), repeatedValue: 0)
    //          CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
    //          var hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
    //          var hmacBase64 = hmacData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength)
    //          return String(hmacBase64)
    //        }
    //
    //  enum HMACAlgorithm {
    //  case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    //
    //  func toCCHmacAlgorithm() -> CCHmacAlgorithm {
    //      var result: Int = 0
    //      switch self {
    //      case .MD5:
    //          result = kCCHmacAlgMD5
    //      case .SHA1:
    //          result = kCCHmacAlgSHA1
    //      case .SHA224:
    //          result = kCCHmacAlgSHA224
    //      case .SHA256:
    //          result = kCCHmacAlgSHA256
    //      case .SHA384:
    //          result = kCCHmacAlgSHA384
    //      case .SHA512:
    //          result = kCCHmacAlgSHA512
    //      }
    //      return CCHmacAlgorithm(result)
    //  }
    //
    //  func digestLength() -> Int {
    //      var result: CInt = 0
    //      switch self {
    //      case .MD5:
    //          result = CC_MD5_DIGEST_LENGTH
    //      case .SHA1:
    //          result = CC_SHA1_DIGEST_LENGTH
    //      case .SHA224:
    //          result = CC_SHA224_DIGEST_LENGTH
    //      case .SHA256:
    //          result = CC_SHA256_DIGEST_LENGTH
    //      case .SHA384:
    //          result = CC_SHA384_DIGEST_LENGTH
    //      case .SHA512:
    //          result = CC_SHA512_DIGEST_LENGTH
    //      }
    //      return Int(result)
    //  }
    
}
