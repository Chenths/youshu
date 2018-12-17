//
//  HTCirclePeiDataDetailController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPieDataChartTableViewCell.h"
#import "HTLegendTableViewCell.h"
#import "HTCirclePeiDataDetailController.h"

@interface HTCirclePeiDataDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *colorsArray;

@end

@implementation HTCirclePeiDataDetailController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self setDataArr:self.model.data];
    self.title = self.model.title;
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTPieDataChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTPieDataChartTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    }else{
        HTLegendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLegendTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        if (indexPath.row % 2) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        }
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count == 0 ? 0 : section == 0 ? 1 : self.dataArray.count;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;

    [self.tab registerNib:[UINib nibWithNibName:@"HTPieDataChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTPieDataChartTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTLegendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLegendTableViewCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
-(void)setDataArr:(NSArray *)dataArr{
    [self.dataArray removeAllObjects];
    for (int i = 0; i < dataArr.count ;i++ ) {
        HTPieDataItem *item = dataArr[i];
        item.color = [UIColor colorWithHexString:( i < self.colorsArray.count ?  self.colorsArray[i] : self.colorsArray[i % self.colorsArray.count])];
        item.suffix = @"件";
        [self.dataArray addObject:item];
    }
    [self.tab reloadData];
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSArray *)colorsArray{
    if (!_colorsArray) {
        _colorsArray = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colorsArray;
}
@end
