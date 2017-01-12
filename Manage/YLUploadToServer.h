//
//  YLUploadToServer.h
//  DianZTC
//
//  Created by 杨力 on 27/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"
#import "YLVoicemanagerView.h"

@class DBSaveModel;

@interface YLUploadToServer : NSObject
singleH(UploadToServer)

//购物车
@property (nonatomic,strong) NSTimer * uploadTimer;
@property (nonatomic,copy)   NSString * number;
@property (nonatomic,assign) NSInteger timer_count;
@property (nonatomic,assign) BOOL isClosed;
@property (nonatomic,strong) NSMutableArray * initialDataArray;

//收藏夹
@property (nonatomic,strong) NSTimer * save_uploadTimer;
@property (nonatomic,copy)   NSString * save_number;
@property (nonatomic,assign) NSInteger save_timer_count;
@property (nonatomic,assign) BOOL save_isClosed;
@property (nonatomic,strong) NSMutableArray * save_initialDataArray;

//购物车
-(void)batar_start;
-(void)batar_stop;

//收藏夹
-(void)batar_saveStart;
-(void)batar_saveStop;


@end
