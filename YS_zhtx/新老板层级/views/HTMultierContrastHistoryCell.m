//
//  HTMultierContrastHistoryCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTMultierContrastHistoryCell.h"
@interface HTMultierContrastHistoryCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;
@property (weak, nonatomic) IBOutlet UIView *valueView1;
@property (weak, nonatomic) IBOutlet UIView *valueView2;
@property (weak, nonatomic) IBOutlet UIView *valueView3;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeigth;


@end
@implementation HTMultierContrastHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTBossCompareDataModel *)model{
    _model = model;
    if (model.companys.length > 0) {
        NSArray *companys = [model.companys ArrayWithJsonString];
        NSArray *titles = @[self.value1Label,self.value2Label,self.value3Label];
        for (int i = 0; i < companys.count; i++) {
            NSDictionary *dic = companys[i];
            UILabel *label = titles[i];
            label.text = [dic getStringWithKey:@"name"].length == 0 ? @" " : [dic getStringWithKey:@"name"] ;
        }
        self.titleLabel.hidden = YES;
        self.titleLabelHeight.constant = 0.0f;
        self.topHeigth.constant = 0;
        if (companys.count < 3) {
            self.value3Label.hidden = YES;
        }else{
            self.value3Label.hidden = NO;
        }
    }
    if (model.date.length > 0) {
        self.titleLabel.hidden = NO;
        self.titleLabelHeight.constant = 20.0f;
        self.topHeigth.constant = 8;
        NSDictionary *dates = [model.date dictionaryWithJsonString];
        NSArray * datesArr = [dates getArrayWithKey:@"date"];
        self.titleLabel.text = [dates getStringWithKey:@"brandName"];
        NSArray *titles = @[self.value1Label,self.value2Label,self.value3Label];
        for (int i = 0; i < datesArr.count; i++) {
            if (i >= titles.count) {
                break;
            }
            UILabel *label = titles[i];
            label.text = [datesArr[i] length] == 0 ? @" " : datesArr[i];
        }
        if (datesArr.count < 3) {
            self.value3Label.hidden = YES;
        }else{
            self.value3Label.hidden = NO;
        }
    }
    if (model.isSelected) {
        self.seletedImg.image = [UIImage imageNamed:@"单选-选中"];
        self.valueView1.hidden = NO;
        self.valueView2.hidden = NO;
        self.valueView3.hidden = NO;
    }else{
        self.seletedImg.image = [UIImage imageNamed:@"单选-未选中"];
        self.valueView1.hidden = YES;
        self.valueView2.hidden = YES;
        self.valueView3.hidden = YES;
    }
}
- (IBAction)deleteClicked:(id)sender {
    
    if (self.delegate) {
        [self.delegate deleteClicked:self];
    }
    
}


@end
