//
//  HTRightNavBar.m
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTRightNavBar.h"
@interface HTRightNavBar()

@property (weak, nonatomic) IBOutlet UILabel *ImageLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baceViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgImageView;


@end

@implementation HTRightNavBar


- (void)baseInit{
    self.backView.hidden = YES;
    self.backView.backgroundColor = [UIColor redColor];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont systemFontOfSize:10];
}

- (void)setNumber:(int)number{
    
    if (number != 0) {
        self.backView.hidden = NO;
        self.numberLabel.text = number > 99 ?  @"99+" : [NSString stringWithFormat:@"%d",number];
        
        CGFloat width = [self.numberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:10]} context:nil].size.width  + 10;
        _baceViewWidth.constant = width > 18 ? width : 18;
        [_backView layoutIfNeeded];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 9;
    }else{
        self.backView.hidden = YES;
    }
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.msgImageView.image = [UIImage imageNamed:imageName];
}

@end
