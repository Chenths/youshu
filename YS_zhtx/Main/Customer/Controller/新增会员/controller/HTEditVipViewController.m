//
//  HTEditVipViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTEditVipSexTypeCell.h"
#import "HTEditVipBirthTypeCell.h"
#import "HTEditVipCustLevelCell.h"
#import "HTEditVipDefaulTypeCell.h"
#import "HTEditVipHeadImgCell.h"
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
#import "HTEditVipViewController.h"
#import "HTLoginDataPersonModel.h"
#import "HTChooseHeadImgViewController.h"
#import "HTFaceImgListModel.h"
#import "HTChangeHeadImgViewController.h"
#import "HTEditVipTipCell.h"
@interface HTEditVipViewController ()<UITableViewDelegate,UITableViewDataSource,HTTagsTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HTEditVipContinueBackListCellDelegate, EditVipTipsDelegate, UITextViewDelegate>
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

@property (nonatomic,assign) int  page;

@property (nonatomic,assign) BOOL hasHeaders;

@property (nonatomic,strong) NSArray *selectedImgArray;

@property (nonatomic, copy) NSString *textViewStr;

@end

@implementation HTEditVipViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑会员";
    self.configs = [HTEditVipManager configEditModels];
    [self createTb];
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
    }else if([cellname isEqualToString:@"HTEditVipSexTypeCell"]){
        HTEditVipSexTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipSexTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;
    }else{
        HTEditVipTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipTipCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.tipTextView.delegate = self;
//        cell.model = indexPath.section == 0 ? self.configs[indexPath.row - 1] : self.configs[(firstCells.count - 1) * indexPath.section + indexPath.row];
        cell.requestDic = self.requestDic;
        return cell;

    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"fuck");
    _textViewStr = textView.text;
    return YES;
}

- (void)editVipTipsEndDelegate:(NSString *)tips{
    _textViewStr = tips;
}

- (void)editTipAction{
        NSDictionary *dic = @{
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                              @"remark" :[HTHoldNullObj getValueWithUnCheakValue:_textViewStr]
                              };
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,@"admin/api/cust/",@"update_customer_remark_4_app.html"] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            [self saveInfo];
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查你的网络"];
        }];
    
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
            if (self.hasHeaders) {
                HTChangeHeadImgViewController *vc = [[HTChangeHeadImgViewController alloc] init];
                vc.uid = self.modelId;
                vc.headUrl = [self.requestDic getStringWithKey:@"headimg"];
                vc.headImg = ^(UIImage *headImg) {
                    self.selectedImg = headImg;
                    [self.tab reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
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
    vc.addText = ^{
//  刷新tags
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadtags];
    };
    vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.modelId];
    vc.modulId = [HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)editTagCancelTopClickedWithDataDic:(NSDictionary *)dataDic{
//    请求网络取消置顶
    NSDictionary *dic = @{
                          @"id":[dataDic getStringWithKey:@"id"],
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,removeTagStick4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [self loadtags];
            [MBProgressHUD showSuccess:@"取消成功"];
        }else{
            [MBProgressHUD showSuccess:[json getStringWithKey:@"msg"]];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}
-(void)delteTagClickedWithDataDic:(NSDictionary *)dataDic{
//    请求网络删除
   
    NSDictionary *dic = @{
                          @"tagRelationId":[dataDic getStringWithKey:@"id"],
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,removeTagRelationInfo4App] params:dic success:^(id json) {
         [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [self loadtags];
            [MBProgressHUD showSuccess:[json getStringWithKey:@"msg"]];
        }else{
           
            [MBProgressHUD showSuccess:[json getStringWithKey:@"msg"]];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}
-(void)editTagClickedWithDataDic:(NSDictionary *)dataDic{
//    请求网络置顶
    
    NSDictionary *dic = @{
                          @"tagId":[dataDic getStringWithKey:@"tagid"],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"modelId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,moveTagToTop] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [self loadtags];
            [MBProgressHUD showSuccess:@"置顶成功"];
        }else{
            [MBProgressHUD showSuccess:[json getStringWithKey:@"msg"]];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}

- (void)faceTypeSeemoreClickedWithCell:(HTTagsTableViewCell *)cell {
    
}
-(void)deleteContinueBackWithCell:(HTEditVipContinueBackListCell *)cell{
//    请求网络删除
    if (self.backLists.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否删除此跟进记录" btsArray:@[@"取消",@"确认"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
          NSIndexPath *index = [strongSelf.tab indexPathForCell:cell];
        HTContinueBackModel *model = strongSelf.backLists[index.row];
        [MBProgressHUD showMessage:@""];
        NSDictionary *dic = @{
                              @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                              @"modelId":[HTHoldNullObj getValueWithUnCheakValue:model.modelId],
                              @"model.is_del":@"1"
                              };
    
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,remove4app] params:dic success:^(id json) {
            if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"1"]) {
                self.page = 1;
                [strongSelf loadBackListWithPage:self.page];
            }
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    } cancelClicked:^{
    }];
    [alert show];
//    [self.backLists removeObjectAtIndex:index.row];
//    [self configBacksList];
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
            NSDictionary *dic = @{
                                  @"followRecords":[@[model.desc] arrayToJsonString],
                                  @"model.customerId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                                  @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                                  @"model.name":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.nickname],
                                  };
            [MBProgressHUD showMessage:@""];
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,addFollowRecord] params:dic success:^(id json1) {
                [MBProgressHUD hideHUD];
                if ([[json1 getStringWithKey:@"state"] isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"添加跟进记录成功"];
                    [strongSelf.backLists addObject:model];
                    [strongSelf configBacksList];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"添加跟进记录失败"]];
                }
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[NSString stringWithFormat:@"添加跟进记录失败"]];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[NSString stringWithFormat:@"添加跟进记录失败"]];
            }];
        } andCancleBtClicked:^{
        }];
    }
}

