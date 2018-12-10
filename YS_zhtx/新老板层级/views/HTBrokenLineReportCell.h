//
//  HTBrokenLineReportCell.h
//  有术
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
@protocol  HTBrokenLineReportCellDelegate<NSObject>
-(void)timecliked;

@end
#import <UIKit/UIKit.h>

@interface HTBrokenLineReportCell : UITableViewCell
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,weak)  id <HTBrokenLineReportCellDelegate> delegate;
@end
