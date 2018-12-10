//
//  HTIndexBoxDescViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFiltrateTableStyleCell.h"
#import "HTIndexBoxDescViewController.h"

@interface HTIndexBoxDescViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation HTIndexBoxDescViewController





#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTFiltrateTableStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFiltrateTableStyleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
    cell.indexModel = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.selectedIndex) {
        self.selectedIndex(indexPath.row);
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)dismissClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTFiltrateTableStyleCell" bundle:nil] forCellReuseIdentifier:@"HTFiltrateTableStyleCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters

@end
