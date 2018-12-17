//
//  HTCompareHeadView.m
//  有术
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTCompareHeadView.h"
@interface HTCompareHeadView()

@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *holdImg;
@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet UILabel *value2;
@property (weak, nonatomic) IBOutlet UILabel *value3;
@property (weak, nonatomic) IBOutlet UIView *lastView;



@end
@implementation HTCompareHeadView

- (instancetype)initWithHeadFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self =  [[NSBundle mainBundle] loadNibNamed:@"HTCompareHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}
- (void)setModel:(HTBossHeadModel *)model{
     _model = model;
    if (model.headType == HTCompareHeadTime) {
          self.holdLabel.text = [NSString stringWithFormat:@"%@",model.selecetedCompany];
        NSArray *values = @[self.value1,self.value2,self.value3];
        for (int i = 0; i < model.dates.count ; i++) {
            UILabel *label = values[i];
            label.text = [HTHoldNullObj getValueWithUnCheakValue: model.dates[i]];
        }
        if (model.dates.count  < 3) {
            self.lastView.hidden = YES;
        }else{
            self.lastView.hidden = NO;
        }
    }
    if (model.headType == HTCompareHeadShop) {
        self.holdLabel.text = [NSString stringWithFormat:@"%@ 至 %@",model.selectedBeginTime,model.selectedEndTime];
      
         NSArray *values = @[self.value1,self.value2,self.value3];
        for (int i = 0; i < model.companys.count ; i++) {
            NSDictionary *dic = model.companys[i];
            UILabel *label = values[i];
            label.text = [dic getStringWithKey:@"name"];
        }
        if (model.companys.count  < 3) {
            self.lastView.hidden = YES;
        }else{
            self.lastView.hidden = NO;
        }
    }
}
- (IBAction)topCliceked:(id)sender {
    if (self.delegate) {
        [self.delegate topClicked];
    }
}
- (IBAction)bottomCliecked:(id)sender {
    if (self.delegate) {
        [self.delegate bottomClicked];
    }
}

@end
