//
//  HTBossMeClickedTableViewCell.h
//  有术
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
@protocol HTBossMeClickedTableViewCellDelegate <NSObject>
-(void) shopClicked;

-(void) inventeroyListClicked;


@end
#import <UIKit/UIKit.h>

@interface HTBossMeClickedTableViewCell : UITableViewCell

@property (nonatomic,weak) id <HTBossMeClickedTableViewCellDelegate> delegate;

@end
