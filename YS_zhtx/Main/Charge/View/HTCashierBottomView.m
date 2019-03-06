//
//  HTCashierBottomView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTChangeSettleViewController.h"
#import "HTNewCustomerBaceInfoView.h"
#import "HTCashierBottomView.h"
#import "HTHoldCustomerEventManger.h"

@interface HTCashierBottomView()<HTNewCustomerBaceInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) HTNewCustomerBaceInfoView *alertView;

@property (nonatomic,assign) BOOL isShowAlert;



@end
@implementation HTCashierBottomView

- (IBAction)vipBtClicked:(id)sender {
//    if (self.custModel.custId.length > 0) {
//        if (self.isShowAlert) {
//            [self.alertView tapCoverView];
//            self.isShowAlert = NO;
//        }else{
//          self.alertView = [HTNewCustomerBaceInfoView showAlertViewInView:[[UIApplication sharedApplication].delegate window] andDelegate:self withCustData:self.custModel];
//          self.isShowAlert = YES;
//        }
//    }else{
        if (self.delegate) {
            [self.delegate vipBtclicked];
        }
//    }
   
}
- (IBAction)selectSellerChooseBtn:(id)sender {
    if (self.sellerChooseBtn.tag == 8001) {
        if (self.delegate) {
            [self.delegate chooseSellerClicked:(UIButton *)sender];
        }
        self.sellerChooseBtn.tag = 8002;
    }else{
        if (self.delegate) {
            [self.delegate chooseSellerClicked:(UIButton *)sender];
        }
        self.sellerChooseBtn.tag = 8001;
    }
}
- (IBAction)setterClicked:(id)sender {
    if (self.delegate) {
        [self.delegate settlerClicked];
    }

}
-(void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
}
-(void)stroeMoneyClicked{
    [self.alertView tapCoverView];
    [HTHoldCustomerEventManger storedForCustomerWithCustomerPhone:self.custModel.phone WithId:self.custModel.custId];

}

-(void)setCustModel:(HTCustModel *)custModel{
    _custModel = custModel;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:custModel.nickname];
}
-(void)setFinallPrice:(NSString *)finallPrice{
    _finallPrice = finallPrice;
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",finallPrice];
}
-(void)setTotlePrice:(NSString *)totlePrice{
    _totlePrice = totlePrice;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",totlePrice];
}
-(void)setProductNum:(NSString *)productNum{
    _productNum = productNum;
    self.countLabel.text = [NSString stringWithFormat:@"共%@件商品",productNum];
}
@end
