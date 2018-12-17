//
//  HTBindWechatController.m
//  有术
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "UIBarButtonItem+Extension.h"
#import "HTBindWechatController.h"
#import "HTLoginDataPersonModel.h"
#import "HTAccountTool.h"

@interface HTBindWechatController ()
@property (nonatomic,assign) BOOL  isBind;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *bingBt;

@end

@implementation HTBindWechatController

#pragma mark -life cycel

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bingBt changeCornerRadiusWithRadius:3];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-back" highImageName:@"g-back" target:self action:@selector(back)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if ([HTAccountTool cheackUnionId]) {
        self.stateImg.image = [UIImage imageNamed:@"wx_binded_img"];
        self.descLabel.text = [NSString stringWithFormat: @"已成功绑定微信:%@",[HTShareClass shareClass].loginModel.person.nickname];
        [self.bingBt setTitle:@"更换绑定微信" forState:UIControlStateNormal];
    }else{
        self.stateImg.image = [UIImage imageNamed:@"wx_unbind_img"];
        [self.bingBt setTitle:@"立即绑定" forState:UIControlStateNormal];
        self.descLabel.text = @"你未绑定微信";
    }
}
- (void)viewDidDisappear:(BOOL)animated {
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma EventResponse
- (IBAction)bingWechatClicked:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state ==  1) {
                
                __block NSString *unionid = [user rawData][@"unionid"];
                __weak typeof(self) weakSelf = self;
                [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middlePerson,bindWechat] params:@{                                                     @"unionId":unionid ,                                  @"nickname":                                                                                                                                                                     user.nickname
                     }success:^(id json) {
                         __strong typeof(weakSelf) strongSelf = weakSelf;
                    
                       [HTAccountTool loginWillEnterForeground:nil Succes:nil];
                        strongSelf.isBind = YES;
                       strongSelf.stateImg.image = [UIImage imageNamed:@"wx_binded_img"];
                       strongSelf.descLabel.text = [NSString stringWithFormat: @"已成功绑定微信:%@",user.nickname];
                      [strongSelf.bingBt setTitle:@"更换绑定微信" forState:UIControlStateNormal];
                         [MBProgressHUD hideHUDForView:strongSelf.view];
                    } error:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [MBProgressHUD hideHUDForView:strongSelf.view];
                    } failure:^(NSError *error) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [MBProgressHUD hideHUDForView:strongSelf.view];
                    }];
            }
        }];
}

#pragma private methods
- (void)back
{
    if ([HTAccountTool cheackUnionId] || self.isBind) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         [MBProgressHUD showError:@"绑定微信为了统计你的网上销售，请绑定微信"];
         [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getters and setters

@end
