//
//  HTNewPayYHQViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTNewPayYHQViewController.h"
#import "HTNewPayYHQTableViewCell.h"
#import "HTNewPayYHQHeaderView.h"
#import "HTNewPayYHQMaskView.h"
@interface HTNewPayYHQViewController ()<UITableViewDelegate, UITableViewDataSource, YHQHeaderDelegate, YHQMaskViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) HTNewPayYHQHeaderView *header;
//0 都没点 1选中类型 2选中状态
@property (nonatomic, assign) NSInteger currentHeaderType;
@property (nonatomic, strong) HTNewPayYHQMaskView *maskView;
@property (nonatomic, assign) NSInteger selectedMaskIndexLeft;
@property (nonatomic, assign) NSInteger selectedMaskIndexRight;
@property (nonatomic, strong) NSArray *maskLeftArray;
@property (nonatomic, strong) NSArray *maskRightArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation HTNewPayYHQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [NSMutableArray array];
    _selectedMaskIndexLeft = 0;
    _selectedMaskIndexRight = 0;
    self.maskLeftArray = @[@"全部", @"折扣券", @"兑换券", @"代金券"];
    self.maskRightArray = @[@"全部", @"未使用", @"已使用", @"已过期"];
    [self initNav];
    self.page = 1;
    [self loadDataWithPage:self.page];
    [self buildUI];
    [self buildHeader];
}

- (void)showMask{
    if (!_maskView) {
        self.maskView = [[NSBundle mainBundle] loadNibNamed:@"HTNewPayYHQMaskView" owner:nil options:nil].lastObject;
        _maskView.frame = CGRectMake(0, 55, HMSCREENWIDTH, HEIGHT - 55);
        _maskView.delegate = self;
        _maskView.currentType = _currentHeaderType;
        if (_currentHeaderType == 1) {
            _maskView.selectedIndex = _selectedMaskIndexLeft;
        }else{
            _maskView.selectedIndex = _selectedMaskIndexRight;
        }
        [self.view addSubview:_maskView];
    }else{
        _maskView.hidden = NO;
        [_maskView removeFromSuperview];
        _maskView.frame = CGRectMake(0, 55, HMSCREENWIDTH, HEIGHT - 55);
        _maskView.delegate = self;
        _maskView.currentType = _currentHeaderType;
        if (_currentHeaderType == 1) {
            _maskView.selectedIndex = _selectedMaskIndexLeft;
        }else{
            _maskView.selectedIndex = _selectedMaskIndexRight;
        }
        [self.view addSubview:_maskView];
    }
}

- (void)YHQMaskViewDelegateSelectAciton:(NSInteger)type{
    if (_currentHeaderType == 1) {
        _selectedMaskIndexLeft = type;
        _header.leftLabel.text = _maskLeftArray[_selectedMaskIndexLeft];
    }else{
        _selectedMaskIndexRight = type;
        _header.rightLabel.text = _maskRightArray[_selectedMaskIndexRight];
    }
    [self showMask];
}

- (void)hideMask{
    _maskView.hidden = YES;
    self.page = 1;
    [self loadDataWithPage:self.page];
}

- (void)buildHeader{
    if (!_header) {
        self.header = [[NSBundle mainBundle] loadNibNamed:@"HTNewPayYHQHeaderView" owner:nil options:nil].lastObject;
        _header.frame = CGRectMake(0, 0, HMSCREENWIDTH, 55);
        _header.delegate = self;
        _header.selectType = 0;
        [self.view addSubview:_header];
    }else{
        if (_currentHeaderType == 0) {
            _header.selectType = 0;
        }else if(_currentHeaderType == 1){
            _header.selectType = 1;
        }else{
            _header.selectType = 2;
        }
    }
}

- (void)selectHeaderViewWithTag:(NSInteger)tag{
    if (tag == 0) {
        _currentHeaderType = 0;
        [self buildHeader];
        [self hideMask];
        
    }else{
        _currentHeaderType = tag;
        [self buildHeader];
        [self showMask];
    }
}

