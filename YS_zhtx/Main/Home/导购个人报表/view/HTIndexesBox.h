//
//  HTIndexesBox.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^SrollerToIndex)(NSIndexPath *index);
typedef void(^ClickAtIndex)(NSInteger index);
#import <UIKit/UIKit.h>

@interface HTIndexesBox : UIView

@property (nonatomic,copy) SrollerToIndex srollerToIndex;

@property (nonatomic,copy) ClickAtIndex clickAtIndex;

@property (nonatomic,strong) NSIndexPath *selectedIndex;

- (instancetype)initWithBoxFrame:(CGRect)frame ;

-(void)initSubviewswithDatas:(NSArray *)datas;

-(void)initHeadSubviewswithDatas:(NSArray *)datas;

@end
