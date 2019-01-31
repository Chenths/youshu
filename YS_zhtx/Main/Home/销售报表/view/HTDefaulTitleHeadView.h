//
//  HTDefaulTitleHeadView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDefaulTitleHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSString *title;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
