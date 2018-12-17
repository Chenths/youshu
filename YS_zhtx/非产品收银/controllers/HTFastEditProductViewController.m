//
//  HTFastEditProductViewController.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTProductNormalTableViewCell.h"
#import "HTFastEditProductViewController.h"
#import "HTProductNumbersCell.h"
#import "HTProductSectedCategoryCell.h"
@interface HTFastEditProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HTFastEditProductViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑商品";
    [self createTb];
    [self createData];
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        HTProductSectedCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductSectedCategoryCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else if (indexPath.row == 3){
        HTProductNumbersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductNumbersCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
    HTProductNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductNormalTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = self.dataArray[indexPath.row];
    return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)deleteProductClicked:(id)sender {
    if (self.deleteProuct) {
        self.deleteProuct();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)okBtClicked:(id)sender {
    if (!self.editModel) {
        HTFastPrudoctModel *fastModel = [[HTFastPrudoctModel alloc] init];
        NSArray *keys = @[@"barcode",@"category",@"price",@"numbers",@"discount"];
        for (int i = 0; i < keys.count; i++) {
            HTEditFastProductModel *model = self.dataArray[i];
            if ([keys[i] isEqualToString:@"price"]) {
                if (model.value.length == 0) {
                    [MBProgressHUD showError:@"请输入产品吊牌价"];
                    return;
                }
            }
            if ([keys[i] isEqualToString:@"discount"]) {
                if (model.value.length > 0) {
                    if (model.value.floatValue <=0  || model.value.floatValue > 10) {
                        [MBProgressHUD showError:@"商品折扣范围应为0-10折"];
                    return;
                    }
                }
            }
            if ([keys[i] isEqualToString:@"category"]) {
                 [fastModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.value] forKey:@"categoryName"];
                 [fastModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.categoreId] forKey:@"categoryId"];
            }else{
                 [fastModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.value] forKey:keys[i]];
              }
        }
        if (self.selectedProductModel) {
            self.selectedProductModel(fastModel);
        }
    }else{
        NSArray *keys = @[@"barcode",@"category",@"price",@"numbers",@"discount"];
        for (int i = 0; i < keys.count; i++) {
            HTEditFastProductModel *model = self.dataArray[i];
            if ([keys[i] isEqualToString:@"price"]) {
                if (model.value.length == 0) {
                    [MBProgressHUD showError:@"请输入产品吊牌价"];
                    return;
                }
            }
            if ([keys[i] isEqualToString:@"discount"]) {
                if (model.value.length > 0) {
                    if (model.value.floatValue <=0  || model.value.floatValue > 10) {
                        [MBProgressHUD showError:@"商品折扣范围应为0-10折"];
                        return;
                    }
                }
            }
            if ([keys[i] isEqualToString:@"category"]) {
                [self.editModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.value] forKey:@"categoryName"];
                [self.editModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.categoreId] forKey:@"categoryId"];
            }else{
                [self.editModel setValue:[HTHoldNullObj getValueWithUnCheakValue:model.value] forKey:keys[i]];
            }
        }
        if (self.selectedProductModel) {
            self.selectedProductModel(self.editModel);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -private methods
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
 
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTProductNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTProductNormalTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTProductNumbersCell" bundle:nil] forCellReuseIdentifier:@"HTProductNumbersCell"];
     [self.dataTableView registerNib:[UINib nibWithNibName:@"HTProductSectedCategoryCell" bundle:nil] forCellReuseIdentifier:@"HTProductSectedCategoryCell"];
    self.dataTableView.tableFooterView = footView;

}
-(void)createData{
    NSArray *titles = @[@"商品条码",@"大类",@"吊牌价 *",@"数量",@"设置折扣"];
    NSArray *keys = @[@"barcode",@"categories",@"price",@"numbers",@"discount"];
    NSArray *values = self.editModel ? @[self.editModel.barcode,self.editModel.categoryName,self.editModel.price,self.editModel.numbers,self.editModel.discount] : @[@"",@"",@"",@"",@""];
     NSArray *sufs =  @[@"",@"",@"",@"",@"折"];
     NSArray *pre = @[@"",@"",@"￥",@"",@""];
//    UIKeyboardType
    NSArray *keyTypes = @[@(UIKeyboardTypeASCIICapable),@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad),@(UIKeyboardTypeNumberPad),@(UIKeyboardTypeDecimalPad)];
    for (int i = 0; i < titles.count; i++) {
        HTEditFastProductModel *model = [[HTEditFastProductModel alloc] init];
        model.title = titles[i];
        model.valueKey = keys[i];
        model.pre = pre[i];
        model.suf = sufs[i];
        model.value = values[i];
        if ([keys[i] isEqualToString:@"categories"]) {
            model.categoreId = self.editModel ? self.editModel.categoryId : @"";
        }
        NSNumber *type = keyTypes[i];
        model.keyBroardType = type.integerValue;
        [self.dataArray addObject:model];
    }
    [self.dataTableView reloadData];
}
#pragma mark - getters and setters

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
