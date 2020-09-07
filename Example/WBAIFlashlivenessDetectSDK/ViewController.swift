//
//  ViewController.swift
//  Camera
//
//  Created by Rizwan on 16/06/17.
//  Copyright © 2017 Rizwan. All rights reserved.
//

import UIKit
import AVFoundation
import FlashLiveDetect
let SCORE_MIN = 60.0

let  QINIU_SK="EHL97ue2YsENEjgbu6UJ6RXZqKH9PDfMEWTyPpiy"
let  QINIU_URL="https://face-flashlive.qiniuapi.com/flashlive"
let  QINIU_AK="DW4qi5Li1KnaETy04Z2aBIBcMGZXPahAtG1KyeHW"

class ViewController: UIViewController,FlashLivenessDelegate,FlashLivenessHeaderDelegate{
    //添加七牛云的鉴权header
    func getHeader(_ params: RequestParams) -> [String : String] {
//        var index1 = params.url?.index(after: "aa")
        let url  = URL(string: params.url!)!
        
//        let host = params.url.pre
//        let path  =params.url?.suffix(<#T##maxLength: Int##Int#>) params.url!.firstIndex(of: "/")
        var signingStr:String = params.method  + " " + url.path
        signingStr = signingStr + "\nHost: " + "" + url.host!
        signingStr = signingStr + "\nContent-Type: " + params.header["Content-Type"]!
        signingStr = signingStr + "\n\n"
        signingStr = signingStr + params.body
        let sha1Sign = signingStr.digest2Data(Algorithm.sha1, key: QINIU_SK)
        let base64Sign  = sha1Sign.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
        let accessToken = " Qiniu " + QINIU_AK + ":" + base64Sign
        var result = [String:String]()
        result.updateValue(accessToken, forKey:"Authorization")
        return result
    }
    
    let TAG = "ViewController"
    typealias Callback =  ((_ action:String,_ state:Bool,_ resut:String) -> ())?
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var maskView: UIImageView!
    @IBOutlet weak var colorView: UIImageView!
     @IBOutlet weak var resultView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
     @IBOutlet weak var lightLabel: UILabel!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var  mIsCheck=true
    var index=0
    var save=true;
    var mAgent:FlashLivenessDetection?
    var startTime:Int64 = 0
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var initBtn: UIButton!
    @IBOutlet weak var releaseBtn: UIButton!
    func onDetectStart() {
        LogUtil.i(TAG,"onDetectStart")
        messageLabel.text="活体检测开始"
    }
    func onGetBrightness(bright: Float) {
        lightLabel.text="光强：" + String(bright)
    }
    func onFaceCheckResult(_ code: Int) {
        LogUtil.i(TAG,"onFaceCheckResult code=",code)
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let endTime = CLongLong(round(timeInterval*1000))
        if(code == CODE_ERROR_1){
            mAgent?.stopDetect()
            messageLabel.text="请点击开始重新体验"
        }else{
            startTime=endTime
        }
        switch code {
        case CODE_ERROR_2:
             messageLabel.text="请保持人脸在框中间"
            break
        case CODE_ERROR_3:
             messageLabel.text="请靠近一点"
            break
        case CODE_ERROR_4:
             messageLabel.text="离远一点"
            break
        case CODE_ERROR_5:
             messageLabel.text="请不要抬头"
            break
        case CODE_ERROR_6:
             messageLabel.text="请不要侧头"
            break
        case CODE_ERROR_7:
             messageLabel.text="请不要低头"
            break
        case CODE_ERROR_8:
             messageLabel.text="请不要遮挡人脸"
            break
        default:
            break
        }
    }
    
    func onLightCheckFault() {
        LogUtil.i(TAG,"onLightCheckFault")
        messageLabel.text="光线太强，请前往较暗环境"
    }
    
    func onPrepareChangeScreenColor() {
        LogUtil.i(TAG,"onPrepareChangeScreenColor")
         messageLabel.text="1.5s后开始检测，请保持正脸不动"
    }
    
    func onStartChangeScreenColor() {
        LogUtil.i(TAG,"onStartChangeScreenColor")
         messageLabel.text="开始反光验证"
    }
    
    func onStopChangeScreenColor() {
        LogUtil.i(TAG,"onStopChangeScreenColor")
         messageLabel.text="屏幕颜色变化停止"
    }
    
    func onSendServer() {
        LogUtil.i(TAG,"onSendServer")
         messageLabel.text="数据发送后台中"
    }
    
    func onDetectResult(score: Double) {
        LogUtil.i(TAG,"onDetectResult score=",score)
        if (score >= SCORE_MIN) {
                       messageLabel.text="得分：" + String(score) + ",活体检测通过"
                   } else {
                       messageLabel.text="得分：" +  String(score) + ",活体检测未通过"
                   }
    }
    
    func onDetectFault(code: Int) {
        LogUtil.i(TAG,"onDetectFault code=",code)
        switch code {
        case CODE_ERROR_10:
             messageLabel.text="网络或服务异常"
            break
            case CODE_ERROR_11:
                messageLabel.text="图片采集失败\n闪光过程中请正脸保持不动"
                break
        default:
            break
        }
    }
    
