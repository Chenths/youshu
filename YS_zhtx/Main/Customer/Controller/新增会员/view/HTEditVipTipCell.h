//
//  HTEditVipTipCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/2.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCustEditConfigModel.h"
@interface HTEditVipTipCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;
@property (nonatomic,strong) NSMutableDictionary *requestDic;
@end
