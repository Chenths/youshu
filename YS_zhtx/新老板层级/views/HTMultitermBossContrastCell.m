//
//  HTMultitermBossContrastCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
//多项对比
#import "HTBossMultitermSingleDataCell.h"
#import "HTMultitermBossContrastCell.h"
#import "HTBossVipFrequencyCell.h"
#import "HTBossVipFrequencyModel.h"
@interface HTMultitermBossContrastCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;


@end
@implementation HTMultitermBossContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUi];
}
#pragma mark -life cycel
- (void)setModel:(HTBossMulitCompareModel *)model{
    if (model == _model) {
        return;
    }
    _model = model;
    self.titleLabel.text = model.title;
    [self.dataTableView reloadData];
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.model.isLine) {
        HTBossMultitermSingleDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossMultitermSingleDataCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model.dataArr[indexPath.row];
        return cell;
    }else{
        HTBossVipFrequencyCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossVipFrequencyCell" forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isNeeaLeft = YES;
        cell.model = self.model.dataArr[indexPath.row];
        
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  self.model.isLine ? 34 :  30;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createUi{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    UIView *footView = [[UIView alloc] init];
    self.dataTableView.scrollEnabled = NO;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossMultitermSingleDataCell" bundle:nil] forCellReuseIdentifier:@"HTBossMultitermSingleDataCell"];
     [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossVipFrequencyCell" bundle:nil] forCellReuseIdentifier:@"HTBossVipFrequencyCell"];
    
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle = UITableViewCellAccessoryNone;
}

#pragma mark - getters and setters

@end
