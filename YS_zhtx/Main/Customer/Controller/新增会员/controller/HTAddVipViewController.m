//
//  HTAddVipViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTEditVipSexTypeCell.h"
#import "HTEditVipBirthTypeCell.h"
#import "HTEditVipCustLevelCell.h"
#import "HTEditVipDefaulTypeCell.h"
#import "HTEditVipHeadImgCell.h"
#import "HTAddVipViewController.h"
#import "HTTagsTableViewCell.h"
#import "HTNewTagsModel.h"
#import "HTAddTagsViewController.h"
#import "HTEditVipContinueBackListCell.h"
#import "HTEditVipManager.h"
#import "HTCustomerReportViewController.h"
#import "HTCustomTextAlertView.h"
#import "HTContinueBackModel.h"
#import "LPActionSheet.h"
#import "UIImage+Extension.h"
#import "HTLoginDataPersonModel.h"
#import "HTChooseHeadImgViewController.h"
#import "HTFaceImgListModel.h"
@interface HTAddVipViewController ()<UITableViewDelegate,UITableViewDataSource,HTTagsTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HTEditVipContinueBackListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet UIButton *saveBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBottomHeight;
//cells
@property (nonatomic,strong) NSMutableArray *cellsName;
//heads
@property (nonatomic,strong) NSMutableArray *headsTitle;
//标签列表
@property (nonatomic,strong) NSMutableArray *tags;

@property (nonatomic,strong) NSDictionary *tagDic;

@property (nonatomic,strong) NSArray *configs;

@property (nonatomic,strong) NSMutableDictionary *requestDic;

@property (nonatomic,strong) NSMutableArray  *backLists;

@property (nonatomic,strong) UIImage *selectedImg;

@property (nonatomic,strong) NSArray *selectedImgArray;


@end

