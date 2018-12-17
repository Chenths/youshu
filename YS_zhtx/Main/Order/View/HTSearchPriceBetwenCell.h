//
//  HTSearchPriceBetwenCell.h
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSearchPriceBetwenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *beginField;

@property (weak, nonatomic) IBOutlet UITextField *endField;

@property (nonatomic,strong) NSMutableDictionary *searchDic;


@end
