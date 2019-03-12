//
//  HTCustomDefualAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomDefualAlertView.h"

@interface HTCustomDefualAlertView(){
    KLCPopup *pop;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) okBtClick  okBtClicked;

@property (nonatomic,copy) cancleBtClick cancleClicked;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (weak, nonatomic) IBOutlet UIButton *singleOkBt;



@end

@implementation HTCustomDefualAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:3];
    [self.singleOkBt changeCornerRadiusWithRadius:3];
    
}

-(instancetype)initAlertWithTitle:(NSString *)title btsArray:(NSArray *)btTitles okBtclicked:(okBtClick) ok cancelClicked:(cancleBtClick) cancel  {
    self = [[NSBundle mainBundle] loadNibNamed:@"HTCustomDefualAlertView" owner:nil options:nil].lastObject;
    [self setFrame:CGRectMake(16,HEIGHT - 160, HMSCREENWIDTH - 32, 160)];
    self.singleOkBt.hidden = YES;
    self.titleLabel.text = title;
    if (btTitles.count >= 2) {
        [self.cancelBt setTitle:[btTitles firstObject] forState:UIControlStateNormal];
        [self.okBt setTitle:btTitles[1] forState:UIControlStateNormal];
    }
    if (ok) {
        self.okBtClicked = ok;
    }
    if (cancel) {
        self.cancleClicked = cancel;
    }
    return self;
}
-(instancetype)initAlertWithTitle:(NSString *)title btTitle:(NSString *)btTitle okBtclicked:(okBtClick)ok{
    self = [[NSBundle mainBundle] loadNibNamed:@"HTCustomDefualAlertView" owner:nil options:nil].lastObject;
    [self setFrame:CGRectMake(16,HEIGHT - 160, HMSCREENWIDTH - 32, 160)];
    self.okBt.hidden = YES;
    self.okBt.enabled = NO;
    self.cancelBt.hidden = YES;
    self.cancelBt.enabled = NO;
    self.titleLabel.text = title;
    [self.singleOkBt setTitle:btTitle forState:UIControlStateNormal];
    if (ok) {
        self.okBtClicked = ok;
    }
    return self;
}
-(void)show{
    pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [pop show];
}
-(void)notTochShow{
    pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}
- (IBAction)cancelBtClicek:(id)sender {
    if (self.cancleClicked) {
      self.cancleClicked();
    }
    [pop dismiss:YES];
}
- (IBAction)okBtClicked:(id)sender {
    self.okBtClicked();
    [pop dismiss:YES];
}
- (IBAction)singleOkBt:(id)sender {
    self.okBtClicked();
    [MBProgressHUD hideHUD];
    [pop dismiss:YES];
}


@end
