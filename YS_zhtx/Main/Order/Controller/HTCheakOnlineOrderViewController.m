//
//  HTCheakOnlineOrderViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTScanTools.h"
#import "HTWriteBarcodeView.h"
#import "HTNewGoodsImgTableViewCell.h"
#import "HTCheakOnlineOrderViewController.h"
#import "HTOrderDetailModel.h"
#import "LPActionSheet.h"
#import "HTGetLogisticsInfController.h"
#import "NSString+upperOrlower.h"
@interface HTCheakOnlineOrderViewController ()<UITableViewDelegate,UITableViewDataSource,HTWriteBarcodeViewDelegate,HTScanCodeDelegate>

//判断重复扫描
@property (nonatomic,strong) NSString *holdBarcode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) HTWriteBarcodeView *whiteBarcode;

@property (nonatomic,strong) HTScanTools *scanTool;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *cheakBt;

@property (weak, nonatomic) IBOutlet UIButton *sendBt;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;

@property (nonatomic,assign) int  count;

@end

@implementation HTCheakOnlineOrderViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品核对";
    [self createTb];
    [self initNav];
    self.whiteBarcode.hidden = YES;
    [self scanTool];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#if defined (__i386__) || defined (__x86_64__)
    //模拟器下执行
#else
    [self.scanTool.session startRunning];
    //真机下执行
#endif
    [self setNavHidden];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.scanTool.session stopRunning];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewGoodsImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewGoodsImgTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productModel = self.dataArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

#pragma mark -CustomDelegate

/**
 移除编辑商品信息弹框
 
 @param alertView 弹框
 */
- (void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
}
/**
 处理扫码数据
 
 @param result 扫码所得条码
 */
-(void) handleScanResultStr:(NSString *) result{
    if ([result isEqualToString:self.holdBarcode]) {
        return;
    }
    self.holdBarcode = result;
    [self performSelector:@selector(clearStrWithStr:) withObject:result afterDelay:2];
    BOOL isBreak = NO;
    for (int i = 0 ; i < self.dataArray.count ; i++) {
        HTOrderDetailProductModel *model = self.dataArray[i];
        if (!model.isCheak) {
            if ([[model.barcode toLower:model.barcode] isEqualToString:[result toLower:result]]) {
                model.isCheak = YES;
                isBreak = YES;
                self.whiteBarcode.barcodeTextfiled.text = @"";
                [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:(self.dataArray.count - 1) - self.count];
                break;
            }
        }
    }
    if (!isBreak) {
        [MBProgressHUD showError:@"未找到相应商品"];
        return;
    }
    int i = 0 ;
    for (HTOrderDetailProductModel *mm in self.dataArray) {
        if (mm.isCheak) {
            i++;
        }
    }
    self.count = i;
    [self.cheakBt setTitle:[NSString stringWithFormat:@"已核对%d件",i] forState:UIControlStateNormal];
    [self.tab reloadData];
}
#pragma mark -EventResponse

