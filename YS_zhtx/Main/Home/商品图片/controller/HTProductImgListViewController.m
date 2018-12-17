//
//  HTProductImgListViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNotAddImgProductCell.h"
#import "HTProductImgListViewController.h"
#import "HTPostProductImgViewController.h"
@interface HTProductImgListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation HTProductImgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNotAddImgProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNotAddImgProductCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     HTPostProductImgViewController*vc = [[HTPostProductImgViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTNotAddImgProductCell" bundle:nil] forCellReuseIdentifier:@"HTNotAddImgProductCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters
@end
