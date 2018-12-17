//
//  HTBossSaleDescViewController.m
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#define SalecollectionViewContentOffset @"SalecollectionViewContentOffset"
#define Sale_topCollectionViewContentOffset @"saleTopCollectionViewContentOffset"
#import "HTBossSaleDescViewController.h"
#import "HTBossSaleCompareListInfoTableCell.h"
#import "HTBossSaleCopmareDateHeaderCell.h"
#import "HTBossRankReportDataModel.h"
#import "HcdDateTimePickerView.h"
#import "UIBarButtonItem+Extension.h"
@interface HTBossSaleDescViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *documentController;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (nonatomic,assign) CGPoint contentSet;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *timeArray;

@property (nonatomic,strong) NSString *year;

@property (nonatomic,strong) NSString *month;

@property (nonatomic,strong) UIButton *titleBt;

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSString *files;

@end

@implementation HTBossSaleDescViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    self.contentSet = CGPointMake(0, 0 );
    
}

#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTBossSaleCompareListInfoTableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HTBossSaleCompareListInfoTableCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.returnOFFset = ^(CGPoint point) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.contentSet = point;
        [strongSelf setContentOffSet:point];
        [strongSelf setTopOffSet:point];
    };
    HTBossRankReportDataModel *model = self.dataArray[indexPath.row];
    model.index = indexPath;
    cell.dataCollectionView.contentOffset =  self.contentSet;
    cell.title = self.rankState == HTRANKSTATEYEAR ? @"年" : @"月";
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
}
#pragma mark -UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.timeArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTBossSaleCopmareDateHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBossSaleCopmareDateHeaderCell" forIndexPath:indexPath];
    cell.rankState = self.rankState ;
    cell.dateStr = self.timeArray[indexPath.row];
    return cell;
}
#pragma mark -CustomDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.topCollectionView) {
        [self setContentOffSet:self.topCollectionView.contentOffset];
    }
}


#pragma mark -EventResponse
-(void)rightBtClicked:(UIButton *)sender{
    [self loadData1];
//    if (self.dataArray.count > 0 && self.timeArray.count > 0) {
//        // 创建存放XLS文件数据的数组
//        sender.enabled = NO;
//        [MBProgressHUD showMessage:@""];
//        NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
//        // 第一行内容
//        [xlsDataMuArr addObject:@"排行"];
//        [xlsDataMuArr addObject:@"店铺"];
//        [xlsDataMuArr addObject:@"总销售"];
//        for (NSString *str  in self.timeArray) {
//            if (self.rankState == HTRANKSTATEYEAR) {
//            if (str.length >= 7) {
//                NSString *year = [str  substringWithRange:NSMakeRange(0, 4)];
//                NSString *month = [str substringWithRange:NSMakeRange(5, 2)];
//                [xlsDataMuArr addObject:[NSString stringWithFormat:@"%@年%@月",year,month]];
//            }else{
//              [xlsDataMuArr addObject:str];
//            }
//
//            }else{
//             [xlsDataMuArr addObject:str];
//            }
//        }
//        NSMutableArray *sums = [NSMutableArray array];
//        CGFloat totleSum = 0.0f;
//        for (int i = 0;i < self.dataArray.count ; i++) {
//            HTBossRankReportDataModel *model = self.dataArray[i];
//            NSDictionary *tittleDic = model.title;
//            [xlsDataMuArr addObject:[NSString stringWithFormat:@"%d",i+1]];
//            [xlsDataMuArr addObject:[tittleDic getStringWithKey:@"name"]];
//            [xlsDataMuArr addObject:[NSString stringWithFormat:@"￥%@",[tittleDic getStringWithKey:@"price"]]];
//            totleSum += [tittleDic getFloatWithKey:@"price"];
//            for (int j = 0 ; j < model.datalist.count; j++) {
//              NSDictionary *dic = model.datalist[j];
//               [xlsDataMuArr addObject:[NSString stringWithFormat:@"￥%@",[dic getStringWithKey:@"price"]]];
//                if (i == 0) {
//                    [sums addObject:[dic getStringWithKey:@"price"]];
//                }else{
//                    NSString *last = sums[j];
//                    [sums replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%.0lf",([dic getFloatWithKey:@"price"] +  last.floatValue)]];
//                }
//            }
//        }
//        [xlsDataMuArr addObject:[NSString stringWithFormat:@"%ld",self.dataArray.count + 1]];
//        [xlsDataMuArr addObject:@"合计"];
//        [xlsDataMuArr addObject:[NSString stringWithFormat:@"￥%.0lf",totleSum]];
//        for (NSString *str  in sums) {
//            [xlsDataMuArr addObject:[NSString stringWithFormat:@"￥%@",str]];
//        }
//        // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
//        NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
//        // 字符串转换为可变字符串，方便改变某些字符
//        NSMutableString *muStr = [fileContent mutableCopy];
//        // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
//        NSMutableArray *subMuArr = [NSMutableArray array];
//        for (int i = 0; i < muStr.length; i ++) {
//            NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
//            if (range.length == 1) {
//                [subMuArr addObject:@(range.location)];
//            }
//        }
//        // 替换末尾\t
//        for (NSUInteger i = 0; i < subMuArr.count; i ++) {
//            if ( i > 0 && (i%(self.timeArray.count + 3) == 0) ) {
//                [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
//            }
//        }
//        // 文件管理器
//        NSFileManager *fileManager = [[NSFileManager alloc]init];
//        //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
//        NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
//        // 文件路径
//        NSString *path = NSHomeDirectory();
//        NSString *filePath = [path stringByAppendingPathComponent: [NSString stringWithFormat:@"/Documents/%@.xls",self.titleBt.titleLabel.text]];
////        NSLog(@"文件路径：\n%@",filePath);
//        // 生成xls文件
//        if ([fileManager createFileAtPath:filePath contents:fileData attributes:nil]) {
//            [MBProgressHUD hideHUD];
//            self.files = filePath;
//            sender.enabled = YES;
//            documentController =
//            [UIDocumentInteractionController
//             interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
//            documentController.delegate = self;
//            [documentController presentOpenInMenuFromRect:CGRectZero
//                                                   inView:self.view
//                                                 animated:YES];
//
//        }else{
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"生成文件失败，请稍后再试"];
//        }
//    }else{
//
//    }
  
    
}



