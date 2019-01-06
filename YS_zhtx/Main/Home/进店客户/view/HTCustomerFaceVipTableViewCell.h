//
//  HTCustomerFaceVipTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/4.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNewFaceNoVipModel.h"
#import "HTNewFaceVipModel.h"
@class HTCustomerFaceVipTableViewCell;
@protocol HTCustomerFaceVIPCellDelegate

//-(void)deleleItemeWithVipCell:(HTCustomerFaceVipTableViewCell *)cell;

-(void)receptionCustmerVipWithCell:(HTCustomerFaceVipTableViewCell *)cell;

- (void)repitBuyVipWithCell:(HTCustomerFaceVipTableViewCell *)cell;

- (void)writeCutomerInfoVipWithCell:(HTCustomerFaceVipTableViewCell *)cell;


@end

@interface HTCustomerFaceVipTableViewCell : UITableViewCell

@property (nonatomic,weak) id <HTCustomerFaceVIPCellDelegate> delegate;

//@property (nonatomic,strong) HTNewFaceNoVipModel *notVipModel;

@property (nonatomic,strong) HTNewFaceVipModel *vipModel;

@end
