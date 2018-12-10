//
//  HTColorAndSizeFiltrateBox.h
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTColorAndSizeFiltrateBoxDelegate<NSObject>

-(void)FiltrateBoxDidSelectedInSection:(NSInteger) section andRow:(NSInteger) row;

-(void)searchBtClicked;

-(void)colorDismissWithColors:(NSArray *)colors andSizes:(NSArray *)sizes;

@end

@interface HTColorAndSizeFiltrateBox : UIView

- (instancetype)initWithBoxFrame:(CGRect)frame;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak) id <HTColorAndSizeFiltrateBoxDelegate> delegate;

@end
