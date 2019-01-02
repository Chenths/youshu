//
//  HTCustomSearchView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSearchCustomerCreaterCell.h"
#import "HTOrderCreateDateTableCell.h"
#import "HTSearchPriceBetwenCell.h"
#import "HTSearchOrderStatusCell.h"
#import "HTOrderSearchCustomerTableCell.h"

#import "HTOrderSearchView.h"

@interface HTOrderSearchView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) UIView *coverView;


@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property (nonatomic,strong) UITextField *beginPrice;

@property (nonatomic,strong) UITextField *endPrice;



@end

@implementation HTOrderSearchView



#pragma mark -life cycel
+ (instancetype)initSearchWithFrame:(CGRect)frame
{
    HTOrderSearchView *searchV = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    [searchV setFrame:frame];
    [searchV initSubviews];
    return searchV;
}
+ (void)showSearchViewInViewDelegate:(id<HTOrderSearchViewDelegate>)delegate andSearchDic:(NSMutableDictionary *)searchDic{
    CGRect alrtFrame = CGRectMake(HMSCREENWIDTH, 0, HMSCREENWIDTH - 80, HEIGHT - SafeAreaBottomHeight);
    HTOrderSearchView *searchView = [self initSearchWithFrame:alrtFrame];
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
    
    if ([cellname isEqualToString:@"HTOrderCreateDateTableCell"]) {
        HTOrderCreateDateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderCreateDateTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTSearchPriceBetwenCell"]){
        
        HTSearchPriceBetwenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchPriceBetwenCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        self.beginPrice = cell.beginField;
        self.endPrice = cell.endField;
        return cell;
    }else if ([cellname isEqualToString:@"HTSearchCustomerCreaterCell"]){
        HTSearchCustomerCreaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchCustomerCreaterCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        cell.type = 1;
        cell.alertHidd = ^{
            self.hidden = YES;
            self.coverView.hidden = YES;
        };
        cell.alertShow = ^{
            self.hidden = NO;
            self.coverView.hidden = NO;
        };
        return cell;
    }else if ([cellname isEqualToString:@"HTSearchOrderStatusCell"]){
        HTSearchOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSearchOrderStatusCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchDic = self.searchDic;
        return cell;
    }else{
        HTOrderSearchCustomerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderSearchCustomerTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.alertttttHidd = ^{
            self.hidden = YES;
            self.coverView.hidden = YES;
        };
        cell.alerttttShow  = ^{
            self.hidden = NO;
            self.coverView.hidden = NO;
        };
        cell.searchDic = self.searchDic;
        return cell;
    }
   
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellsName.count;
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
    [self.searchDic removeAllObjects];
    [self.dataTableView reloadData];
}
- (IBAction)okBtClicked:(id)sender {
    [self.searchDic setObject:self.beginPrice.text forKey:@"model.finalprice_from"];
    [self.searchDic setObject:self.endPrice.text forKey:@"model.finalprice_to"];
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
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTOrderCreateDateTableCell" bundle:nil] forCellReuseIdentifier:@"HTOrderCreateDateTableCell"];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchPriceBetwenCell" bundle:nil] forCellReuseIdentifier:@"HTSearchPriceBetwenCell"];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchCustomerCreaterCell" bundle:nil] forCellReuseIdentifier:@"HTSearchCustomerCreaterCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTSearchOrderStatusCell" bundle:nil] forCellReuseIdentifier:@"HTSearchOrderStatusCell"];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTOrderSearchCustomerTableCell" bundle:nil] forCellReuseIdentifier:@"HTOrderSearchCustomerTableCell"];
    self.dataTableView.estimatedRowHeight = 300;
    
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

-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@"HTOrderCreateDateTableCell"];
        [_cellsName addObject:@"HTSearchPriceBetwenCell"];
        [_cellsName addObject:@"HTSearchOrderStatusCell"];
        [_cellsName addObject:@"HTOrderSearchCustomerTableCell"];
        [_cellsName addObject:@"HTSearchCustomerCreaterCell"];
    }
    return _cellsName;
}
@end
