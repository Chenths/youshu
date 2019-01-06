//
//  HTCustomerFaceInfoCell.h
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HTNewFaceNoVipModel.h"
//#import "HTFaceVipModel.h"
@class HTCustomerFaceInfoCell;
@protocol HTCustomerFaceInfoCellDelegate

//-(void)deleleItemeWithCell:(HTCustomerFaceInfoCell *)cell;

-(void)receptionCustmerWithCell:(HTCustomerFaceInfoCell *)cell;

- (void)repitBuyWithCell:(HTCustomerFaceInfoCell *)cell;

- (void)writeCutomerInfoWithCell:(HTCustomerFaceInfoCell *)cell;


@end

@interface HTCustomerFaceInfoCell : UITableViewCell

@property (nonatomic,weak) id <HTCustomerFaceInfoCellDelegate> delegate;

@property (nonatomic,strong) HTNewFaceNoVipModel *notVipModel;

//@property (nonatomic,strong) HTFaceVipModel *vipModel;

@end
