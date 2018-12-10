//
//  HTChangePriceAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HTChangePriceType) {
    HTChangePrice = 0,                         // no button type
    HTChangeDiscount ,  // standard system button

};

@protocol HTChangePriceAlertViewDelegate <NSObject>

-(void)hasChangePriceWithFinalPrice:(NSString *)finallPrice;

-(void)hasChangePriceWithDiscount:(NSString *)discount;


@end
@interface HTChangePriceAlertView : UIView

- (instancetype)initWithChangePriceAlertWithType:(HTChangePriceType) type;

@property (nonatomic,strong) NSArray *selectedArray;

@property (nonatomic,weak) id <HTChangePriceAlertViewDelegate> delegate;

-(void)show;


@end
