//
//  HTScanTools.h
//  24小助理
//
//  Created by mac on 2016/10/18.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol HTScanCodeDelegate <NSObject>

-(void) handleScanResultStr:(NSString *) result;

@end



@interface HTScanTools : NSObject<AVCaptureMetadataOutputObjectsDelegate>

//拿到会话
@property (nonatomic,strong) AVCaptureSession *session;
//拿到输入设备
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
//
//拿到输出对象
@property (nonatomic,strong) AVCaptureMetadataOutput *outPut;
//预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic,assign) CGRect frame;

@property (nonatomic,assign) CGRect scanframe;

@property (nonatomic,assign) id<HTScanCodeDelegate> delegate;

- (void) startScanInView:(UIView *) bigView;

@end
