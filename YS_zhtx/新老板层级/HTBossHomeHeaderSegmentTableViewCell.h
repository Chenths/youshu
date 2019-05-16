//
//  HTBossHomeHeaderSegmentTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/4/26.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HTBossHomeSegmenDelegate <NSObject>

- (void)segmentControlValueChangedDelegate:(NSInteger) index;

@end
@interface HTBossHomeHeaderSegmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentC;
@property (nonatomic, weak) id <HTBossHomeSegmenDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
