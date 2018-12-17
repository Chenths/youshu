//
//  HTChoosePrintSizeCell.h
//  有术
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTChoosePrintSizeDelegate <NSObject>
// 0 58mm  1 80mm
- (void)choseThisSize:(int) size;

@end

@interface HTChoosePrintSizeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *smallBt;

@property (weak, nonatomic) IBOutlet UIButton *bigBt;

@property (nonatomic,assign) int seletedSize;

@property (nonatomic,weak) id <HTChoosePrintSizeDelegate> delegate;

@end
