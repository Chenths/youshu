//
//  HTExplainViewController.m
//  有术
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTExplainModel.h"
#import "HTExplainViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface HTExplainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation HTExplainViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
#pragma mark -UITabelViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellll"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellll"];
    }
    HTExplainModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTExplainModel *model = self.dataArray[indexPath.row];
    if (model.subList.count > 0 && model.picUrlArr.count == 0) {
        HTExplainViewController *vc = [[HTExplainViewController alloc] init];
        vc.title = model.name;
        vc.dataArray = [model.subList mutableCopy];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSMutableArray *photos = [NSMutableArray array];
        for (NSString *url in model.picUrlArr) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url];
            [photos addObject:photo];
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate   = self;
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = footer;
}
#pragma mark - getters and setters

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