- (void)loadDataWithPage:(NSInteger)page{
    NSDictionary *dic = @{
                          @"customerId" : self.customerId,
                          @"type" : @(self.selectedMaskIndexLeft),
                          @"state" : @(self.selectedMaskIndexRight),
                          @"companyId" : @(self.companyId.integerValue),
                          @"pageNum" : @(self.page),
                          @"pageSize" : @(10)
                          };
    
    
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,getYHQList] params:dic success:^(id json) {
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"pageList"]) {
            HTYHQModel *tempModel = [HTYHQModel yy_modelWithJSON:dic];
            [self.dataArr addObject:tempModel];
        }
        
        [self.tb reloadData];
        [self.tb.mj_header endRefreshing];
        [self.tb.mj_footer endRefreshing];
    } error:^{
        self.page--;
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.tb.mj_header endRefreshing];
        [self.tb.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD showError:NETERRORSTRING];
        [self.tb.mj_header endRefreshing];
        [self.tb.mj_footer endRefreshing];
    }];
}

- (IBAction)touchBottomAction:(id)sender {
    NSLog(@"点击使用");
    if (_currentModel) {
        if (self.delegate) {
            [self.delegate HTChooseYHQListBackWithModel:_currentModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"请选择优惠券"];
    }
    
}

-(void)initNav{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"不使用" target:self action:@selector(cancelUse)];
    self.title = @"选择优惠券";
}

- (void)cancelUse{
    if (self.delegate) {
        [self.delegate HTChooseYHQListBackWithModel:[[HTYHQModel alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buildUI{
    [self.tb registerNib:[UINib nibWithNibName:@"HTNewPayYHQTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayYHQTableViewCell"];
    UIView *v = [[UIView alloc] init];
    self.tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        [self loadDataWithPage:self.page];
    }];
    self.tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadDataWithPage:self.page];
    }];
    v.frame = CGRectMake(0, 0, HMSCREENWIDTH, 60);
    v.backgroundColor = [UIColor clearColor];
    _tb.tableFooterView = v ;
    _tb.backgroundColor = [UIColor clearColor];
    _tb.estimatedRowHeight = 300;
    _tb.rowHeight = UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewPayYHQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayYHQTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count > 0) {
        HTYHQModel *tempModel = _dataArr[indexPath.row];
        if (tempModel.status == 1) {
            cell.yhqBG.image = [UIImage imageNamed:@"yhqYellow"];
            cell.maskImv.image = [UIImage imageNamed:@""];
            cell.kindLabel.textColor = [UIColor whiteColor];
            cell.moneyLabel.textColor = [UIColor whiteColor];
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.detailLabel.textColor = [UIColor whiteColor];
            cell.dateLabel.textColor = [UIColor whiteColor];
            cell.chooseImv.image = [UIImage imageNamed:@"unSelect"];
            cell.userInteractionEnabled = YES;
        }else if (tempModel.status == 2){
            cell.yhqBG.image = [UIImage imageNamed:@"yhqGray"];
            cell.maskImv.image = [UIImage imageNamed:@"yhqUsed"];
            cell.kindLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626262"];
            cell.dateLabel.textColor = [UIColor colorWithHexString:@"#626262"];
            cell.chooseImv.image = [UIImage imageNamed:@"noSelect"];
            cell.userInteractionEnabled = NO;
        }else{
            cell.yhqBG.image = [UIImage imageNamed:@"yhqGray"];
            cell.maskImv.image = [UIImage imageNamed:@"yhqTimeOut"];
            cell.kindLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#2E2F2F"];
            cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626262"];
            cell.dateLabel.textColor = [UIColor colorWithHexString:@"#626262"];
            cell.chooseImv.image = [UIImage imageNamed:@"noSelect"];
            cell.userInteractionEnabled = NO;
        }
        
        if (tempModel.type == 0) {
            cell.kindLabel.text = @"代金券";
            cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", tempModel.cashTicketAmt];
        }else if (tempModel.type == 1){
            cell.kindLabel.text = @"折扣券";
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f折", tempModel.discount];
        }else{
            cell.kindLabel.text = @"兑换券";
            cell.moneyLabel.text = @"--";
        }
        
        cell.titleLabel.text = tempModel.name;
        cell.detailLabel.text = tempModel.detail;
        cell.dateLabel.text = tempModel.expireDateString;
        if (tempModel.cardTemplateId == _currentModel.cardTemplateId) {
            cell.chooseImv.image = [UIImage imageNamed:@"selected"];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", indexPath.row);
    HTYHQModel *tempModel = _dataArr[indexPath.row];
    if (_currentModel.cardTemplateId == tempModel.cardTemplateId) {
        _currentModel = nil;
    }else{
        _currentModel = _dataArr[indexPath.row];
    }
    [tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
