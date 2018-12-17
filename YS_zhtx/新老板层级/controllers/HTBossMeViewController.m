//
//  HTBossMeViewController.m
//  有术
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossMeViewController.h"
#import "HTBossMeHeadTableViewCell.h"
#import "HTBossMeDesInfoTableViewCell.h"
#import "HTBossMeClickedTableViewCell.h"
//#import "HTTuneCenterViewController.h"
//#import "HTCustomersListViewController.h"
#import "HTCustomerViewController.h"
#import "HTMenuModle.h"
#import "HTNoticeViewController.h"
#import "HTTotleExplainViewController.h"
#import "HTContactUsViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HTRightNavBar.h"
#import "HTMsgCenterViewController.h"
//#import "HTTotleMessgeViewController.h"
#import "HTTurnListTypeDescViewController.h"
#import "HTBossSetterViewController.h"
@interface HTBossMeViewController ()<UITableViewDelegate,UITableViewDataSource,HTBossMeClickedTableViewCellDelegate>{
    UIView    * navgationBarBackView;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstain;
@property (nonatomic,strong) HTRightNavBar *rightBt ;
@end

@implementation HTBossMeViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
//    self.navigationController.navigationBar.alpha = 0.0f;
    [self createTb];
     [self createRightNavBar];
    self.topConstain.constant = 0 - nav_height + 10;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#222222"]];
    [self laodNoRedNum];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0  ) {
            HTBossMeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossMeHeadTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            HTBossMeDesInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossMeDesInfoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }else if (indexPath.section == 1){
        HTBossMeClickedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossMeClickedTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        NSArray *ims = @[@"使用说明",@"版本介绍",@"售后服务"];
        cell.imageView.image = [UIImage imageNamed:ims[indexPath.row]];
        cell.textLabel.text = ims[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return HMSCREENWIDTH *601 / 1130;
        }else{
            return 64;
        }
    }else if (indexPath.section ==1){
        return 130;
    }else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"使用说明"]) {
              HTTotleExplainViewController *vc = [[HTTotleExplainViewController alloc] init];
              vc.title =  cell.textLabel.text;
              [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.textLabel.text isEqualToString:@"版本介绍"]){
               HTNoticeViewController *vc = [[HTNoticeViewController alloc] init];
            vc.title =  cell.textLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.textLabel.text isEqualToString:@"售后服务"]){
            HTContactUsViewController *vc = [[HTContactUsViewController alloc] init];
            vc.title =  cell.textLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
#pragma mark -CustomDelegate
- (void)shopClicked{
    if ([HTShareClass shareClass].menuArray.count > 0) {
//        HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *dic = @{
                              @"companyId" : [HTShareClass shareClass].loginModel.companyId
                              };
        __weak typeof(self) weakSelf = self;
        [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMenu,loadMenu] params:dic success:^(id json) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"data"][@"menu"]) {
                
                HTMenuModle *model = [[HTMenuModle alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
            [HTShareClass shareClass].menuArray = arr;
#warning 店铺列表
//            HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//            HTCustomersListViewController *vc = [[HTCustomersListViewController alloc] init];
//            for (HTMenuModle *modle in [HTShareClass shareClass].menuArray) {
//                if ([modle.moduleName  isEqualToString:@"company"]) {
//                    vc.menuModel = modle;
//                    break;
//                }
//            }
//            [strongSelf.navigationController pushViewController:vc animated:YES];
            
        } error:^{
            
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)inventeroyListClicked{
    HTTurnListTypeDescViewController *vc = [[HTTurnListTypeDescViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -EventResponse
-(void)setClicked:(UIBarButtonItem *)sender{
    HTBossSetterViewController *vc = [[HTBossSetterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightBtClicked:(UIButton *)sender{
    [self.navigationController pushViewController:[[HTMsgCenterViewController alloc] init] animated:YES];
}
#pragma mark -private methods
- (void)laodNoRedNum{
    
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    __weak typeof(self) weakSelf = self;
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        __weak typeof(weakSelf) strongSelf  = weakSelf;
        if (json[@"data"][@"count"]) {
            [strongSelf.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
- (void)createTb{
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossMeHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossMeHeadTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossMeDesInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossMeDesInfoTableViewCell"];
     [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossMeClickedTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossMeClickedTableViewCell"];
    self.myTableView.tableFooterView = footView;
    self.myTableView.contentInset = self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + tar_height, 0);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"设置" highImageName:@"设置" target:self action:@selector(setClicked:)];
}
- (void)createRightNavBar{
    
    self.rightBt = [[[NSBundle mainBundle] loadNibNamed:@"HTRightNavBar" owner:nil options:nil]  lastObject];
    [self.rightBt baseInit];
    [self.rightBt sizeToFit];
    [self.rightBt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
}
#pragma mark - getters and setters



@end
