//
//  HTChangeTypeTableCell.h
//  YS_zhtx
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTChangeTypeTableCellDelegate <NSObject>

-(void)nomorlClick;

-(void)changeClick;

@end
@interface HTChangeTypeTableCell : UITableViewCell

@property (nonatomic,weak) id <HTChangeTypeTableCellDelegate> delegate;

@end
