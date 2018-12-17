//
//  HTBossSaleBasicContrastCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossSaleBasicContrastCell.h"
@interface HTBossSaleBasicContrastCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;



@end
@implementation HTBossSaleBasicContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HTBossSaleBasicCompareModel *)model{
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    NSMutableArray *valueArr = [NSMutableArray array];
    for (int i = 0; i < model.valueArr.count; i++) {
        NSDictionary *dic =model.valueArr[i];
        [valueArr addObject:[dic getStringWithKey:model.valueKey]];
    }
    NSString*max = [valueArr valueForKeyPath:@"@max.floatValue"];
    NSString *min = [valueArr valueForKeyPath:@"@min.floatValue"];
    NSString *value1  = [valueArr firstObject];
    NSString *value2  = valueArr[1];
    NSString *value3  = valueArr.count < 3 ? @"" : valueArr[2];
    if (value1.floatValue == max.floatValue) {
        self.value1Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value1,model.suffix1];
        self.value1Label.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }else if (value1.floatValue == min.floatValue){
        self.value1Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value1,model.suffix1];
        self.value1Label.textColor = [UIColor colorWithHexString:@"#59B4A5"];
    }else{
         self.value1Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value1,model.suffix1];
        self.value1Label.textColor = [UIColor colorWithHexString:@"#222222"];
    }

    if (value2.floatValue == max.floatValue) {
         self.value2Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value2,model.suffix1];
        self.value2Label.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }else if (value2.floatValue == min.floatValue){
         self.value2Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value2,model.suffix1];
        self.value2Label.textColor = [UIColor colorWithHexString:@"#59B4A5"];
    }else{
         self.value2Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value2,model.suffix1];
        self.value2Label.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    if (valueArr.count < 3) {
        self.value3Label.hidden = YES;
    }
    if (value3.floatValue == max.floatValue) {
         self.value3Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value3,model.suffix1];
        self.value3Label.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }else if (value3.floatValue == min.floatValue){
        self.value3Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value3,model.suffix1];
        self.value3Label.textColor = [UIColor colorWithHexString:@"#59B4A5"];
    }else{
        self.value3Label.text = [NSString stringWithFormat:@"%@%@%@",model.prefix1, value3,model.suffix1];
        self.value3Label.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    
}

@end
