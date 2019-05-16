//
//  HTFestivalViewController.m
//  有术
//
//  Created by mac on 2018/1/25.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTNearFestivalTableViewCell.h"
#import "HTTodayFestivalTableViewCell.h"
#import "HTNormorlFestivalTableViewCell.h"
#import "HTFestivalViewController.h"
#import "HTCustomerViewController.h"
@interface HTFestivalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *sectionTitles;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstain;

@end

@implementation HTFestivalViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.title = @"节日提醒";
    self.backImg = @"g-whiteback";
    [self createTb];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavHidden];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.clipsToBounds = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dataArr = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        NSDictionary *dic = dataArr[indexPath.row];
        if ([dic getFloatWithKey:@"diffDay"] == 0.0f) {
            HTTodayFestivalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTodayFestivalTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataDic = dataArr[indexPath.row];
            return cell;
        }else{
            HTNearFestivalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNearFestivalTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataDic = dataArr[indexPath.row];
            return cell;
        }
    }else{
        HTNormorlFestivalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNormorlFestivalTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = dataArr[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HMSCREENWIDTH * 9 / 16;
    }else{
        return 85;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }else{
        return 45;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 45)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.sectionTitles[section];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    [headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(headView.mas_leading).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
//    vc.title = @"会员列表";
//    vc.backImg = @"g-back";
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = [UIColor whiteColor];
    if (scrollView.contentOffset.y <= 10) {
        self.backImg = @"g-whiteback";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
        self.navigationController.navigationBar.clipsToBounds = YES;
    }else{
        self.backImg = @"g-back";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
        self.navigationController.navigationBar.clipsToBounds = NO;
    }
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent: scrollView.contentOffset.y  / 100]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods

- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    self.navigationController.navigationBar.translucent = YES;
}
-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}
-(void)loadData{
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/festival_birthdy_remind//load_festival.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSArray *dataArray = [json getArrayWithKey:@"data"];
        for (int i = 0; i  < dataArray.count; i++) {
            NSDictionary *dataDic = dataArray[i];
            if (i == 0) {
                NSDictionary *dic = [[dataDic getArrayWithKey:@"value"] firstObject];
                [self.dataArray addObject:@[dic] ];
                [self.sectionTitles addObject:@""];
                if ([dataDic getArrayWithKey:@"value"].count > 1) {
                    NSMutableArray *firsts = [NSMutableArray array];
                    NSArray *arr = [dataDic getArrayWithKey:@"value"];
                    for (int i = 1; i < arr.count; i++) {
                        NSDictionary *dic = arr[i];
                        [firsts addObject:dic];
                    }
                    [self.dataArray addObject:firsts ];
                    [self.sectionTitles addObject:[dataDic getStringWithKey:@"key"]];
                }
            }else{
                [self.dataArray addObject:[dataDic getArrayWithKey:@"value"] ];
                [self.sectionTitles addObject:[dataDic getStringWithKey:@"key"]];
            }
        }
        [self.myTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@""];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
    
    
}
-(void)createTb{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTNearFestivalTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNearFestivalTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTNormorlFestivalTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNormorlFestivalTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTTodayFestivalTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTodayFestivalTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.myTableView.tableFooterView = v ;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.topConstain.constant = -nav_height;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}
@end
