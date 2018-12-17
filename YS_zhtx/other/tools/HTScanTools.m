//
//  HTScanTools.m
//  24小助理
//
//  Created by mac on 2016/10/18.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTScanTools.h"

@implementation HTScanTools

//创建会话
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _session;
}
//创建输入会话
- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _deviceInput;
}
//创建输出对象
- (AVCaptureMetadataOutput *)outPut{
    
    if (!_outPut) {
        _outPut = [[AVCaptureMetadataOutput alloc] init];
    }
    return _outPut;
    
}
//创建预览图层
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer =  [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    self.previewLayer.frame = frame;
}
/**
 *  开始扫描
 */
- (void) startScanInView:(UIView *) bigView{
    // 1.判断是否能够将输入添加到会话中
    if (![self.session canAddInput:self.deviceInput])  {
        return;
    }
    if (![self.session canAddOutput:self.outPut]) {
        return;
    }
    //    将输入和输出都添加到会话
    [self.session addInput:self.deviceInput];
    [self.session addOutput:self.outPut];
    //    设置输出能够解析的数据类型

    self.outPut.metadataObjectTypes = [self.outPut availableMetadataObjectTypes];
    //   设置输出对象的代理，只要解析成功就会通知代理
    [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    [self.previewLayer   setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//
    [bigView.layer addSublayer:self.previewLayer];
    [self.session startRunning];
    
}
#pragma mark -扫描二维码回调

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //    获得扫描到的数据
    //    给网络这边
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        if ([[[metadataObjects objectAtIndex:0] class] isSubclassOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *str = [[metadataObjects lastObject] stringValue];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleScanResultStr:)]) {
                [self.delegate handleScanResultStr:str];
            }
        }
    
    }
    
}




@end
