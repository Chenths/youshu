//
//  HTChargeMaskViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"
@protocol chooseSellerBackDelegate<NSObject>

- (void)chooseSellerBack:(NSMutableArray *)sellerArr;

@end

@interface HTChargeMaskViewController : HTCommonViewController
@property (weak, nonatomic) IBOutlet UITableView *chooseSellerTb;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, weak) id<chooseSellerBackDelegate> delegate;
@end
