//
//  HTCustomSearchView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSearchBoxStylePlainTableViewCell.h"
#import "HTSearchBoxStyleBetweenTableViewCell.h"
#import "HTSearchCustomerCreaterCell.h"
#import "HTCustomerSearchPhoneTableCell.h"

#import "HTCustomSearchView.h"

@interface HTCustomSearchView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,assign) HTCustomSearchType serachType;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property (nonatomic,strong) UITextField *nameField;

@property (nonatomic,strong) UITextField *phoneField;



@end

@implementation HTCustomSearchView



#pragma mark -life cycel
+ (instancetype)initSearchWithFrame:(CGRect)frame
{
    HTCustomSearchView *searchV = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    [searchV setFrame:frame];
    [searchV initSubviews];
    return searchV;
}
+ (void)showSearchViewInViewDelegate:(id<HTCustomSearchViewDelegate>)delegate andSearchDic:(NSMutableDictionary *)searchDic{
    CGRect alrtFrame = CGRectMake(HMSCREENWIDTH, 0, HMSCREENWIDTH - 80, HEIGHT - SafeAreaBottomHeight);
    HTCustomSearchView *searchView = [self initSearchWithFrame:alrtFrame];
    searchView.delegate = delegate;
    searchView.searchDic = searchDic;
    [searchView createCoverViewWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, HEIGHT)];
    [[UIApplication sharedApplication].delegate.window addSubview:searchView.coverView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].delegate.window addSubview:searchView];
        [UIView animateWithDuration:0.3 animations:^{
            searchView.x = 80;
        }];
    });
    
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellname = self.cellsName[indexPath.row];
    if ([cellname isEqualToString:@"HTSearchBoxStyleBetweenTableViewCell"]) {
        HTSearchBoxStyleBetweenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchBoxStyleBetweenTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTSearchBoxStylePlainTableViewCell"]){
        HTSearchBoxStylePlainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchBoxStylePlainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        self.nameField = cell.textfiled;
        return cell;
    }else if ([cellname isEqualToString:@"HTSearchCustomerCreaterCell"]){
        HTSearchCustomerCreaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchCustomerCreaterCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.alertHidd = ^{
            self.hidden = YES;
            self.coverView.hidden = YES;
        };
        cell.alertShow = ^{
            self.hidden = NO;
            self.coverView.hidden = NO;
        };
        if (indexPath.row == 3) {
            cell.type = 1;
        }else{
            cell.type = 2;
        }
        cell.searchDic = self.searchDic;
        return cell;
    }else{
        HTCustomerSearchPhoneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerSearchPhoneTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        self.phoneField = cell.textField;
        
        return cell;
    }
   
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellsName.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse
- (void)tapCoverView{
    if (self.delegate) {
        [_coverView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            self.x = HMSCREENWIDTH;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self->_coverView removeFromSuperview];
        }];
    }
}
- (IBAction)resetClicked:(id)sender {
    [self.searchDic setObject:@"" forKey:@"model.creator"];
    [self.searchDic setObject:@"" forKey:@"creatorName"];
    [self.searchDic setObject:@"" forKey:@"model.birthday_cust_to"];
    [self.searchDic setObject:@"" forKey:@"model.birthday_cust_from"];
    [self.searchDic setObject:@"" forKey:@"model.nickname_cust"];
    [self.searchDic setObject:@"" forKey:@"model.phone_cust"];
    [self.searchDic setObject:@"" forKey:@"model.companyId_cust"];
    [self.searchDic setObject:@"" forKey:@"model.companyName_cust"];
    [self.dataTableView reloadData];
}
- (IBAction)okBtClicked:(id)sender {
    [self.searchDic setObject:self.nameField.text forKey:@"model.nickname_cust"];
    [self.searchDic setObject:self.phoneField.text forKey:@"model.phone_cust"];
    if (self.delegate) {
        [self.delegate searchOkBtClicked];
    }
    [self tapCoverView];
}
#pragma mark -private methods
-(void)initSubviews{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchBoxStyleBetweenTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSearchBoxStyleBetweenTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchBoxStylePlainTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSearchBoxStylePlainTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchCustomerCreaterCell" bundle:nil] forCellReuseIdentifier:@"HTSearchCustomerCreaterCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTCustomerSearchPhoneTableCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerSearchPhoneTableCell"];
    
}
- (void)createCoverViewWithFrame:(CGRect)frame{
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha  = 0.2;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView)];
    [_coverView addGestureRecognizer:tap];
}
#pragma mark - getters and setters
-(void)setSerachType:(HTCustomSearchType)serachType{
    _serachType = serachType;
    if (serachType == HTCustomSearchTypeCustomer) {
        
    }
}
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@"HTSearchBoxStylePlainTableViewCell"];
        [_cellsName addObject:@"HTCustomerSearchPhoneTableCell"];
        [_cellsName addObject:@"HTSearchBoxStyleBetweenTableViewCell"];
        [_cellsName addObject:@"HTSearchCustomerCreaterCell"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isShare = [defaults objectForKey:@"isShare"];
        if (isShare) {
            [_cellsName addObject:@"HTSearchCustomerCreaterCell"];
        }

    }
    return _cellsName;
}
@end
