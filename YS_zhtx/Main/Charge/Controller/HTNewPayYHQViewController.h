//
//  HTNewPayYHQViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"
#import "HTYHQModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HTYHQListChooseDelegate <NSObject>

- (void)HTChooseYHQListBackWithModel:(HTYHQModel *)model;

@end
@interface HTNewPayYHQViewController : HTCommonViewController
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, weak) id<HTYHQListChooseDelegate>delegate;
@property (nonatomic, assign) HTYHQModel *currentModel;
@end

NS_ASSUME_NONNULL_END
