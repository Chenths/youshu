//
//  HTBossSetterViewController.m
//  有术
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTChangePasswordViewController.h"
#import "HTAccountTool.h"
#import "HTBossSetterViewController.h"
#import "HTLoginVienController.h"
@interface HTBossSetterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation HTBossSetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titles = @[@"修改密码",@"退出登录"];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HTChangePasswordViewController *vc = [[HTChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [HTAccountTool exitLogin];
        HTLoginVienController *vc = [[HTLoginVienController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = footView;
}

@end
