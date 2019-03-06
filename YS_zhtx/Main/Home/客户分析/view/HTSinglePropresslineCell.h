//
//  HTSinglePropresslineCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTHorizontalReportDataModel.h"
#import <UIKit/UIKit.h>
@protocol SinglePropressDelegate <NSObject>
- (void)selectBtnWithIfTopBtn:(BOOL)isTop WithIndexRow:(NSInteger)row;
@end
@interface HTSinglePropresslineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic,strong) HTHorizontalReportDataModel *model;
@property (nonatomic,strong) HTHorizontalReportDataModel *secondModel;
@property (nonatomic, weak) id<SinglePropressDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
