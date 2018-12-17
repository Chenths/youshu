//
//  HTTagDescAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import <KLCPopup.h>
#import "HTTagDescAlertView.h"
@interface HTTagDescAlertView()

@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
@implementation HTTagDescAlertView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.alertView changeCornerRadiusWithRadius:3];
    self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@", @"1.对VIP用户贴标签时，标签长度不得超过10个英文字母、数字或5个汉字",@"2.尽可能不要重复贴标签，如贴了漂亮标签，又出现了美丽，好看等标签。",@"3.当输入标签后点击确定后，下方会出现您可能想贴的标签列表，如输入帅，则可能出现好看，很帅等标签。尽量选择下方出现的且和输入标签意思近似的标签进行添加，谢谢配合！"];
}
+(void)showTagDescAlert{
    
    HTTagDescAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTTagDescAlertView" owner:nil options:nil].lastObject;
    alert.frame = CGRectMake(16, HEIGHT - 320, HMSCREENWIDTH - 32, 320);
    alert.backgroundColor = [UIColor clearColor];
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [pop show];
}
- (IBAction)dismissClicked:(id)sender {
    [KLCPopup dismissAllPopups];
}

@end
