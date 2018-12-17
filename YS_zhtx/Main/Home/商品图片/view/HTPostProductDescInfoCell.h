//
//  HTPostProductDescInfoCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTProductStyleModel.h"
@protocol HTPostProductDescInfoCellDelegate<NSObject>

-(void)topBtClick;

@end
@interface HTPostProductDescInfoCell : UITableViewCell

@property (nonatomic,assign) ControllerType controllerType;
@property (nonatomic,strong) HTProductStyleModel *model;

@property (nonatomic,assign) id <HTPostProductDescInfoCellDelegate> delegate;

@end
