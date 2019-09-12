//
//  HTNewPayYHQMaskView.m
//  YS_zhtx
//
//  Created by mac on 2019/8/9.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTNewPayYHQMaskView.h"
@interface HTNewPayYHQMaskView()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *dataArr;
}
@end
@implementation HTNewPayYHQMaskView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self buildTb];
}

- (void)buildTb{
    UIView *footer = [[UIView alloc] init];
    self.maskTb.delegate = self;
    self.maskTb.dataSource = self;
    self.maskTb.tableFooterView = footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_selectedIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#2E2E2E"];
    }else{
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#949494"];
    }
    if (dataArr) {
        cell.textLabel.text = dataArr[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)setCurrentType:(NSInteger)currentType{
    _currentType = currentType;
    if (currentType == 1) {
        dataArr = [NSMutableArray arrayWithArray:@[@"全部", @"折扣券", @"兑换券", @"代金券"]];
    }else{
        dataArr = [NSMutableArray arrayWithArray:@[@"全部", @"未使用", @"已使用", @"已过期"]];
    }
    [_maskTb reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_delegate) {
        [self.delegate YHQMaskViewDelegateSelectAciton:indexPath.row];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
