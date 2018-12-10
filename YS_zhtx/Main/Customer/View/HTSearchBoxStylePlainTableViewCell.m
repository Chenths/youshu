//
//  HTSearchBoxStylePlainTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSearchBoxStylePlainTableViewCell.h"
@interface HTSearchBoxStylePlainTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property (weak, nonatomic) IBOutlet UIView *textBackView;


@end
@implementation HTSearchBoxStylePlainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textBackView changeCornerRadiusWithRadius:3];
    
}
-(void)setSearchDic:(NSDictionary *)searchDic{
    _searchDic = searchDic;
    self.textfiled.text = [searchDic getStringWithKey:@"model.nickname_cust"];
}


@end
