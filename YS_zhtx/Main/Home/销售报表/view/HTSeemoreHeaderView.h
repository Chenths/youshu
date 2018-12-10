//
//  HTSeemoreHeaderView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSeemoreHeaderViewDelegate

-(void) moreClicked;


@end

@interface HTSeemoreHeaderView : UIView

@property (nonatomic,weak) id <HTSeemoreHeaderViewDelegate>delegate;

@end