-(void)documentInteractionController:(UIDocumentInteractionController *)controller
       willBeginSendingToApplication:(NSString *)application


{
    
}



-(void)documentInteractionController:(UIDocumentInteractionController *)controller
          didEndSendingToApplication:(NSString *)application
{
    
    if (self.files) {
        NSFileManager* fileManager=[NSFileManager defaultManager];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:self.files];
        if (!blHave) {
            return ;
        }else {
            NSLog(@" have");
            BOOL blDele= [fileManager removeItemAtPath:self.files error:nil];
            if (blDele) {
                NSLog(@"dele success");
            }else {
                NSLog(@"dele fail");
            }
        }
    }
}



-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller
{
}
-(void)headTitleClicked:(UIButton *)sender{
    if (self.isShow == YES) {
        return;
    }
    if (self.rankState == HTRANKSTATEMONTH) {
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerYearMonthMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (dateTimeStr.length >= 7) {
                strongSelf.year = [dateTimeStr substringWithRange:NSMakeRange(0, 4)];
                strongSelf.month = [dateTimeStr substringWithRange:NSMakeRange(5, 2)];
                [strongSelf.titleBt setTitle:[NSString stringWithFormat:@"%@年%@月销售",strongSelf.year,strongSelf.month] forState:UIControlStateNormal];
                strongSelf.isShow = NO;
                [strongSelf loadData];
            }
        };
        [self.view addSubview:dateTimePickerView];
        self.isShow = YES;
        [dateTimePickerView showHcdDateTimePicker];
    }
    

    if (self.rankState == HTRANKSTATEYEAR) {
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerYearMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (dateTimeStr.length >= 4) {
                strongSelf.year = [dateTimeStr substringWithRange:NSMakeRange(0, 4)];
                [strongSelf.titleBt setTitle:[NSString stringWithFormat:@"%@年销售",strongSelf.year] forState:UIControlStateNormal];
                strongSelf.isShow = NO;
                [strongSelf loadData];
            }
        };
        [self.view addSubview:dateTimePickerView];
        self.isShow = YES;
        [dateTimePickerView showHcdDateTimePicker];
    }
    
    
}
#pragma mark -private methods
-(void)shareExcelWithFile:(NSURL *)filePath{
    documentController =
    [UIDocumentInteractionController
     interactionControllerWithURL:filePath];
    documentController.delegate = self;
    [documentController presentOpenInMenuFromRect:CGRectZero
                                           inView:self.view
                                         animated:YES];
}
-(void)setContentOffSet:(CGPoint) offset{
    for (HTBossSaleCompareListInfoTableCell* cell in self.dataTableView.visibleCells) {
        cell.dataCollectionView.contentOffset = offset;
        }
}
-(void)setTopOffSet:(CGPoint)offSet{
    self.topCollectionView.contentOffset = offSet;
}
-(void)createUI{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake(HMSCREENWIDTH / 4, 58);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.topCollectionView.showsHorizontalScrollIndicator = NO;
    self.topCollectionView.showsVerticalScrollIndicator = NO;
    self.topCollectionView.collectionViewLayout = layout;
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    self.topCollectionView.backgroundColor = [UIColor colorWithHexString:@"#6A82FB"];
    [self.topCollectionView registerNib:[UINib nibWithNibName:@"HTBossSaleCopmareDateHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"HTBossSaleCopmareDateHeaderCell"];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossSaleCompareListInfoTableCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleCompareListInfoTableCell"];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.rankState == HTRANKSTATEMONTH) {
      [self.titleBt setTitle:[NSString stringWithFormat:@"%@年%@月销售",self.year,self.month] forState:UIControlStateNormal];
    }
    if (self.rankState == HTRANKSTATEYEAR) {
        [self.titleBt setTitle:[NSString stringWithFormat:@"%@年销售",self.year] forState:UIControlStateNormal];
    }
    [self.titleBt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
   
    [self.titleBt addTarget:self action:@selector(headTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleBt setImage:[UIImage imageNamed:@"剪头下"] forState:UIControlStateNormal];
     UIImage *img =  [UIImage imageNamed:@"剪头下"];
    [self.titleBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width, 0, img.size.width)];
    CGFloat width = [self.titleBt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:17]} context:nil].size.width + 10 ;
    [self.titleBt setImageEdgeInsets:UIEdgeInsetsMake(0, width, 0, -width)];
    self.navigationItem.titleView = self.titleBt;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"导出EXCEL" target:self action:@selector(rightBtClicked:)];
}

