//
//  HTSelectedProductStyleAlert.h
//  YS_zhtx
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^selectedItem)(NSInteger index);
#import <UIKit/UIKit.h>

@interface HTSelectedProductStyleAlert : UIView

+(void)showSelectedProductStyleData:(NSArray *)stylecodes withSearchStr:(NSString *)serchSrt andSeleced:(selectedItem) selcetd ;

@end
