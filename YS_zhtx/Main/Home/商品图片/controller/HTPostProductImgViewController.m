//
//  HTPostProductImgViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPostProductDescInfoCell.h"
#import "HTPostImgEditInfoTableViewCell.h"
#import "HTNotAddImgProductCell.h"
#import "HTPostProductImgViewController.h"

@interface HTPostProductImgViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@end

@implementation HTPostProductImgViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTPostProductDescInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTPostProductDescInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HTPostImgEditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTPostImgEditInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTPostProductDescInfoCell" bundle:nil] forCellReuseIdentifier:@"HTPostProductDescInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTPostImgEditInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTPostImgEditInfoTableViewCell"];

    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters

@end
