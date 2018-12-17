//
//  HTOrderSearchCustomerTableCell.h
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^AlertTHidd)(void);
typedef void(^AlertTShow)(void);

#import <UIKit/UIKit.h>

@interface HTOrderSearchCustomerTableCell : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property (nonatomic,copy) AlertTHidd alertttttHidd;

@property (nonatomic,copy) AlertTShow alerttttShow;

@end
