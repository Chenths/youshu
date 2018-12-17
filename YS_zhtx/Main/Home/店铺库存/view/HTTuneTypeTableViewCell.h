//
//  HTTuneTypeTableViewCell.h
//  有术
//
//  Created by mac on 2017/12/26.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTTuneTypeTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) NSString *key;

@property (nonatomic,strong) NSMutableDictionary *typeDic;

@end
