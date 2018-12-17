//
//  HTAgentStoreSectionHead.h
//  有术
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAgentStoreSectionHead : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchBt;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

- (instancetype)initWithCustomerFrame:(CGRect)frame;


@end
