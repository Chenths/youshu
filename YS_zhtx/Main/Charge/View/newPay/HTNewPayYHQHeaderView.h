//
//  HTNewPayYHQHeaderView.h
//  YS_zhtx
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YHQHeaderDelegate <NSObject>

- (void)selectHeaderViewWithTag:(NSInteger)tag;

@end
@interface HTNewPayYHQHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImv;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImv;
@property (nonatomic, weak) id <YHQHeaderDelegate> delegate;
//0 未选中 1 选了优惠券 2 选了状态
@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, copy) NSString *leftStr;
@property (nonatomic, copy) NSString *rightStr;
@end

NS_ASSUME_NONNULL_END
