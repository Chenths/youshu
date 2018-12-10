//
//  HTIndexesBox.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTIndexsModel.h"
#import "HTIndexesBox.h"
#import "HTIndexBoxDescViewController.h"
@interface HTIndexesBox()

@property (weak, nonatomic) IBOutlet UIScrollView *backScorllerView;
@property (nonatomic,strong) NSArray *datArr;
@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) NSMutableArray *bts;
@property (weak, nonatomic) IBOutlet UIButton *moreBt;



@end
@implementation HTIndexesBox

- (instancetype)initWithBoxFrame:(CGRect)frame
{
    HTIndexesBox *boxView = [[NSBundle mainBundle] loadNibNamed:@"HTIndexesBox" owner:nil options:nil].lastObject;
    [boxView setFrame:frame];
    
    return boxView;
}
-(void)initSubviewswithDatas:(NSArray *)datas{
    self.datArr = datas;
    CGFloat btx = 0;
    for (int i = 0; i < self.datArr.count; i++) {
        HTIndexsModel *model = self.datArr[i];
      UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
      [bt setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
      [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateSelected];
      [bt setTitle:[HTHoldNullObj getValueWithUnCheakValue:model.titles] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
      CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
        bt.frame = CGRectMake(btx, 0, titleWidth , self.height);
        btx += titleWidth;
        bt.tag = 500 + i;
        [_backScorllerView addSubview:bt];
        [self.bts addObject:bt];
    }
    _backScorllerView.contentSize = CGSizeMake(btx, self.height);
}
-(void)initHeadSubviewswithDatas:(NSArray *)datas{
    self.datArr = datas;
    CGFloat btx = 0;
    for (int i = 0; i < self.datArr.count; i++) {
        HTIndexsModel *model = self.datArr[i];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        [bt setTitle:[HTHoldNullObj getValueWithUnCheakValue:model.titles] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
        bt.frame = CGRectMake(btx, 0, titleWidth , self.height);
        btx += titleWidth;
        bt.tag = 500 + i;
        [_backScorllerView addSubview:bt];
        [self.bts addObject:bt];
    }
    _backScorllerView.contentSize = CGSizeMake(btx, self.height);
    [self.moreBt setBackgroundImage:[UIImage imageNamed:@"g-indexblackBack"] forState:UIControlStateNormal];
    [self.moreBt setBackgroundImage:[UIImage imageNamed:@"g-indexblackBack"] forState:UIControlStateHighlighted];
    [self.moreBt setImage:[UIImage imageNamed:@"g-inventoryAdd"] forState:UIControlStateNormal];
    [self.moreBt setImage:[UIImage imageNamed:@"g-inventoryAdd"] forState:UIControlStateNormal];
}
-(void)btClicked:(UIButton *)sender{
    UIButton *bt = (UIButton *)sender;
    int index = (int)bt.tag - 500;
    HTIndexsModel *model = self.datArr[index];
    self.selectedIndex = model.indexpath;
    if (self.srollerToIndex) {
        self.srollerToIndex(model.indexpath);
    }
    
    if (self.clickAtIndex) {
        self.clickAtIndex(index);
    }
}
- (IBAction)openClicked:(id)sender {
    HTIndexBoxDescViewController *vc = [[HTIndexBoxDescViewController alloc] init];
    vc.dataArray = self.datArr;
    __weak typeof(self) weakSelf = self;
    vc.selectedIndex = ^(NSUInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        HTIndexsModel *model = strongSelf.datArr[index];
        if (self.srollerToIndex) {
            self.srollerToIndex(model.indexpath);
        }
        self.selectedIndex = model.indexpath;
    };
    [[HTShareClass shareClass].getCurrentNavController presentViewController:vc animated:YES completion:nil];
}
-(void)setSelectedIndex:(NSIndexPath *)selectedIndex{
    _selectedIndex = selectedIndex;
    HTIndexsModel *selted = [[HTIndexsModel alloc] init];
    for (int i = 0; i < self.datArr.count; i++) {
        HTIndexsModel *model = self.datArr[i];
        UIButton *bt = self.bts[i];
        [bt setSelected:NO];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        if (model.indexpath.section == selectedIndex.section && model.indexpath.row == selectedIndex.row) {
            selted = model;
            [bt setSelected:YES];
            bt.titleLabel.font = [UIFont systemFontOfSize:17];
            if (bt.x + bt.width > self.backScorllerView.width) {
                self.backScorllerView.contentOffset = CGPointMake(bt.x + bt.width  - self.backScorllerView.width, 0);
            }else{
                self.backScorllerView.contentOffset = CGPointMake(0, 0);
            }
        }
    }
}
-(NSMutableArray *)bts{
    if (!_bts) {
        _bts = [NSMutableArray array];
    }
    return _bts;
}

@end
