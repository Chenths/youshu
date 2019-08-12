//
//  HTBossGoodsCompareListTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RETRUNCONTENTOFFSET)(CGPoint);
NS_ASSUME_NONNULL_BEGIN

@interface HTBossGoodsCompareListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic,copy) RETRUNCONTENTOFFSET returnOFFset;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSString *detailStr;
@end

NS_ASSUME_NONNULL_END
