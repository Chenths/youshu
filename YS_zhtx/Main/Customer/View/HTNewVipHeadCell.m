//
//  HTNewVipHeadCell.m
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNewVipHeadCell.h"
//#import "JCHATConversationViewController.h"

@interface HTNewVipHeadCell()

/**
 姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

/**
 电话
 */
@property (weak, nonatomic) IBOutlet UILabel *telLable;
/**
 会员等级
 */
@property (weak, nonatomic) IBOutlet UILabel *custLevelLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headBackImg;


@end

@implementation HTNewVipHeadCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 40;
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidSelected:)];
    [self.headImg addGestureRecognizer:tap];
    self.headBackImg.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0,0,HMSCREENWIDTH, self.height);
    [self.contentView addSubview:effectView];
    [self.contentView insertSubview:effectView aboveSubview:self.headBackImg];
    
}
-(void)setModel:(HTCustomerReprotSaleMsgModel *)model{
    _model = model;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.custLevelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.customertype];
    self.telLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.phone];
    self.sexImg.image = model.sex.boolValue ? [UIImage imageNamed:@"g-man"]:[UIImage imageNamed:@"g-woman"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    if (model.headimg.length > 0) {
        [self.headBackImg sd_setImageWithURL:[NSURL URLWithString:model.headimg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
}

-(void)setOpenid:(NSString *)openid{
    _openid = openid;
    if (openid.length == 0) {
        self.chatBt.hidden = YES;
    }else{
        self.chatBt.hidden = NO;
    }
}
- (void)tapDidSelected:(UITapGestureRecognizer *)sender{
    if (self.headSelected) {
        self.headSelected();
    }
}
- (IBAction)callClicked:(id)sender {
    
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    NSString *phone = [_model.baseMessage getStringWithKey:@"phone"];
//    if (phone.length == 0) {
//        return;
//    }
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [[HTShareClass shareClass].getCurrentNavController.view addSubview:callWebview];
}
- (IBAction)chatClicked:(id)sender {
    
//    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
//    sendMessageCtl.superViewController = self;
//    sendMessageCtl.hidesBottomBarWhenPushed = YES;
//    [MBProgressHUD showMessage:@"请稍等。。。"];
//    [JMSGConversation createSingleConversationWithUsername:self.modelId appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
//        if (error == nil) {
//            [MBProgressHUD hideHUD];
//            sendMessageCtl.conversation = resultObject;
//            sendMessageCtl.modelId = self.modelId;
//            [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
//        } else {
//            //(@"createSingleConversationWithUsername fail");
//            //                    [MBProgressHUD showMessage:@"添加的用户不存在" view:self.view];
//            NSDictionary *dic1 = @{
//                                   @"companyId":[HTShareClass shareClass].loginModel.companyId,
//                                   @"customerId":self.modelId,
//                                   };
//            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"message/regist.html"] params:dic1 success:^(id json) {
//                [MBProgressHUD hideHUD];
//                sendMessageCtl.conversation = resultObject;
//                sendMessageCtl.modelId = self.modelId;
////                sendMessageCtl.chatName = [dic getStringWithKey:@"nickname_cust"];
//                [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
//            } error:^{
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:SeverERRORSTRING];
//            } failure:^(NSError *error) {
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:@"请检查你的网络" ];
//            }];
//        }
//    }];
}



@end
