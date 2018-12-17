//
//  HTNewCustomerBaceInfoView.m
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTNewCustomerBaceInfoView.h"
//#import "HTDataCustBasetInfo.h"
//#import "HTCustCustLevel.h"
#import "HTAccount.h"
@interface HTNewCustomerBaceInfoView()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *custLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeSendLabel;
@property (weak, nonatomic) IBOutlet UILabel *dicountLabel;
@property (nonatomic,strong) UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *storedBt;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
@implementation HTNewCustomerBaceInfoView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height/2];
}
+ (instancetype)initInfoViewWithFrame:(CGRect)frame{
    HTNewCustomerBaceInfoView *infoView =  [[[NSBundle mainBundle] loadNibNamed:@"HTNewCustomerBaceInfoView" owner:nil
                                                                        options:nil] lastObject];
    [infoView setFrame:frame];
    infoView.storedBt.layer.cornerRadius = 2;
    infoView.storedBt.layer.borderColor = [UIColor colorWithHexString:@"222222"].CGColor;
    infoView.storedBt.layer.borderWidth = 1;
    infoView.custLevelLabel.layer.borderWidth = 1;
    infoView.custLevelLabel.layer.cornerRadius = 8;
    infoView.custLevelLabel.layer.borderColor = [UIColor colorWithHexString:@"#FDB00B"].CGColor;
    return infoView;
}

+ (instancetype)showAlertViewInView:(UIView *)bigView andDelegate:(id<HTNewCustomerBaceInfoViewDelegate>)delegate withCustData:(HTCustModel *)custData{
    CGRect alrtFrame = CGRectZero;
    alrtFrame = CGRectMake(0,bigView.frame.size.height, bigView.frame.size.width, 310);
    HTNewCustomerBaceInfoView *alrtView = [self initInfoViewWithFrame:alrtFrame];
    alrtView.delegate = delegate;
    alrtView.backgroundColor = [UIColor clearColor];
    //添加遮罩
    [alrtView createCoverViewWithFrame:bigView.bounds];
    [alrtView createViewWithData:custData];
    [bigView addSubview:alrtView.coverView];
    [bigView addSubview:alrtView];
    [UIView animateWithDuration:0.3 animations:^{
        alrtView.frame = CGRectMake(0,(bigView.frame.size.height - 61 - 310), bigView.frame.size.width, 310);
    }];
    return alrtView;
}
- (void)createViewWithData:(HTCustModel *)model{
   
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.nickname];
    self.custLevelLabel.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:model.custlevel].length > 0 ? [HTHoldNullObj getValueWithUnCheakValue:model.custlevel] : @"无"];
    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.phone];
    self.jifenLabel.text = !model.account.integral.balance ? @"0":[NSString stringWithFormat:@"%@",model.account.integral.balance];
    self.storeLabel.text = !model.account.stored.balance ? @"0":[NSString stringWithFormat:@"%@",model.account.stored.balance];

    if ([[HTHoldNullObj getValueWithUnCheakValue:model.isfreestorevalueaccountactive] isEqualToString:@"1"]) {
      self.storeSendLabel.text = !model.account.storedPresented.balance ? @"0":[NSString  stringWithFormat:@"%@",model.account.storedPresented.balance];
    }else{
       self.storeSendLabel.text = @"0";
    }
    self.dicountLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.discount].length == 0 ? @"/" :[NSString stringWithFormat:@"%.0lf折",model.discount.floatValue * 10];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
}
//创建遮罩蒙板
- (void)createCoverViewWithFrame:(CGRect)frame{
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 61)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha  = 0.2;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView)];
    [_coverView addGestureRecognizer:tap];
}
- (void) tapCoverView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAlertViewFromBigView:)]) {
        [_coverView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            self.y = HEIGHT;
        } completion:^(BOOL finished) {
            [self.delegate dismissAlertViewFromBigView:self];
        }];
    }
}

- (IBAction)storedClicked:(id)sender {
    if (self.delegate) {
        [self.delegate stroeMoneyClicked];
    }
}
@end
