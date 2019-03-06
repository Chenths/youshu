//
//  HTDataPropressLineCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDataPropressLineCell : UITableViewCell

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *secondArray;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic, strong) NSString *secBeginTime;

@property (nonatomic, strong) NSString *secEndTime;
@end