-(void)loadData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.year] forKey:@"year"];
    if (self.rankState == HTRANKSTATEMONTH) {
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.month] forKey:@"month"];
    }
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMonthReport,loadSalesRankingReport] params:dic success:^(id json) {
        
        if (self.dataArray.count > 0) {
            [self.timeArray removeAllObjects];
            [self.dataArray removeAllObjects];
        }
        NSArray *dataList = [[json getArrayWithKey:@"data"] count] > 0 ?  [[[json getArrayWithKey:@"data"] firstObject] getArrayWithKey:@"datalist"]: [NSArray array];
        for (NSDictionary *dicc in dataList) {
            [self.timeArray addObject:[dicc getStringWithKey:@"date"]];
        }
        
        for (NSDictionary*dict in [json getArrayWithKey:@"data"]) {
            HTBossRankReportDataModel *model = [[HTBossRankReportDataModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.topCollectionView reloadData];
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
-(void)loadData1{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.year] forKey:@"year"];
    if (self.rankState == HTRANKSTATEMONTH) {
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.month] forKey:@"month"];
    }
    [dic setObject:@"1" forKey:@"isDown"];
    [MBProgressHUD showMessage:@"正在导出"];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMonthReport,loadSalesRankingReport] params:dic success:^(id json) {
        [HTHttpTools downLoadUrl:[NSString stringWithFormat:@"%@",[json getStringWithKey:@"data"]] success:^(id json1) {
            [MBProgressHUD hideHUD];
            [self shareExcelWithFile:json1[@"file"]];
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        } WithlastName:[NSString stringWithFormat:@"%@.xls",self.titleBt.titleLabel.text]];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
#pragma mark - getters and setters

-(void)setContentSet:(CGPoint)contentSet{
    _contentSet = contentSet;
    [self setContentOffSet:contentSet];
    [self setTopOffSet:contentSet];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)timeArray{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}
-(NSString *)year{
    if (!_year) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY"];
        _year = [formatter stringFromDate:[NSDate date]];
    }
    return _year;
}
-(NSString *)month{
    if (!_month) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM"];
        _month = [formatter stringFromDate:[NSDate date]];
    }
    return _month;
}
@end
