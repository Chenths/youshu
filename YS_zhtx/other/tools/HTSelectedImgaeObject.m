//
//  HTSelectedImgaeObject.m
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "DNImagePickerController.h"
#import "HTSelectedImgaeObject.h"
#import "DNAsset.h"
#import "MJPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LPActionSheet.h"
@interface HTSelectedImgaeObject()<DNImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HTSelectedImgaeObject

-(void )showSelectedImgWithController{
    
    [LPActionSheet showActionSheetWithTitle:@"选择图片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"本地相册"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])///<检测该设备是否支持拍摄
            {
                //[Tools showAlertView:@"sorry, 该设备不支持拍摄"];///<显示提示不支持
                [MBProgressHUD showError:@"该设备不支持拍摄"];
                return;
            }
            UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
            picker.navigationBar.translucent = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;///<设置数据来源为拍照
            picker.allowsEditing = YES;
            picker.delegate = self;///<代理设置
            [[HTShareClass shareClass].getCurrentNavController presentViewController:picker animated:YES completion:nil];///<推出视图控制器
        }
        if (index == 2) {
            DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
            imagePicker.imagePickerDelegate = self;
            imagePicker.navigationBar.translucent = NO;
            [HTShareClass shareClass].seltedPhotosCount = 9 ;
            [[HTShareClass shareClass].getCurrentNavController presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
}
- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
       NSMutableArray *imgArray =   [NSMutableArray array];
        for (ALAsset *asset in imageAssets) {
            UIImage *image;
            if (fullImage) {
                NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
                UIImageOrientation orientation = UIImageOrientationUp;
                if (orientationValue != nil) {
                    orientation = [orientationValue intValue];
                }
                image = [UIImage imageWithCGImage:asset.thumbnail];
            } else {
                image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }
            [imgArray addObject:image];
        }
    if (self.selectedImgs) {
        self.selectedImgs(imgArray);
    }
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 相册/相机回调  显示所有的照片，或者拍照选取的照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    //获取编辑之后的图片
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.selectedImgs) {
        self.selectedImgs(@[image]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//  取消选择 返回当前试图
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];    
}


@end
