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

@property (nonatomic,strong) NSTimer * uploadTimer;
@property (nonatomic,copy) NSString * number;
@property (nonatomic,assign) NSInteger timer_count;
@property (nonatomic,assign) BOOL isClosed;
@property (nonatomic,strong) NSMutableArray * initialDataArray;

-(void)batar_start;
-(void)batar_stop;

@end