    var mCGRect:CGRect?;
    override func viewDidLoad() {
        super.viewDidLoad()
        //        startBtn.layer.cornerRadius = startBtn.frame.size.width / 2
        //        startBtn.clipsToBounds = true
        //        messageLabel.text="检测中"
        //        FaceUtil.initModels()
        //        initCamera()
        LogUtil.i(TAG,"frame",previewView.frame)
        LogUtil.i(TAG,"frame",previewView.bounds)
        mAgent=FlashLivenessDetection()
        
        var frame=view.frame
      mCGRect = CGRect(x: 60,y: 90,width: frame.width-120,height: (frame.width-120)*16/9)//相机分辨率是1280 *720 ，32 *18
       
        previewView.frame = mCGRect!
        let cameraConfig=CameraConfig(p:previewView)
        var config = FlashLivenessConfig()
//        config.url = QINIU_URL
        mAgent=FlashLivenessDetection()
        mAgent?.setTestPreviewImageCallback(showView: resultView)
//        mAgent?.setSecureHeaderCreater(self)
        mAgent!.initModel(cameraConfig: cameraConfig,mask: colorView,flashConfig: config)
        versionLabel.text=mAgent?.getVersion()
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        //        videoPreviewLayer?.frame = view.bounds
        //        if let previewLayer = videoPreviewLayer ,(previewLayer.connection?.isVideoOrientationSupported)! {
        //            previewLayer.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation ?? .portrait
        //        }
    }
    
    
    @IBAction func onClickStart(_ sender: Any) {
        mAgent?.startDetect(delegate: self)
    }
    
    @IBAction func onClickStop(_ sender: Any) {
        mAgent?.stopDetect()
    }
    
    @IBAction func onClickInit(_ sender: Any) {
        var frame=view.frame
        
        previewView.frame = mCGRect!
        let cameraConfig=CameraConfig(p:previewView)
        var config = FlashLivenessConfig()
        mAgent=FlashLivenessDetection()
        mAgent!.initModel(cameraConfig: cameraConfig,mask: colorView,flashConfig: config)
        //        maskView.image=UIImage(named: "camerabg")
    }
    
    @IBAction func onClickDestroy(_ sender: Any) {
        mAgent?.releaseModel()
    }
    private func initCamera(){ guard  let captureDevice=AVCaptureDevice.devices(for: AVMediaType.video).filter { $0.position == .front }.first else{
        fatalError("No video device found")
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            //            captureSession?.sessionPreset=AVCaptureSession.Preset.vga640x480
            captureSession?.sessionPreset=AVCaptureSession.Preset.vga640x480//128:72  6:4//3:2
            // Set the input devcie on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            //            let captureMetadataOutput = AVCaptureMetadataOutput()
            //            captureSession?.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            //            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
            
            let out2 = AVCaptureVideoDataOutput()
            //            captureSession.type
            captureSession?.addOutput(out2)
            
            out2.setSampleBufferDelegate(self,  queue: DispatchQueue.main)
            //ios相机只支持nv12格式
            out2.videoSettings=[kCVPixelBufferPixelFormatTypeKey as String:  kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            
            //            videoPreviewLayer?.frame = view.layer.bounds
            //            var size = CGSize(width: 120,height: 160)
            //            var point=CGPoint(x: 0,y: 0)
            //            var rect  = CGRect(origin: point,size: size)
            //             videoPreviewLayer?.frame = rect
            previewView.layer.addSublayer(videoPreviewLayer!)
            //start video capture
            captureSession?.startRunning()
            previewView.frame=view.frame
            videoPreviewLayer?.frame = previewView.frame
            
            LogUtil.i(TAG,"frame",previewView.frame)
            LogUtil.i(TAG,"frame",previewView.bounds)
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
    }
}
extension ViewController:FaceModelDelegate{
    func callback( _ action: String,_ result: Bool, _ msg: String) {
        if(result){
            self.messageLabel!.text="检测通过"
            self.mIsCheck=false
            self.index=self.index+1
            if(self.index>=4){
                self.index=0
            }
        }else if(msg != nil){
            self.messageLabel!.text=msg
        }else{
            self.messageLabel!.text=action
        }
        if(self.mIsCheck){
            self.startBtn!.setTitle("检测中", for: UIControl.State.normal)
        }else{
            self.startBtn!.setTitle("开始检测", for: UIControl.State.normal)
            self.messageLabel!.text="检测通过"
        }
    }
    func callbackMaxScoreImage(_ image: UIImage) {
        imageView.image=image//得分最高的图片
    }
}
extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //        let millisecond = Date().milliStamp
        //        if(mIsCheck){
        //            //            self.index=1
        //            switch self.index {
        //            case 0:
        //                FaceUtil.check(sampleBuffer, FaceUtil.ACTION_NODE, self)
        //                break;
        //            case 1:
        //                FaceUtil.check(sampleBuffer, FaceUtil.ACTION_BLINK, self)
        //                break;
        //            case 2:
        //                FaceUtil.check(sampleBuffer, FaceUtil.ACTION_MOUTH, self)
        //                break;
        //            case 3:
        //                FaceUtil.check(sampleBuffer, FaceUtil.ACTION_SHAKE, self)
        //                break;
        //            default:
        //                FaceUtil.check(sampleBuffer, FaceUtil.ACTION_NODE, self)
        //            }
        //        }
        //        let millisecond2 = Date().milliStamp
        //        print("captureOutput millisecond=",(millisecond2 - millisecond))
    }
    
    
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
