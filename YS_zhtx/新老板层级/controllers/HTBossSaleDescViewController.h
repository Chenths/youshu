//
//  HTBossSaleDescViewController.h
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTCommonViewController.h"
typedef NS_OPTIONS(NSUInteger, HTRANKSTATE) {
    HTRANKSTATEYEAR       = 0,
    HTRANKSTATEMONTH  = 1 << 0,                  // used when
};


@interface HTBossSaleDescViewController : HTCommonViewController

@property (nonatomic,assign) HTRANKSTATE rankState;
@end
