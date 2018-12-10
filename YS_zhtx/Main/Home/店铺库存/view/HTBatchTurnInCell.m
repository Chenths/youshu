//
//  HTBatchTurnInCell.m
//  有术
//
//  Created by mac on 2018/3/9.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTCahargeProductModel.h"
#import "HTBatchTurnInCell.h"
@interface HTBatchTurnInCell()

@property (weak, nonatomic) IBOutlet UIImageView *prudocutImg;

@property (weak, nonatomic) IBOutlet UILabel *producNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorAndSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UITextField *turnInNumsLabel;

@end


@implementation HTBatchTurnInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.turnInNumsLabel.layer.masksToBounds = YES;
    self.turnInNumsLabel.layer.cornerRadius = 3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.turnInNumsLabel];
    // Initialization code
}

- (void)setModel:(HTCahargeProductModel *)model{
    _model = model;
    HTChargeProductInfoModel * productmodel = model.selectedModel;
    self.producNameLabel.text = productmodel.customtype;
    self.colorAndSizeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%@ %@/%@",productmodel.color,productmodel.size,productmodel.sizecode]];
    NSString *season = productmodel.season;
    [self.prudocutImg sd_setImageWithURL:[NSURL URLWithString:productmodel.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.descLabel.text = [NSString stringWithFormat:@"款号 %@；年份 %@；季节 %@",productmodel.stylecode,productmodel.year,season];
}
-(void)textfieldTextDidChange:(NSNotification*) notice{
    if (notice.object == self.turnInNumsLabel) {
        self.model.turnInNums = self.turnInNumsLabel.text;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.turnInNumsLabel];
}
@end
