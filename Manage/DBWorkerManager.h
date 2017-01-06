//
//  DBWorkerManager.h
//  DianZTC
//
//  Created by 杨力 on 4/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"
#import "DBSaveModel.h"

typedef void(^DBSaveBlock)(NSMutableArray * dataArray);
typedef void(^DetailDataBlock)(id responseObject);
typedef void(^HistoryClearBlock)(BOOL clear);

@interface DBWorkerManager : NSObject
/*
 创建单例对象
 **/
+(instancetype)shareDBManager;
/*
 向数据库插入数据
 **/
-(void)insertInfo:(DetailModel *)model withData:(id)imgData withNumber:(NSString *)number;
/*
 获取数据库所有数据
 **/
-(void)getAllObject:(DBSaveBlock)block;
/*
 通过产品ID，移除数据库中的产品数据
 **/
-(void)cleanDBDataWithNumber:(NSString *)number;
/*
 清除所有数据库中的数据
 **/
-(void)cleanAllDBData;
/*
 收藏后，缓存到该id下的所有缓存二进制数据
 **/
-(void)saveDatailCache:(NSString *)number withData:(id)responseObject;
/*
 清除所有的收藏后的图片详情的图片缓存
 **/
-(void)cleanAllSavedImageDiskAndCache;
/*
 通过产品ID，获取到对应的缓存二进制数据
 **/
-(void)getAllDetailCache:(NSString *)number completion:(DetailDataBlock)block;
/*
 通过产品的ID，移除对应缓存数据
 **/
-(void)cleanDataCacheWithNumber:(NSString *)number;
/*
 移除收藏页面详情的所有缓存
 **/
-(void)cleanAllCache;
/*
 清除所有图片的缓存
 **/
+(void)cleanUpImageInCache;
/*
 清除所有图片硬盘里面的缓存
 **/
-(void)cleanUpImageInDishes;
/*
 获取缓存size
 **/
-(NSInteger)bt_getCacheSize;
/*
 根据numberID，判断某个产品是否已经被收藏
 **/
-(BOOL)bt_productIsBeenSaveWithNumberID:(NSString *)number;
/*
 判断收藏夹是否有数据
 **/
-(BOOL)judgeSaveFileExists;
/*
 加入我的购物车
 **/
-(void)order_insertInfo:(DetailModel *)model withData:(id)imgData withNumber:(NSString *)number;
/*
 获取我的购物车列表
 **/
-(void)order_getAllObject:(DBSaveBlock)block;
/*
 清空购物车数据库
 **/
-(void)order_cleanAllDBData;
/*
 加入后，缓存到该id下的所有缓存二进制数据
 **/
-(void)order_saveDatailCache:(NSString *)number withData:(id)responseObject;
/*
 加入购物车后，通过产品ID，获取到对应的缓存二进制数据
 **/
-(void)order_getAllDetailCache:(NSString *)number completion:(DetailDataBlock)block;
/*
加入购物车后，通过产品的ID，移除对应缓存详细数据
 **/
-(void)order_cleanDataCacheWithNumber:(NSString *)number;
/*
 加入购物车后，清除我的订购单数据库里面的数据
 **/
-(void)order_cleanDBDataWithNumber:(NSString *)number;


/*******************扫码历史数据********************/
-(void)createScanDB;
-(void)scan_insertInfo:(DetailModel *)model withData:(NSString *)imgUrl withNumber:(NSString *)number date:(NSString *)date;
-(void)scan_getAllObject:(DBSaveBlock)block;
-(void)scan_cleanAllDBData:(HistoryClearBlock)block;

@end
