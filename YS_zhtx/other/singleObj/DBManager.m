//
//  DBManager.m
//  GiftComeGiftGo
//
//  Created by 成都千锋 on 15/10/22.
//  Copyright (c) 2015年 HX. All rights reserved.
//


#import "DBManager.h"
#import "FMDatabase.h"
@implementation DBManager
{
    FMDatabase *_fmdb;
    NSLock *_lock;
}
static DBManager *_dB = nil;
+ (DBManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_dB) {
            _dB = [[DBManager alloc] init];
        }
    });
    return _dB;
}
- (id)init{    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/app6.db"];
        _fmdb = [FMDatabase databaseWithPath:path];
        if ([_fmdb open]) {
           NSString *sql1 = @"CREATE TABLE express (companyName text NOT NULL,companyCode text NOT NULL,company_descri text NOT NULL,company_category text NOT NULL,nation_code text NOT NULL)";
            if ([_fmdb executeUpdate:sql1]) {
                
                NSString *backupDbPath = [[NSBundle mainBundle]
                                          pathForResource:@"express_code_data"
                                          ofType:@"txt"];
                NSString *str = [NSString stringWithContentsOfFile:backupDbPath encoding:NSUTF8StringEncoding error:nil];
                NSArray *sqlStrArr = [str componentsSeparatedByString:@";"];
                for (NSString *sqlStr in sqlStrArr) {
                    if (sqlStr.length > 0) {
                        [self insertGoodsWithString:sqlStr];
                    }
                }
            }else{
                NSLog(@"create Tabel Fail : %@",_fmdb.lastErrorMessage);
            }
        }
    }
    return self;
}


-(BOOL)insertGoodsWithString:(NSString *)str {
    [_lock lock];
    NSString *sql = str;
    BOOL isSuccess = [_fmdb executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"insert Success");
    }else{
        NSLog(@"insert Fail : %@",_fmdb.lastErrorMessage);
    }
    [_lock unlock];
    return isSuccess;
}
-(NSArray *)SeclectGoodsDataWithString:(NSString *) goodsStr{
    
    
//    NSString *sql = @"select * from barcodecheck where huohao = ? or barcode = ?";
//    FMResultSet *set = [_fmdb executeQuery:sql,goodsStr,goodsStr];
//    NSMutableArray *arr = [NSMutableArray new];
//    while ([set next]) {
//
//        barcodeModel *model = [[barcodeModel alloc] init];
//        [model setValuesForKeysWithDictionary:[set resultDictionary]];
//
//        [arr addObject:model];
//    }
    
    return @[];
}

-(HTLogisticsCompanyModle *)SeclectComanyNameWithString:(NSString *) companyCode{
    NSString *sql = @"select * from express where companyCode = ?";
    FMResultSet *set = [_fmdb executeQuery:sql,companyCode];
    while ([set next]) {
        HTLogisticsCompanyModle *model = [[HTLogisticsCompanyModle alloc] init];
        [model setValuesForKeysWithDictionary:[set resultDictionary]];
        return model;
    }
    return nil;
}

@end
