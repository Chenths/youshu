//
//  HTBossSectionReportView.m
//  有术
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossSectionReportView.h"
@interface HTBossSectionReportView()
@property (weak, nonatomic) IBOutlet UIImageView *openIMg;

@end
@implementation HTBossSectionReportView

- (instancetype)initWithSectionFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HTBossSectionReportView" owner:nil options:nil].lastObject;
    }
    return self;
}
- (void)setModel:(HTSectionOpenModel *)model{
    _model = model;
    self.openIMg.image = model.isOpen ? [UIImage imageNamed:@"折叠"] : [UIImage imageNamed:@"展开-黑"];
}

@end