/**
 保存接口

 @param sender 保存按钮
 */
- (IBAction)saveBtClicked:(id)sender {
    if ([HTShareClass shareClass].face && !self.hasHeaders) {
        if (self.self.selectedImgArray.count == 0) {
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
                [self editTipAction];
            }];
            [alert show];
            return;
        }
    }
    [self editTipAction];
    
}

#pragma mark -private methods
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
    [self.requestDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId] forKey:@"moduleId"];
    [self.requestDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.modelId] forKey:@"modelId"];
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
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,editModel4App] params:self.requestDic success:^(id json) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"编辑会员成功"];
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
        model.custId = [HTHoldNullObj getValueWithUnCheakValue:self.modelId ];
        vc.model = model;
        [self.navigationController popViewControllerAnimated:NO];
//        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
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
    [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipTipCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipTipCell"];
    [self.saveBt changeCornerRadiusWithRadius:3];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadBackListWithPage:self.page];
    }];
}

/**
 根据标签数据配置cells
 */
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
/**
 请求原始数据
 */
-(void)loadCust{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"id":[HTHoldNullObj getValueWithUnCheakValue:self.modelId]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCustomerInfo] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"data"] getDictionArrayWithKey:@"baseinfo"].allKeys.count > 0) {
            NSDictionary * baseInfo = [json[@"data"] getDictionArrayWithKey:@"baseinfo"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"birthday"] forKey:@"cust.birthday"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"nickname"] forKey:@"cust.nickname"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"phone"] forKey:@"cust.phone"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"sex"] forKey:@"cust.sex"];
            [self.requestDic setObject:[baseInfo getStringWithKey:@"custid"] forKey:@"cust.id"];
        }
        if ([json[@"data"] getDictionArrayWithKey:@"cust"].allKeys.count > 0) {
            NSDictionary * baseInfo = [json[@"data"] getDictionArrayWithKey:@"cust"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"custleveldata"] forKey:@"model.custLevel_json"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"height"] forKey:@"model.height"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"hobby"] forKey:@"model.hobby"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"name"] forKey:@"model.name"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"headimg"] forKey:@"headimg"];
            [self.requestDic setObject:[baseInfo  getStringWithKey:@"remark"] forKey:@"remark"];
        }
        self.hasHeaders = [json[@"data"][@"hasHeaders"] boolValue];
        self.tagDic = [json[@"data"] getDictionArrayWithKey:@"tags"];
        self.page = 1;
        [self configTag];
        [self loadBackListWithPage:self.page];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    }];
}
/**
 请求权限配置
 */
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
        }
        if (self.phone) {
            [self.requestDic setObject:self.phone forKey:@"cust.phone"];
        }
        if (self.modelId.length > 0) {
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

/**
 请求回访记录

 @param page 页数
 */
-(void)loadBackListWithPage:(int)page{
    NSDictionary *dic = @{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                          @"model.customerId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                          @"page":@(page),
                          @"rows":@"10"
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadList4App] params:dic success:^(id json) {
        if (self.page == 1) {
            [self.backLists removeAllObjects];
        }
        if ([[json[@"data"] getArrayWithKey:@"rows"] count] == 0 && self.page != 1) {
            [MBProgressHUD hideHUD];
            [self.tab.mj_footer endRefreshing];
            self.page--;
            return ;
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTContinueBackModel *model = [HTContinueBackModel yy_modelWithJSON:dic];
            [self.backLists addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self configBacksList];
    } error:^{
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD  showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD  showError:NETERRORSTRING];
    }];
}
-(void)loadtags{

    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"modelId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,loadTagByCustomer4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.tagDic = [json getDictionArrayWithKey:@"data"];
        [self configTag];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
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
        [_cellsName addObject:@[@"HTEditVipCustLevelCell",@"HTEditVipDefaulTypeCell",@"HTEditVipDefaulTypeCell",@"HTEditVipDefaulTypeCell", @"HTEditVipTipCell"]];
        [self.headsTitle addObject:@"客户资料"];
        [_cellsName addObject:@[@"HTTagsTableViewCell"]];
        [self.headsTitle addObject:@"个性标签"];
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
-(NSString *)customerFollowRecordId{
    if (!_customerFollowRecordId) {
        for (HTMenuModle *mm in [HTShareClass shareClass].menuArray) {
            if ([mm.moduleName isEqualToString:@"customerFollowRecord"]) {
                _customerFollowRecordId = [HTHoldNullObj getValueWithUnCheakValue:mm.moduleId];
                break;
            }
        }
    }
    return _customerFollowRecordId;
    
}
@end
