//
//  HTHumLineGuideView.h
//  24小助理
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHumanTraModel.h"

@interface HTHumLineGuideView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (nonatomic,strong) HTHumanTraModel *model ;

@end
