//
//  HTNewPayYHQMaskView.h
//  YS_zhtx
//
//  Created by mac on 2019/8/9.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YHQMaskViewDelegate <NSObject>
- (void)YHQMaskViewDelegateSelectAciton:(NSInteger)type;

@end
@interface HTNewPayYHQMaskView : UIView
@property (weak, nonatomic) IBOutlet UITableView *maskTb;
@property (nonatomic, weak) id <YHQMaskViewDelegate> delegate;
// 1代金券  2 状态
@property (nonatomic, assign) NSInteger currentType;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
