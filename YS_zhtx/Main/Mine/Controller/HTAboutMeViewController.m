//
//  HTAboutMeViewController.m
//  有术
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTAboutMeViewController.h"

@interface HTAboutMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *androidImage;
@property (weak, nonatomic) IBOutlet UIImageView *iosImage;

@end

@implementation HTAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)  weakSelf = self;
    
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/load_android_version.html"] params:nil success:^(id json) {
        __strong typeof(weakSelf)  strongSelf = weakSelf;
        NSString *downUrl = [[json getDictionArrayWithKey:@"data"] getStringWithKey:@"downUrl"];
        strongSelf.androidImage.image =  [self createImageBgImage:[self createCodeImageWithValue:downUrl] withSmallImage:[UIImage imageNamed:@"ic_launcher"]];
        
    } error:^{
        
    } failure:^(NSError *error) {
        
    }];
    self.iosImage.image = [self createImageBgImage:[self createCodeImageWithValue:@"https://itunes.apple.com/us/app/24xiao-zhu-shou/id1100109709?l=zh&ls=1&mt=8"] withSmallImage:[UIImage imageNamed:@"apple.jpg"]] ;

}

/**
 *  生成二维码
 *
 *  @param value 二维码图片中包含信息
 *
 *  @return 二维码图片
 */
- (UIImage *)createCodeImageWithValue:(NSString *) value{
    //    创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    还原滤镜的默认属性
    [filter setDefaults];
    //    设置需要生成二维码的数据
    [filter setValue:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //    从滤镜中取出生成好的图片
    //合成图片
    //    从滤镜中取出生成好的图片
    CIImage *ciImage = [filter outputImage];
    
    UIImage *newImage = [self createNonInterpolatedUIImageFormCIImage:ciImage WithSize:300] ;
    return newImage;
}
/**
 *  根据ciimage生成高清图片
 *
 *  @param image 不清晰的二维码图片
 *  @param size  图片大小
 *
 *  @return 高清二维码图片
 */
- (UIImage *) createNonInterpolatedUIImageFormCIImage:(CIImage *) image WithSize:(CGFloat ) size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //    创建bitmap
    CGFloat width  = CGRectGetWidth(extent) *scale;
    CGFloat height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef sc = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, sc, 0);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    return  [UIImage  imageWithCGImage:scaleImage];
}

// 创建带阿里图标的二维码
- (UIImage *) createImageBgImage :(UIImage *) bgImg withSmallImage:(UIImage *) smallImage{
    //开启图文上下文
    UIGraphicsBeginImageContext(bgImg.size);
    //绘制背景图片
    [bgImg drawInRect:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height)];
    //绘制头像
    CGFloat width  = 65;
    CGFloat height = width;
    CGFloat x = (bgImg.size.width - width) * 0.5;
    CGFloat y = (bgImg.size.height - width) * 0.5;
    [smallImage drawInRect:CGRectMake(x, y, width, height)];
    //取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图文上下文呢
    UIGraphicsEndImageContext();
    return newImage;
}

@end
