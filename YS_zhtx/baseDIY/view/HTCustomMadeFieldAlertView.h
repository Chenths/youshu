//
//  HTCustomMadeFieldAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTCustomMadeFieldAlertViewDelegate<NSObject>

-(void)okBtClickedWithStr:(NSString *)text;

-(void)cancelBtClickedWithStr:(NSString *)text;


@end
@interface HTCustomMadeFieldAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,weak) id <HTCustomMadeFieldAlertViewDelegate> delegate;

-(void)show;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id <HTCustomMadeFieldAlertViewDelegate>)delegate;

@end
