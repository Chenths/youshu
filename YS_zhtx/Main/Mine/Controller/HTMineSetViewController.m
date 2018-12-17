//
//  HTMineSetViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTAccountTool.h"
#import "HTChangePasswordViewController.h"
#import "HTMineSetViewController.h"
#import "HTBindWechatController.h"

@interface HTMineSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@end

@implementation HTMineSetViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celll"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"celll"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = indexPath.row == 0 ? @"绑定微信":@"修改密码";
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor colorWithHexString:@"F1f1f1"];
    return vvv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        HTChangePasswordViewController *vc = [[HTChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0){
        HTBindWechatController *vc = [[HTBindWechatController alloc] init];
        vc.title = @"绑定微信";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)exitLoginClicked:(id)sender {
    [HTAccountTool exitLogin];
}
#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTWarningDefaulTableCell" bundle:nil] forCellReuseIdentifier:@"HTWarningDefaulTableCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
}
#pragma mark - getters and setters

@end