- (IBAction)sendCicked:(id)sender {
     NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
    for (HTOrderDetailProductModel *model in self.dataArray) {
        if (!model.isCheak) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 尚未核对",model.barcode]];
            return;
        }
        [goodsDic setValue:[HTHoldNullObj getValueWithUnCheakValue:model.barcode] forKey:[HTHoldNullObj getValueWithUnCheakValue:model.productId]];
    }
    [LPActionSheet showActionSheetWithTitle:@"选择发货操作" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"无需物流",@"录入物流"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            [MBProgressHUD showMessage:@""];
            NSDictionary *postDic = @{
                                      @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                      @"orderId"  : self.orderId,
                                      @"productsJsonStr":[goodsDic jsonStringWithDic],
                                      @"type":@1
                                      };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleLogistics,onlineOrderDelivery] params:postDic success:^(id json) {
                [MBProgressHUD hideHUD];
                if (![json[@"data"][@"state"] intValue]) {
                    [MBProgressHUD showError:json[@"data"][@"msg"]];
                }
                if ([json[@"data"][@"state"] intValue]) {
                    [MBProgressHUD showSuccess:json[@"data"][@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:SeverERRORSTRING];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查你的网络"];
            }];
        }else if(index == 2){
            HTGetLogisticsInfController *vc = [[HTGetLogisticsInfController alloc] init];
            vc.orderId = self.orderId;
            vc.goodsArray = self.dataArray;
            vc.orderModel = self.orderModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
/**
 根据输入条码查询商品
 
 @param barcode 输入条码
 */
-(void)searchProductWithBarCode:(NSString *)barcode{
    [self.view endEditing:YES];
    BOOL isBreak = NO;
    for (int i = 0 ; i < self.dataArray.count ; i++) {
        HTOrderDetailProductModel *model = self.dataArray[i];
        if (!model.isCheak) {
            if ([[model.barcode toLower:model.barcode] isEqualToString:[barcode toLower:barcode]]) {
                model.isCheak = YES;
                isBreak = YES;
                self.whiteBarcode.barcodeTextfiled.text = @"";
                [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:self.dataArray.count - 1 - self.count];
                break;
            }
        }
    }
    if (!isBreak) {
        [MBProgressHUD showError:@"未找到相应商品"];
        return;
    }
    int i = 0 ;
    for (HTOrderDetailProductModel *mm in self.dataArray) {
        if (mm.isCheak) {
            i++;
        }
    }
    self.count = i;
    [self.cheakBt setTitle:[NSString stringWithFormat:@"已核对%d件",i] forState:UIControlStateNormal];
    [self.tab reloadData];
}
/**
 扫码与输入条码切换
 
 @param sender 扫码按钮
 */
-(void)starScanClicked:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"输入条码"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"扫条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
        self.whiteBarcode.hidden = NO;
        [self.scanTool.session stopRunning];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"输入条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
        self.whiteBarcode.hidden = YES;
        [self.scanTool.session startRunning];
    }
}
#pragma mark -private methods

-(void)loadData{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadOrderDetail] params:dic success:^(id json) {
        //        清除布局数
        self.orderModel = [HTOrderDetailModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.dataArray addObjectsFromArray:self.orderModel.product];
        [self.tab reloadData];
        [MBProgressHUD hideHUD];
    }  error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

-(void)clearStrWithStr:(NSString *)str{
    if ([str isEqualToString:self.holdBarcode]) {
        self.holdBarcode = nil;
    }
}
-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"输入条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewGoodsImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewGoodsImgTableViewCell"];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
}
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

#pragma mark - getters and setters

-(HTWriteBarcodeView *)whiteBarcode{
    if (!_whiteBarcode) {
        _whiteBarcode = [[NSBundle mainBundle] loadNibNamed:@"HTWriteBarcodeView" owner:nil options:nil].lastObject;
        _whiteBarcode.delegate = self;
        _whiteBarcode.frame = CGRectMake(0, 0, HMSCREENWIDTH , HMSCREENWIDTH * 9 / 16);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_whiteBarcode];
            self.tabTopHeight.constant = HMSCREENWIDTH * 9 / 16;
        });
    }
    return _whiteBarcode;
}

-(HTScanTools *)scanTool{
    if (!_scanTool ) {
        _scanTool = [[HTScanTools alloc] init];
        _scanTool.frame = CGRectMake(0, 0, HMSCREENWIDTH, HMSCREENWIDTH * 9 / 16);
        self.tabTopHeight.constant = HMSCREENWIDTH * 9 / 16;
        _scanTool.delegate = self;
        [_scanTool startScanInView:self.view];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫码线"]];
        imgview.center = CGPointMake(HMSCREENWIDTH * 0.5, HMSCREENWIDTH * 9 / 32);
        [self.view addSubview:imgview];
    }
    return _scanTool;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
