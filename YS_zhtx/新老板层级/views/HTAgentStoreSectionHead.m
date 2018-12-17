//
//  HTAgentStoreSectionHead.m
//  有术
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTAgentStoreSectionHead.h"

@implementation HTAgentStoreSectionHead

- (instancetype)initWithCustomerFrame:(CGRect)frame
{
   self =  [super initWithFrame:frame];
    if (self) {
        self =   [[NSBundle mainBundle] loadNibNamed:@"HTAgentStoreSectionHead" owner:nil options:nil].lastObject;
    }
    return self;
}
@end
