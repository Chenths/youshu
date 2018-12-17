//
//  HTBossMultitermSingleDataCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossMultitermSingleDataCell.h"
@interface HTBossMultitermSingleDataCell()

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *value2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *value3;


@end
@implementation HTBossMultitermSingleDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HTBossMulitSingleCompareModel *)model{
    _model = model;
    self.title1.text = [NSString stringWithFormat:@"%@:", [HTHoldNullObj getValueWithUnCheakValue:model.title]];
    self.title2.text =  [NSString stringWithFormat:@"%@:",[HTHoldNullObj getValueWithUnCheakValue:model.title]];
    self.title3.text =  [NSString stringWithFormat:@"%@:",[HTHoldNullObj getValueWithUnCheakValue:model.title]];
    NSMutableArray *values = [NSMutableArray array];
    NSArray *titles = @[self.value1,self.value2,self.value3];
        for (int i = 0; i < model.valueArr.count; i++) {
            UILabel *label = titles[i];
            NSDictionary *dic = model.valueArr[i];
            if ([[dic getStringWithKey:model.valueKey] length] == 0 ) {
                label.text = @"无数据";
            }else{
            label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1,[dic getStringWithKey:model.valueKey],model.suffix1];
        }
            [values addObject:[dic getStringWithKey:model.valueKey]];
        }
    NSString*max = [values valueForKeyPath:@"@max.floatValue"];
    NSString *min = [values valueForKeyPath:@"@min.floatValue"];
    if (model.valueArr.count < 3) {
        self.value3.hidden = YES;
        self.title3.hidden = YES;
    }
    if (max.floatValue == min.floatValue) {
        self.title1.textColor = [UIColor colorWithHexString:@"222222"];
        self.title2.textColor = [UIColor colorWithHexString:@"222222"];
        self.title3.textColor = [UIColor colorWithHexString:@"222222"];
        return;
    }
    for (int i = 0 ; i < values.count; i++) {
         UILabel *label = titles[i];
        NSString *value = values[i];
        if (value.floatValue == max.floatValue) {
            label.textColor =  [UIColor colorWithHexString:@"#FC5C7D"];
        }else if (value.floatValue == min.floatValue){
            label.textColor =  [UIColor colorWithHexString:@"#59B4A5"];
        }else{
             label.textColor = [UIColor colorWithHexString:@"#222222"];
        }
    }
 
}

@end