@implementation HTAddVipViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加会员";
    self.configs = [HTEditVipManager configEditModels];
    [self createTb];
    [self configTag];
    [self loadConfig];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSArray *firstCells = [self.cellsName firstObject];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTEditVipDefaulTypeCell"]) {
        HTEditVipDefaulTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipDefaulTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTEditVipHeadImgCell"]){
        HTEditVipHeadImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipHeadImgCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.selectedImg) {
            cell.headImg = self.selectedImg;
        }else{
            cell.imgPath = [self.requestDic getStringWithKey:@"headimg"];
        }
        return cell;
    }else if ([cellname isEqualToString:@"HTEditVipCustLevelCell"]){
        HTEditVipCustLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipCustLevelCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTEditVipBirthTypeCell"]){
        HTEditVipBirthTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipBirthTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTTagsTableViewCell"]){
        HTTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTagsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isSeeMore = YES;
        cell.model = self.tags[indexPath.row];
        cell.delegate = self;
        return cell;
        
    }else if ([cellname isEqualToString:@"HTEditVipContinueBackListCell"]){
        HTEditVipContinueBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipContinueBackListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.backLists[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        HTEditVipSexTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipSexTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTEditVipHeadImgCell class]]) {
        if (![HTShareClass shareClass].face) {
            [LPActionSheet showActionSheetWithTitle:@"请选择您的操作" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"本地相册"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
                if (index == 1) {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])///<检测该设备是否支持拍摄
                    {
                        //                    [Tools showAlertView:@"sorry, 该设备不支持拍摄"];///<显示提示不支持
                        [MBProgressHUD showError:@"该设备不支持拍摄" toView:self.view];
                        return;
                    }
                    UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;///<设置数据来源为拍照
                    picker.allowsEditing = YES;
                    picker.delegate = self;///<代理设置
                    picker.navigationBar.translucent = NO;
                    [self presentViewController:picker animated:YES completion:nil];///<推出视图控制器
                }
                if (index == 2) {
                    UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
                    
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;///<设置数据来源为相册
                    //允许选择照片之后可编辑
                    picker.allowsEditing = YES;
                    picker.delegate = self;///<代理设置
                    picker.navigationBar.translucent = NO;;
                    [self presentViewController:picker animated:YES completion:nil];///<推出视图控制器
                }
            }];
        }else{
            //                选择人脸识别参照图片
            HTChooseHeadImgViewController *vc = [[HTChooseHeadImgViewController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.selectedImg = ^(NSArray *selectedArr) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.selectedImgArray = selectedArr;
                HTFaceImgListModel *model = [selectedArr firstObject];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                NSURL *imgUrl = [NSURL URLWithString:model.path];
                [manager diskImageExistsForURL:imgUrl completion:^(BOOL isInCache) {
                    if (isInCache) {
                        self.selectedImg =  [[manager imageCache] imageFromDiskCacheForKey:imgUrl.absoluteString];
                    }else{
                        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                        if (data) {
                            self.selectedImg = [UIImage imageWithData:data];
                        }
                    }
                    [strongSelf.tab reloadData];
                }];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
    title.text  = self.headsTitle[section];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithHexString:@"#222222"];
    [headView addSubview:title];
    NSString *titleText = self.headsTitle[section];
    if ([titleText isEqualToString:@"个性标签"] ||[titleText isEqualToString:@"跟进记录"]) {
        UIButton *addBt = [[UIButton alloc] initWithFrame:CGRectMake(HMSCREENWIDTH - 80, 0, 80, 44)];
        [addBt setImage:[UIImage imageNamed:@"g-goodsAdd"] forState:UIControlStateNormal];
        [addBt setTitle:@"" forState:UIControlStateNormal];
        addBt.tag = 500 + section;
        [addBt addTarget:self action:@selector(sectionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:addBt];
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headsTitle.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  section >= self.cellsName.count ? 0 : [self.cellsName[section] count];
}
#pragma mark - 相册/相机回调  显示所有的照片，或者拍照选取的照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    //获取编辑之后的图片
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImg = image;
    [self.tab reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//  取消选择 返回当前试图
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -CustomDelegate
-(void)addTagClicked{
    HTAddTagsViewController *vc = [[HTAddTagsViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.addTag = ^(NSDictionary *tag) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tagDic = tag;
        [strongSelf configTag];
    };
    if ([self.tagDic getArrayWithKey:@"companyTag"].count > 0 || [self.tagDic getArrayWithKey:@"stickTag"].count ) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray: [self.tagDic getArrayWithKey:@"stickTag"]];
        [arr addObjectsFromArray: [self.tagDic getArrayWithKey:@"companyTag"]];
        vc.tagsArray = arr;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)editTagCancelTopClickedWithDataDic:(NSDictionary *)dataDic{
    NSMutableArray *companyArr = [[self.tagDic getArrayWithKey:@"stickTag"] mutableCopy];
    [companyArr removeObject:dataDic];
    NSMutableArray *companyArr1 = [[self.tagDic getArrayWithKey:@"companyTag"] mutableCopy];
    [companyArr1 addObject:dataDic];
    NSMutableDictionary *mytagDic = [NSMutableDictionary dictionary];
    [mytagDic setValuesForKeysWithDictionary:self.tagDic];
    [mytagDic setObject:companyArr forKey:@"stickTag"];
    [mytagDic setObject:companyArr1 forKey:@"companyTag"];
    self.tagDic = mytagDic;
    [self configTag];
}
-(void)delteTagClickedWithDataDic:(NSDictionary *)dataDic{
    NSMutableArray *companyArr = [[self.tagDic getArrayWithKey:@"companyTag"] mutableCopy];
    [companyArr removeObject:dataDic];
    NSMutableDictionary *mytagDic = [NSMutableDictionary dictionary];
    [mytagDic setValuesForKeysWithDictionary:self.tagDic];
    [mytagDic setObject:companyArr forKey:@"companyTag"];
    self.tagDic = mytagDic;
    [self configTag];
}
-(void)editTagClickedWithDataDic:(NSDictionary *)dataDic{
    NSMutableArray *companyArr = [[self.tagDic getArrayWithKey:@"companyTag"] mutableCopy];
    [companyArr removeObject:dataDic];
    NSMutableArray *companyArr1 = [[self.tagDic getArrayWithKey:@"stickTag"] mutableCopy];
    [companyArr1 addObject:dataDic];
    NSMutableDictionary *mytagDic = [NSMutableDictionary dictionary];
    [mytagDic setValuesForKeysWithDictionary:self.tagDic];
    [mytagDic setObject:companyArr forKey:@"companyTag"];
    [mytagDic setObject:companyArr1 forKey:@"stickTag"];
    self.tagDic = mytagDic;
    [self configTag];
}

- (void)faceTypeSeemoreClickedWithCell:(HTTagsTableViewCell *)cell {
    
    
    
}
-(void)deleteContinueBackWithCell:(HTEditVipContinueBackListCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    [self.backLists removeObjectAtIndex:index.row];
    [self configBacksList];
}
#pragma mark -EventResponse
-(void)sectionBtClicked:(UIButton *)sender{
    
    NSInteger tag = sender.tag - 500;
    if (tag == 2) {
      [self addTagClicked];
    }
    if (tag == 3) {
        __weak typeof(self) weakSelf = self;
       [HTCustomTextAlertView showAlertWithTitle:@"客户跟进记录" holdTitle:@"请输入客户跟进记录" orTextString:nil okBtclicked:^(NSString * textValue) {
           __strong typeof(weakSelf) strongSelf = weakSelf;
           HTContinueBackModel *model = [[HTContinueBackModel alloc] init];
           model.desc = textValue;
           model.name = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.nickname];
           [strongSelf.backLists addObject:model];
           [strongSelf configBacksList];
        } andCancleBtClicked:^{
        }];
    }
}
- (IBAction)saveBtClicked:(id)sender {
    if ([HTShareClass shareClass].face) {
        if (self.selectedImgArray.count == 0) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"您未选择用户头像" btsArray:@[@"继续保存",@"选择头像"] okBtclicked:^{
                //                选择人脸识别参照图片
                HTChooseHeadImgViewController *vc = [[HTChooseHeadImgViewController alloc] init];
                __weak typeof(self) weakSelf = self;
                vc.selectedImg = ^(NSArray *selectedArr) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.selectedImgArray = selectedArr;
                    HTFaceImgListModel *model = [selectedArr firstObject];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    NSURL *imgUrl = [NSURL URLWithString:model.path];
                    [manager diskImageExistsForURL:imgUrl completion:^(BOOL isInCache) {
                        if (isInCache) {
                            self.selectedImg =  [[manager imageCache] imageFromDiskCacheForKey:imgUrl.absoluteString];
                        }else{
                            NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                            if (data) {
                                self.selectedImg = [UIImage imageWithData:data];
                            }
                        }
                        [strongSelf.tab reloadData];
                    }];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } cancelClicked:^{
                [self saveInfo];
            }];
            [alert show];
            return;
        }
    }
    [self saveInfo];
}
-(void)saveInfo{
    for (HTCustEditConfigModel *model in self.configs) {
        if (model.require) {
            if([self.requestDic getStringWithKey:model.SearchKey].length == 0){
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 为必填",model.title]];
                return;
            }
        }
    }
    if (self.custId.length > 0) {
        [self.requestDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.custId] forKey:@"cust.id"];
    }
    if (self.tagDic.allKeys.count != 0) {
        [self.requestDic setObject:[self.tagDic jsonStringWithDic] forKey:@"tags"];
    }
    [self.requestDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId] forKey:@"moduleId"];
    [self.requestDic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    if (self.selectedImg) {
        [self.requestDic setObject:[self.selectedImg getBase64Img] forKey:@"headImg"];
    }
    if (self.selectedImgArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (HTFaceImgListModel *model in self.selectedImgArray) {
            [arr addObject:model.HTFaceImgListModelid];
        }
        [self.requestDic setObject:[arr componentsJoinedByString:@","] forKey:@"imgIds"];
    }
    
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,addCust4App] params:self.requestDic success:^(id json) {
        
        if (self.backLists.count > 0) {
            //            已输入添加跟进记录，此处新增
            NSMutableArray *data = [NSMutableArray array];
            for (HTContinueBackModel *model in self.backLists) {
                [data addObject:model.desc];
            }
            NSDictionary *dic = @{
                                  @"followRecords":[data arrayToJsonString],
                                  @"model.customerId":[json[@"data"] getStringWithKey:@"modelId"],
                                  @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                                  @"model.name":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.nickname],
                                  };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,addFollowRecord] params:dic success:^(id json1) {
                [MBProgressHUD hideHUD];
                if ([[json1 getStringWithKey:@"state"] isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:[json1 getStringWithKey:@"msg"]];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"新增会员成功，添加跟进记录失败"]];
                }
                HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
                HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
                model.custId = [json[@"data"] getStringWithKey:@"modelId"];
                vc.model = model;
                vc.customerType = HTCustomerReportTypeNomal;
                [self.navigationController popViewControllerAnimated:NO];
                [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[NSString stringWithFormat:@"新增会员成功，添加跟进记录失败"]];
                HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
                HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
                model.custId = [json[@"data"] getStringWithKey:@"modelId"];
                vc.model = model;
                vc.customerType = HTCustomerReportTypeNomal;
                [self.navigationController popViewControllerAnimated:NO];
                [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[NSString stringWithFormat:@"新增会员成功，添加跟进记录失败"]];
                HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
                HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
                model.custId = [json[@"data"] getStringWithKey:@"modelId"];
                vc.model = model;
                vc.customerType = HTCustomerReportTypeNomal;
                [self.navigationController popViewControllerAnimated:NO];
                [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
            }];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"新增会员成功"];
            HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
            HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
            model.custId = [json[@"data"] getStringWithKey:@"modelId"];
            vc.model = model;
            vc.customerType = HTCustomerReportTypeNomal;
            [self.navigationController popViewControllerAnimated:NO];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = vvv;
    self.tab.estimatedRowHeight = 300;
    self.saveBottomHeight.constant = SafeAreaBottomHeight + 16;
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipDefaulTypeCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipDefaulTypeCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipCustLevelCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipCustLevelCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipBirthTypeCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipBirthTypeCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipSexTypeCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipSexTypeCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipHeadImgCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipHeadImgCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTagsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTagsTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipContinueBackListCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipContinueBackListCell"];
    [self.saveBt changeCornerRadiusWithRadius:3];
}
-(void)configTag{
    NSArray *keys = @[@"stickTag",@"companyTag",@"platformTag"];
    [self.tags removeAllObjects];
    for(int i = 0 ;i<keys.count ;i++){
        NSString *key = keys[i];
        HTNewTagsModel *model = [[HTNewTagsModel alloc] init];
        model.tagsArray = [self.tagDic getArrayWithKey:key];
        model.tageType = i + 1;
        model.tageState = HTTAGStateADD;
        model.isSeemore = YES;
        if (model.tagsArray.count > 0) {
            [self.tags addObject:model];
        }
        if ( model.tageType == HTTAGShop && model.tagsArray.count == 0 ) {
            [self.tags addObject:model];
        }
    }
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0;i < self.tags.count ; i++) {
        [arr addObject:@"HTTagsTableViewCell"];
    }
    [self.cellsName replaceObjectAtIndex:2 withObject:arr];
    [self.tab reloadData];
}
-(void)loadCust{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.custId]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCustomerInfo] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"data"] getDictionArrayWithKey:@"baseinfo"].allKeys.count > 0) {
            NSDictionary * baseInfo = [json[@"data"] getDictionArrayWithKey:@"baseinfo"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"birthday"] forKey:@"cust.birthday"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"nickname"] forKey:@"cust.nickname"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"phone"] forKey:@"cust.phone"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"sex"] forKey:@"cust.sex"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"headimg"] forKey:@"headimg"];
        }
        [MBProgressHUD hideHUD];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    }];
}
-(void)loadConfig{
    NSDictionary *dic = @{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadConfig4App] params:dic success:^(id json) {
        NSMutableDictionary *configs = [NSMutableDictionary dictionary];
        for (NSString *key in [json[@"data"] getDictionArrayWithKey:@"fieldMap"].allKeys) {
            [configs setObject:[[json[@"data"] getDictionArrayWithKey:@"fieldMap"] objectForKey:key] forKey:key];
        }
        for (NSString *key in [json[@"data"] getDictionArrayWithKey:@"virtualFieldMap"].allKeys) {
            [configs setObject:[[json[@"data"] getDictionArrayWithKey:@"virtualFieldMap"] objectForKey:key] forKey:key];
        }
        for (HTCustEditConfigModel *model in self.configs) {
            NSDictionary *dic = [configs getDictionArrayWithKey:model.configKey];
            model.require = [dic getStringWithKey:@"required"].boolValue;
            model.readOnly = [dic getStringWithKey:@"readonly"].boolValue;
            if ([model.configKey isEqualToString:@"phone_cust"]) {
                model.readOnly = YES;
            }
            if ([model.configKey isEqualToString:@"custLevel"]) {
                model.require = YES;
            }
        }
        if (self.phone) {
            [self.requestDic setObject:self.phone forKey:@"cust.phone"];
        }
        if (self.custId.length > 0) {
            [self loadCust];
        }else{
            [self.tab reloadData];
            [MBProgressHUD hideHUD];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    }];
}
-(void)configBacksList{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < self.backLists.count; i++) {
        [cells addObject:@"HTEditVipContinueBackListCell"];
    }
    if (self.cellsName.count >= 4 ) {
        [self.cellsName replaceObjectAtIndex:3 withObject:cells];
    }else{
        [self.cellsName addObject:cells];
    }
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:5];
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTEditVipHeadImgCell",@"HTEditVipDefaulTypeCell",@"HTEditVipDefaulTypeCell",@"HTEditVipSexTypeCell",@"HTEditVipBirthTypeCell"]];
        [self.headsTitle addObject:@"基本信息"];
        [_cellsName addObject:@[@"HTEditVipCustLevelCell",@"HTEditVipDefaulTypeCell",@"HTEditVipDefaulTypeCell",@"HTEditVipDefaulTypeCell"]];
        [self.headsTitle addObject:@"客户资料"];
        [_cellsName addObject:@[@"HTTagsTableViewCell"]];
        [self.headsTitle addObject:@"个性标签"];
        //        [_cellsName addObject:@[@"HTEditVipContinueBackListCell"]];
        [self.headsTitle addObject:@"跟进记录"];
    }
    return _cellsName;
}
-(NSMutableArray *)headsTitle{
    if (!_headsTitle) {
        _headsTitle = [NSMutableArray array];
    }
    return _headsTitle;
}
-(NSMutableArray *)tags{
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}
-(NSDictionary *)tagDic{
    if (!_tagDic) {
        _tagDic = [NSDictionary dictionary];
    }
    return _tagDic;
}
-(NSMutableDictionary *)requestDic{
    if (!_requestDic) {
        _requestDic = [NSMutableDictionary dictionary];
    }
    return _requestDic;
}
-(NSMutableArray *)backLists{
    if (!_backLists) {
        _backLists = [NSMutableArray array];
    }
    return _backLists;
}
- (NSArray *)selectedImgArray{
    if (!_selectedImgArray) {
        _selectedImgArray = [NSArray array];
    }
    return _selectedImgArray;
}
@end
