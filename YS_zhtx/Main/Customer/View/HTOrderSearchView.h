//
//  HTCustomSearchView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTOrderSearchViewDelegate<NSObject>

-(void)searchOkBtClicked;

@end


@interface HTOrderSearchView : UIView

+ (void)showSearchViewInViewDelegate:(id<HTOrderSearchViewDelegate>)delegate andSearchDic:(NSDictionary *) searchDic;
+ (instancetype)initSearchWithFrame:(CGRect)frame;
@property (nonatomic,weak) id <HTOrderSearchViewDelegate> delegate;


@end
