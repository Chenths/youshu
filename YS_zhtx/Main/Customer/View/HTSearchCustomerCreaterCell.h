//
//  HTSearchCustomerCreaterCell.h
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertHidd)(void);
typedef void(^AlertShow)(void);
@interface HTSearchCustomerCreaterCell : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property (nonatomic,copy) AlertHidd alertHidd;

@property (nonatomic,copy) AlertShow alertShow;

@end
