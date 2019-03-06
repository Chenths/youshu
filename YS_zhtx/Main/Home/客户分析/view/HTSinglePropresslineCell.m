//
//  HTSinglePropresslineCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSinglePropresslineCell.h"
@interface HTSinglePropresslineCell()

@property (weak, nonatomic) IBOutlet UILabel *indexTitle;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *secondProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNumberLabel;

@end
@implementation HTSinglePropresslineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.progressLabel changeCornerRadiusWithRadius:4];
}
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

- (IBAction)topBtnSelect:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectBtnWithIfTopBtn:WithIndexRow:)]) {
        [_delegate selectBtnWithIfTopBtn:YES WithIndexRow:_indexPath.row];
    }
}
- (IBAction)bottomBtnSelect:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectBtnWithIfTopBtn:WithIndexRow:)]) {
        [_delegate selectBtnWithIfTopBtn:NO WithIndexRow:_indexPath.row];
    }
}
#pragma mark -EventResponse

#pragma mark -private methods

#pragma mark - getters and setters
-(void)setModel:(HTHorizontalReportDataModel *)model{
    _model = model;
    self.indexTitle.text = [HTHoldNullObj getValueWithUnCheakValue:model.key];
    self.numberLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.val];
    self.progressLabel.progress = model.val.floatValue / model.max.floatValue;
    self.progressLabel.progressTintColor = model.color;
}

- (void)setSecondModel:(HTHorizontalReportDataModel *)secondModel
{
    _secondModel = secondModel;
    self.secondNumberLabel.text = [HTHoldNullObj getValueWithUnCheakValue:secondModel.val];
    self.secondProgressLabel.progress = secondModel.val.floatValue / secondModel.max.floatValue;
    self.secondProgressLabel.progressTintColor = secondModel.color;
}
@end
