//
//  HTNewPayPayNormalKindTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol paypayNormalDelegate <NSObject>
- (void)clickBtn:(NSString *)payKind;
@end
@interface HTNewPayPayNormalKindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chuzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *chuzengBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *xianjinBtn;
@property (weak, nonatomic) IBOutlet UIButton *shuakaBtn;
@property (nonatomic, assign) id<paypayNormalDelegate> delegate;
//1 全部   2 不可储赠  3  不可储赠储值
@property (nonatomic, assign) NSInteger type;

@end
