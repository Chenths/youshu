//
//  HTBossGoodsChooseHeaderView.h
//  YS_zhtx
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HTBossChooseBtnDelegate <NSObject>
- (void)bossChooseBtnDelegateAction:(NSInteger)tag;
@end
@interface HTBossGoodsChooseHeaderView : UIView
@property (nonatomic, weak) id<HTBossChooseBtnDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftImv;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topRightImv;
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray *itemsColorArray;
@property (nonatomic, strong) NSMutableArray *itemsStatusArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvHeight;
@property (nonatomic, assign) NSInteger currentSelectedColor;
@property (nonatomic, assign) NSInteger currentSelectedStatus;
@property (nonatomic, assign) NSInteger currentType;
@end

NS_ASSUME_NONNULL_END
