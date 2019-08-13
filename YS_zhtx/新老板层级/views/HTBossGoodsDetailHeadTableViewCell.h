//
//  HTBossGoodsDetailHeadTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HTBossGoodRefreshDelegate <NSObject>
- (void)bossGoodRefreshDelegateAction;
@end
@interface HTBossGoodsDetailHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *kuanhao;
@property (weak, nonatomic) IBOutlet UILabel *gongyingshang;
@property (weak, nonatomic) IBOutlet UILabel *pinpai;
@property (weak, nonatomic) IBOutlet UILabel *nianfen;
@property (weak, nonatomic) IBOutlet UILabel *jijie;
@property (weak, nonatomic) IBOutlet UILabel *mingcheng;
@property (weak, nonatomic) IBOutlet UILabel *mianliao;
@property (weak, nonatomic) IBOutlet UILabel *liliao;
@property (weak, nonatomic) IBOutlet UILabel *peiliao;
@property (weak, nonatomic) IBOutlet UILabel *dengji;
@property (weak, nonatomic) IBOutlet UILabel *jianyanyuan;
@property (weak, nonatomic) IBOutlet UILabel *biaozhun;
@property (weak, nonatomic) IBOutlet UILabel *danjia;
@property (weak, nonatomic) IBOutlet UILabel *tongyilingshou;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, weak) id <HTBossGoodRefreshDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
