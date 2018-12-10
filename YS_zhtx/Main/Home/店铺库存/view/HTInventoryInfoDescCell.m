//
//  HTBossSaleBasicContrastCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTInventoryInfoDescCell.h"
@interface HTInventoryInfoDescCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
@implementation HTInventoryInfoDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel changeCornerRadiusWithRadius:3];
}

-(void)setModel:(HTPieDataItem *)model{
    _model = model;
    if (self.model.isFirst) {
        self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.value1Label.textColor = [UIColor colorWithHexString:@"#999999"];
        self.value2Label.textColor = [UIColor colorWithHexString:@"#999999"];
        self.value3Label.textColor = [UIColor colorWithHexString:@"#999999"];
        self.value2Label.text = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:model.costPrice]];
        self.value3Label.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:model.finalPrice]];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:model.data]];
    }else{
        self.titleLabel.backgroundColor = model.color;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.value1Label.textColor = [UIColor colorWithHexString:@"#222222"];
        self.value2Label.textColor = [UIColor colorWithHexString:@"#222222"];
        self.value3Label.textColor = [UIColor colorWithHexString:@"#222222"];
        self.value2Label.text = self.isBoss ?  [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithBigDecmalObj:model.costPrice]] : @"****";
        self.value3Label.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalPrice]];
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.data],@"%"];
    }
    
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.value1Label.text = [HTHoldNullObj getValueWithUnCheakValue:model.total];
  
}

@end
