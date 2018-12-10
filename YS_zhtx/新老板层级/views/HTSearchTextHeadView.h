//
//  HTSearchTextHeadView.h
//  有术
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  HTSearchTextHeadViewDelegat<NSObject>

-(void)searchShopWithString:(NSString *)searchStr;

@end
@interface HTSearchTextHeadView : UIView

@property (nonatomic,weak) id <HTSearchTextHeadViewDelegat> delegate;

- (instancetype)initWithSearchFrame:(CGRect)frame;



@end
