//
//  HTStoredAlertView.h
//  有术
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTStoredAlertViewDelegate

-(void)cancelStored;

-(void)storedMoney:(NSString *)amount withSend:(NSString *)send;

@end

@interface HTStoredAlertView : UIView
-(instancetype)initAlertWithFrame:(CGRect)frame;

@property (nonatomic,weak) id <HTStoredAlertViewDelegate> delegate;

@property (nonatomic,strong) NSArray *dataArray;

@end
