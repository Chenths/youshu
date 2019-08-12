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
@property (nonatomic, assign) NSInteger currentYHQ;
@end

@implementation HTNewPayYHQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [NSMutableArray array];
    _selectedMaskIndexLeft = 0;
    _selectedMaskIndexRight = 0;
    _currentYHQ = -1;
    self.maskLeftArray = @[@"全部", @"代金券", @"折扣券", @"兑换券"];
    self.maskRightArray = @[@"全部", @"未使用", @"已使用", @"已过期"];
    [self initNav];
    [self getData];
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

- (void)getData{
    
}

- (IBAction)touchBottomAction:(id)sender {
    NSLog(@"点击使用");
}

-(void)initNav{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"不使用" target:self action:@selector(cancelUse)];
    self.title = @"选择优惠券";
}

- (void)cancelUse{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buildUI{
    [self.tb registerNib:[UINib nibWithNibName:@"HTNewPayYHQTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayYHQTableViewCell"];
    UIView *v = [[UIView alloc] init];
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
    if (indexPath.row == _currentYHQ) {
        cell.chooseImv.image = [UIImage imageNamed:@"singleSelected"];
    }else{
        cell.chooseImv.image = [UIImage imageNamed:@"singleUnselected"];
    }
    cell.yhqArr = [NSMutableArray arrayWithArray:_dataArr];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", indexPath.row);
    if (_currentYHQ == indexPath.row) {
        _currentYHQ = -1;
    }else{
        _currentYHQ = indexPath.row;
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
