//
//  HTSearchBoxStylePlainTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSearchBoxStylePlainTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *searchDic;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@end
