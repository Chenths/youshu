//
//  HTCustomerFiltrateBoxView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTFiltrateHeaderModel;
@protocol HTCustomerFiltrateBoxViewDelegate<NSObject>

-(void)FiltrateBoxDidSelectedInSection:(NSInteger) section andRow:(NSInteger) row withHeadModel:(HTFiltrateHeaderModel *)model;

-(void)searchBtClicked;

@end

@interface HTCustomerFiltrateBoxView : UIView

- (instancetype)initWithBoxFrame:(CGRect)frame;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak) id <HTCustomerFiltrateBoxViewDelegate> delegate;

@end
