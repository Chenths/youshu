//
//  HTCustomTextAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancleBtClick)(void);
typedef void(^OkBtClick)(NSString *);
@interface HTCustomTextAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *holdLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,copy) OkBtClick  okBtClicked;

@property (nonatomic,copy) CancleBtClick cancleClicked;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelLeftConstains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoBtnLeadingToTailing;


+(void)showAlertWithTitle:(NSString *)title  holdTitle:(NSString *)hold orTextString:(NSString *)textStr okBtclicked:(OkBtClick)ok andCancleBtClicked:(CancleBtClick) cancel;
+(void)showAlertWhiteBackAndNoTouchWithTitle:(NSString *)title  holdTitle:(NSString *)hold orTextString:(NSString *)textStr okBtclicked:(OkBtClick)ok andCancleBtClicked:(CancleBtClick) cancel ;

@end
