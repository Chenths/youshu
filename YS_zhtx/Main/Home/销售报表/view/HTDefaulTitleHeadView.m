//
//  HTDefaulTitleHeadView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTDefaulTitleHeadView.h"
@interface HTDefaulTitleHeadView()



@end
@implementation HTDefaulTitleHeadView

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
