//
//  HTBossSaleCompareListInfoTableCell.h
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossRankReportDataModel.h"
#import <UIKit/UIKit.h>
typedef void(^RETRUNCONTENTOFFSET)(CGPoint);
@interface HTBossSaleCompareListInfoTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;
@property (nonatomic,copy) RETRUNCONTENTOFFSET returnOFFset;

@property (nonatomic,strong) HTBossRankReportDataModel *model;

@property (nonatomic,strong) NSString *title;

@end
