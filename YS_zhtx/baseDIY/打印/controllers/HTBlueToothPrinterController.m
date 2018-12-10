//
//  HTBlueToothPrinterController.m
//  有术
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "HTBlueToothPrinterController.h"
#import "HTChoosePrintSizeCell.h"
#import "UIBarButtonItem+Extension.h"
#import "SEPrinterManager.h"
@interface HTBlueToothPrinterController ()<UITableViewDelegate,UITableViewDataSource,HTChoosePrintSizeDelegate>{
    SEPrinterManager *_manager;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSMutableArray *findedArray;

@property (nonatomic,strong) NSMutableArray  *seletedArray;

@property (weak, nonatomic) IBOutlet UIButton *printBt;

@property (nonatomic,assign) int  whichSize;


@end

@implementation HTBlueToothPrinterController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙打印";
    self.whichSize = 0;
    [ self createTb];
    _manager = [SEPrinterManager sharedInstance];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        [self.findedArray removeAllObjects];
        [self.findedArray addObjectsFromArray:perpherals];
        [self.dataTableView reloadData];
    } failure:^(SEScanError error) {
        if (error == SEScanErrorPoweredOff) {
            [MBProgressHUD showError:@"未打开蓝牙"];
        }else{
            [MBProgressHUD showError:@"搜索打印机失败"];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_manager stopScan];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            HTChoosePrintSizeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HTChoosePrintSizeCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.seletedSize = self.whichSize;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceeee"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceeee"];
            
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CBPeripheral *peripherral = [self.seletedArray objectAtIndex:indexPath.row];
            cell.textLabel.text = peripherral.name.length == 0 ? @"未知设备" : [NSString stringWithFormat:@"%@",peripherral.name];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceeee"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceeee"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CBPeripheral *peripherral = [self.findedArray objectAtIndex:indexPath.row];
            cell.textLabel.text = peripherral.name.length == 0 ? @"未知设备" : [NSString stringWithFormat:@"%@",peripherral.name];
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 40)];
    headView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.titleArray[section];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.leading.mas_equalTo(headView.mas_leading).offset(15);
        
    }];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        CBPeripheral *peripheral = [self.findedArray objectAtIndex:indexPath.row];
                  // 立刻去打印
            [MBProgressHUD showMessage:@"正在连接"];
            [[SEPrinterManager sharedInstance] fullOptionPeripheral:peripheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
                if (error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"连接失败"];
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"连接成功"];
                    if (stage == SEOptionStageSeekCharacteristics) {
                        NSData *mainData = [ self.whichSize == 0 ? self.smallPrinter : self.bigPrinter getFinalData];
                        NSLog(@"hhhhhhhhh%ld",mainData.length);
                        [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                            if (completion) {
                                [MBProgressHUD showSuccess:@"打印成功"];
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].loginModel.companyId,@"blueTooth"]];

                                [self->_manager  cancelPeripheral: perpheral];
                                [HTShareClass shareClass].printerModel = nil;
                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                if (self.pushNext) {
                                    self.pushNext();
                                }
                            }else{
                                [MBProgressHUD showError:error];
                                self.printBt.hidden = NO;
                            }
                        }];
                    }else{
                        self.printBt.hidden = NO;
                    }
                    [self.seletedArray removeAllObjects];
                    [self.seletedArray addObject:perpheral];
                    [self.dataTableView reloadData];
                }
            }];
    }
}
#pragma mark -CustomDelegate
- (void)choseThisSize:(int)size{
    self.whichSize = size;
}

#pragma mark -EventResponse

- (void)searchDeviec{
    [MBProgressHUD showMessage:@"正在搜索"];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        [MBProgressHUD hideHUD];
        [self.findedArray removeAllObjects];
        [self.findedArray addObjectsFromArray:perpherals ];
        [self.dataTableView reloadData];
    } failure:^(SEScanError error) {
        [MBProgressHUD hideHUD];
        if (error == SEScanErrorPoweredOff) {
            [MBProgressHUD showError:@"未打开蓝牙"];
        }else{
            [MBProgressHUD showError:@"搜索打印机失败"];
        }
    }];
}
- (void)cancleCliked{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.pushNext) {
        self.pushNext();
    }
}
- (IBAction)print:(id)sender {
    

        NSData *mainData = [ self.whichSize == 0 ? self.smallPrinter : self.bigPrinter getFinalData];
    
        [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
            if (completion) {
                [MBProgressHUD showSuccess:@"打印成功"];
                [_manager cancelPeripheral: [self.seletedArray firstObject]];
                [HTShareClass shareClass].printerModel = nil;
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                if (self.pushNext) {
                    self.pushNext();
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].loginModel.companyId,@"blueTooth"]];
            }else{
                [MBProgressHUD showError:error];
                self.printBt.hidden = NO;
            }
        }];
    
}

#pragma mark -private methods
- (void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    
    self.dataTableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"搜索蓝牙设备" target:self action:@selector(searchDeviec)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"取消" target:self action:@selector(cancleCliked)];
}



#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@[@"123123"]];
        [_dataArray addObject:self.seletedArray];
        [_dataArray addObject:self.findedArray];
    }
    return _dataArray;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:@"选择打印机尺寸"];
        [_titleArray addObject:@"已连接设备"];
        [_titleArray addObject:@"搜索到的设备"];
    }
    return _titleArray;
}
- (NSMutableArray *)seletedArray{
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _seletedArray;
}
- (NSMutableArray *)findedArray{
    if (!_findedArray) {
        _findedArray = [NSMutableArray array];
    }
    return _findedArray;
}



@end
