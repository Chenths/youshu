//
//  HTBossSelectedShopView.m
//  有术
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTShopListMultitermContrastCell.h"
#import "HTBossSelectedShopView.h"
@interface HTBossSelectedShopView()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,assign) BOOL isAllSelected;

@property (weak, nonatomic) IBOutlet UIImageView *allSelecetedImg;


@end
@implementation HTBossSelectedShopView
- (instancetype)initWithAlertFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self = [[NSBundle mainBundle] loadNibNamed:@"HTBossSelectedShopView" owner:nil options:nil].lastObject;
        [self setFrame:frame];
        [self createTb];
    }
    return self;
}
#pragma mark -life cycel
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.dataTableView reloadData];
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTShopListMultitermContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopListMultitermContrastCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTCompanyListModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.dataTableView reloadData];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse
- (IBAction)selectedAllClicked:(id)sender {
    if (self.isAllSelected) {
        for (HTCompanyListModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        [self.dataTableView reloadData];
        self.allSelecetedImg.image = [UIImage imageNamed:@"单选-未选中"];
        self.isAllSelected = NO;
    }else{
        for (HTCompanyListModel *model in self.dataArray) {
            model.isSelected = YES;
        }
        [self.dataTableView reloadData];
        self.allSelecetedImg.image = [UIImage imageNamed:@"单选-选中"];
        self.isAllSelected = YES;
    }
  
}
- (IBAction)okSelected:(id)sender {
    if (self.delegate) {
        [self.delegate selectedShopOkBtClicked];
    }
}
#pragma mark -private methods
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopListMultitermContrastCell" bundle:nil] forCellReuseIdentifier:@"HTShopListMultitermContrastCell"];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle =  UITableViewCellAccessoryNone;
}


#pragma mark - getters and setters

@end
