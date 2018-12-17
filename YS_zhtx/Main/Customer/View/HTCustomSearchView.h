//
//  HTCustomSearchView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTCustomSearchViewDelegate<NSObject>

-(void)searchOkBtClicked;

@end
typedef NS_ENUM(NSInteger, HTCustomSearchType) {
    HTCustomSearchTypeCustomer,                // Default type for the current input method.
    HTCustomSearchTypeOrder,           // Displays a keyboard which can enter ASCII character
    
};

@interface HTCustomSearchView : UIView

+ (void)showSearchViewInViewDelegate:(id<HTCustomSearchViewDelegate>)delegate andSearchDic:(NSDictionary *) searchDic;
+ (instancetype)initSearchWithFrame:(CGRect)frame;
@property (nonatomic,weak) id <HTCustomSearchViewDelegate> delegate;


@end
