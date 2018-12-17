//
//  HTGetLogisticsInfController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "DBManager.h"
#import "HTOrderDetailProductModel.h"
#import "HTLogisticsCompanyModle.h"
#import "HTGetLogisticsInfController.h"
#import "HTLogisticsCompanyCell.h"
#import "HTScanLogistiscViewController.h"
@interface HTGetLogisticsInfController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextField *logintisText;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *finishBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTop;


@end

@implementation HTGetLogisticsInfController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录入物流信息";
    [self configSub];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavHidden];
}

#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTLogisticsCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLogisticsCompanyCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArray enumerateObjectsUsingBlock:^( HTLogisticsCompanyModle *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isSelected = NO;
    }];
    HTLogisticsCompanyModle *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    self.finishBt.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    [tableView reloadData];
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)scanClicked:(id)sender {
    HTScanLogistiscViewController *vc = [[HTScanLogistiscViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.scanResult = ^(NSString *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.logintisText.text = result;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)finishBt:(id)sender {
    
    if (self.logintisText.text.length == 0 && self.dataArray.count == 0) {
        [MBProgressHUD showError:@"请输入运单信息"];
        return;
    }
    for (HTLogisticsCompanyModle *model in self.dataArray) {
        if (model.isSelected) {
            [MBProgressHUD showMessage:@""];
            NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
            for (HTOrderDetailProductModel *model in self.goodsArray) {
                [goodsDic setValue:[HTHoldNullObj getValueWithUnCheakValue:model.barcode] forKey:[HTHoldNullObj getValueWithUnCheakValue:model.productId]];
            }
            NSDictionary *postDic = @{
                                      @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                      @"orderId"  : self.orderId,
                                      @"logisticsCompany":model.companyCode,
                                      @"logisticsNo":self.logintisText.text,
                                      @"productsJsonStr":[goodsDic jsonStringWithDic],
                                      @"type":@1
                                      };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleLogistics,onlineOrderDelivery] params:postDic success:^(id json) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD hideHUD];
                if (![json[@"data"][@"state"] intValue]) {
                    [MBProgressHUD showError:json[@"data"][@"msg"]];
                }
                if ([json[@"data"][@"state"] intValue]) {
                    [MBProgressHUD showSuccess:json[@"data"][@"msg"]];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:SeverERRORSTRING];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查你的网络"];
            }];
            return;
        }
    }
    [MBProgressHUD showError:@"请确认运单号，完成快递公司验证"];
    
}
- (IBAction)cheakLogisticsClicked:(id)sender {
   
    NSDictionary *dic = @{
                          @"num":[HTHoldNullObj getValueWithUnCheakValue:self.logintisText.text],
                          @"key":tiantianKuaidiKey
                          };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:@"https://www.kuaidi100.com/autonumber/auto" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in arr) {
            if ([dic getStringWithKey:@"comCode"]) {
                HTLogisticsCompanyModle *model = [[DBManager shareManager] SeclectComanyNameWithString:[dic getStringWithKey:@"comCode"] ];
                if (arr.count == 1) {
                    model.isSelected = YES;
                }
                [self.dataArray addObject:model];
            }
        }
        if (arr.count == 0) {
            HTLogisticsCompanyModle *model =  [[HTLogisticsCompanyModle alloc] init];
            model.isSelected = YES;
            model.companyName = @"其他";
            model.companyCode = @"other";
            [self.dataArray addObject:model];
        }
        [self.tab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@""];
    }];
    
}
#pragma mark -private methods
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;
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
-(void)configSub{
    [self.backView changeCornerRadiusWithRadius:3];
    self.backView.layer.shadowOffset = CGSizeMake(5, 5);
    self.backView.layer.shadowOpacity = 0.18;
    self.backView.layer.shadowRadius = 5;
    self.backView.clipsToBounds = NO;
    [self.finishBt changeCornerRadiusWithRadius:3];
    self.labelTop.constant = 16 + nav_height;
    self.tab.dataSource = self;
    self.tab.delegate   = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTLogisticsCompanyCell" bundle:nil] forCellReuseIdentifier:@"HTLogisticsCompanyCell"];
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView  = vvv;
    self.tab.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.text = [NSString stringWithFormat:@"收件人：%@",[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.customer.name]];
}
#pragma mark - getters and setters

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
