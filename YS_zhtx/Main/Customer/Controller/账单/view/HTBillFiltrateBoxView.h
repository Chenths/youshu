//
//  HTCustomerFiltrateBoxView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTFiltrateHeaderModel;
@protocol HTBillFiltrateBoxViewDelegate<NSObject>

-(void)FiltrateBoxDidSelectedInSection:(NSInteger) section andRow:(NSInteger) row withHeadModel:(HTFiltrateHeaderModel *)model;

-(void)searchBtClicked;

@end

@interface HTBillFiltrateBoxView : UIView

- (instancetype)initWithBoxFrame:(CGRect)frame;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak) id <HTBillFiltrateBoxViewDelegate> delegate;

@end
