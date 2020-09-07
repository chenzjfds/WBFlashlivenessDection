//
//  NSObject+Test.h
//  Camera
//
//  Created by zhijunchen on 2020/6/3.
//  Copyright © 2020 Rizwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FaceModelManager.h"
#import <AVFoundation/AVFoundation.h>

//#import "FlashLiveDetect-Swift.h"

//#import <Flash>
//#import <Flash>
NS_ASSUME_NONNULL_BEGIN
@interface WeUtils:NSObject
{
    
};
+ (unsigned char*)getBaseAddres:(CMSampleBufferRef) sameleBuffer;
@end
@interface FaceStatus:NSObject
{
  float testA;
};
@property  bool success;
@property  float score;
@property  int* bbox;  // (x1, y1, x2, y2)
@property  int face_width;
@property  int face_height;
@property  float* xy5Points;
@property   float* landmarks;
@property  int traceId;  // 追踪到人脸的 trace id，从1开始, 也表示不同人脸的总数, detect 模式下，为 -1;
@property  int frameId;  // 追踪到人脸的 frame id，从1开始, 也表示同一人脸出现的帧数, detect 模式下，为 -1;
@property  int remainNum;  // 表示人脸在视频内的持续帧数, 包括检测帧, 跟踪帧和跟踪丢失帧，从1开始, detect 模式下，为 -1;
@property  float* pointsVis;
@property  int pitch;  // 人脸绕 x 轴角度
@property  int yaw;  // 人脸绕 y 轴角度
@property  int roll;  // 人脸绕 z 轴角度
@property  NSString* imageBase64;  // 人脸绕 z 轴角度
- (void)test;
@end
@protocol FaceModelDelegate <NSObject>
@required
- (void)callback:(NSString*) action:(bool) result :(NSString*) msg;
- (void)callbackMaxScoreImage:(UIImage*) image;
@end





@interface FaceModelManager:NSObject
// webankface::WBFaceDetectParam
@property(nonatomic,weak) id<FaceModelDelegate> delegate;
- (void)initModels;
- (void)releaseModel;
//FACE-TRACKER
- (void)liveDection:(CMSampleBufferRef) sameleBuffer:(NSString*) action:(int) orientation;

//NORMAL
- (NSString*)version;
//FACE-LIVE-ACTION
- (void)TrackYUV:(CMSampleBufferRef) sameleBuffer:(int) orientation:(FaceStatus*)rFace;
- (float)EvaluateYUV:(FaceStatus*) face:(CMSampleBufferRef) sameleBuffer:(int) orientation;
- (int)Blink:(bool) has_face:(int*) face_bbox:(float*)face_landmarks;
- (int)Mouth:(bool) has_face:(int*) face_bbox:(float*)face_landmarks;
- (int)Shake:(bool) has_face:(int)yaw;
- (int)Nod:(bool) has_face:(int)pitch;
- (int)Reset:(NSString*) mode;
-  (float)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
//util
//-(NSString*)  image2Base6:(UIImage*) image:(CGFloat) quality;
@end


NS_ASSUME_NONNULL_END
