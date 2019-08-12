//
//  HTNewPayYHQHeaderView.m
//  YS_zhtx
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTNewPayYHQHeaderView.h"

@implementation HTNewPayYHQHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)leftTouch:(id)sender {
    NSLog(@"点击左上按钮");
    if (_delegate) {
        if (_selectType == 1) {
            [self.delegate selectHeaderViewWithTag:0];
        }else{
            [self.delegate selectHeaderViewWithTag:1];
        }
    }
}
- (IBAction)rightTouch:(id)sender {
    NSLog(@"点击右上按钮");
    if (_delegate) {
        if (_selectType == 2) {
            [self.delegate selectHeaderViewWithTag:0];
        }else{
            [self.delegate selectHeaderViewWithTag:2];
        }
    }
}
- (void)setSelectType:(NSInteger)selectType{
    _selectType = selectType;
    if (_selectType == 0) {
        _leftLabel.textColor = [UIColor colorWithHexString:@"#949494"];
        _leftImv.image = [UIImage imageNamed:@"grayDown"];
        
        _rightLabel.textColor = [UIColor colorWithHexString:@"#949494"];
        _rightImv.image = [UIImage imageNamed:@"grayDown"];
        
    }else if (_selectType == 1){
        _leftLabel.textColor = [UIColor colorWithHexString:@"#2E2E2E"];
        _leftImv.image = [UIImage imageNamed:@"darkDown"];
        
        _rightLabel.textColor = [UIColor colorWithHexString:@"#949494"];
        _rightImv.image = [UIImage imageNamed:@"grayDown"];
    }else{
        _leftLabel.textColor = [UIColor colorWithHexString:@"#949494"];
        _leftImv.image = [UIImage imageNamed:@"grayDown"];
        
        _rightLabel.textColor = [UIColor colorWithHexString:@"#2E2E2E"];
        _rightImv.image = [UIImage imageNamed:@"darkDown"];
    }
}

- (void)setLeftStr:(NSString *)leftStr{
    _leftStr = leftStr;
    _leftLabel.text = leftStr;
}

- (void)setRightStr:(NSString *)rightStr{
    _rightStr = rightStr;
    _rightLabel.text = rightStr;
}
@end
