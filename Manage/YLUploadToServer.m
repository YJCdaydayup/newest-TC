//
//  YLUploadToServer.m
//  DianZTC
//
//  Created by 杨力 on 27/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLUploadToServer.h"
#import "DBSaveModel.h"
#import "DBWorkerManager.h"
#import "NSTimer+Net.h"

@implementation YLUploadToServer
singleM(UploadToServer)

@synthesize timer_count = _timer_count;

-(instancetype)init{
    
    if(self = [super init]){
        
        self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES callback:^{
            [self batar_uploadOrdersToServer];
        }];
        
        self.save_uploadTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES callback:^{
           
            [self batar_uploadSaveToServer];
        }];
        
        [[NSRunLoop currentRunLoop]addTimer:self.uploadTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop]addTimer:self.save_uploadTimer forMode:NSRunLoopCommonModes];
        [self batar_stop];
        [self batar_saveStop];
        self.isClosed = YES;
        self.save_isClosed = YES;
    }
    return self;
}

-(void)batar_uploadSaveToServer{
    
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    [db_manager getAllObject:^(NSMutableArray *dataArray) {
        
        if(dataArray.count == 0){
            
            [self batar_saveStop];
            return ;
        }
        for(DBSaveModel * model in dataArray){
            @synchronized(self) {
                 _save_timer_count ++;
                [self addSave:model array:dataArray];
            }
        }
    }];
}

//停止上传收藏夹
-(void)batar_saveStop{
    
    [self.save_uploadTimer setFireDate:[NSDate distantFuture]];
    self.save_isClosed = YES;
}

//开始上传收藏夹
-(void)batar_saveStart{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    [manager getAllObject:^(NSMutableArray *dataArray) {
       
        self.save_initialDataArray = dataArray;
        [self.save_uploadTimer setFireDate:[NSDate distantPast]];
        _save_timer_count = 0;
        self.save_isClosed = NO;
    }];
}

//执行上传收藏夹
-(void)addSave:(DBSaveModel *)model array:(NSMutableArray *)dataArray{
    
    NetManager * netmanager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:AddSaveURL,[netmanager getIPAddress]];
    NSDictionary * dict = @{@"user":CUSTOMERID,@"number":model.number};
    [netmanager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            if(_save_timer_count == self.save_initialDataArray.count){
                //收藏夹上传完毕，停止计时器,清空本地收藏夹
                [self batar_saveStop];
                [self batar_cleanLocalSaveFile];
                NSLog(@"收藏夹上传完毕，停止计时器---%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

//清空本地收藏夹
-(void)batar_cleanLocalSaveFile{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    [manager cleanAllDBData];
}

-(void)batar_uploadOrdersToServer{
    
    NSLog(@"开始上传文字");
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    [db_manager order_getAllObject:^(NSMutableArray *dataArray) {
        
        if(dataArray.count==0){
            [self batar_stop];
            return ;
        }
        
        for(DBSaveModel * model in dataArray){
            
            [kUserDefaults setObject:model.number forKey:RECORDPATH];
            _timer_count ++;
            @synchronized(self) {
                [self addMyOrders:model array:dataArray];
            }
        }
    }];
}

-(void)batar_start{
    
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    [db_manager order_getAllObject:^(NSMutableArray *dataArray) {
        self.initialDataArray = dataArray;
        [self.uploadTimer setFireDate:[NSDate distantPast]];
        _timer_count = 0;
        self.isClosed = NO;
    }];
}

-(void)batar_stop{
    
    [self.uploadTimer setFireDate:[NSDate distantFuture]];
    self.isClosed = YES;
}

-(void)batar_deleteOrder{
    
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    [db_manager order_cleanAllDBData];
    
//    YLVoicemanagerView * voice_manager = [[YLVoicemanagerView alloc]initWithFrame:CGRectZero withVc:[UIView new]];
//    [voice_manager cleanAllVoiceAndTextData];
    //发出通知刷新购物车界面
    [[NSNotificationCenter defaultCenter]postNotificationName:AddShoppingCar object:nil];
}

//加入我的选购单
-(void)addMyOrders:(DBSaveModel *)model array:(NSMutableArray *)dataArray{
    
    self.number = model.number;
    //获取所有的语音数组
    YLVoicemanagerView * recordManager = [[YLVoicemanagerView alloc]initWithFrame:CGRectZero withVc:[UIView new]];
    NSMutableArray * reNameVoiceArray = [NSMutableArray array];
    NSMutableArray * voiceArray = [recordManager getAllVoiceMessages];
    for(int i = 0;i<voiceArray.count;i++){
        
        NSDictionary * dict = [voiceArray objectAtIndex:i];
        NSString * key = [[dict allKeys]lastObject];
        NSData * data = dict[key];
        
        NSString * newKey = [NSString stringWithFormat:@"%@@%@@%@.wav",CUSTOMERID,key,model.number];
        NSDictionary * newDict = @{newKey:data};
        [reNameVoiceArray addObject:newDict];
    }
    
    //获取所有的文字
    NetManager * netmanager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:UPLOADORDERCAR,[netmanager getIPAddress]];
    //    NSLog(@"%@",[recordManager getAllTextMessageStr]);
    NSDictionary * subDict;
    if([recordManager getAllTextMessageStr].count>0){
        subDict = @{@"number":model.number,@"customerid":CUSTOMERID,@"message":[self arrayToJson:[recordManager getAllTextMessageStr]]};
    }else{
        subDict = @{@"number":model.number,@"customerid":CUSTOMERID,@"message":@""};
    }
    
    [netmanager downloadDataWithUrl:urlStr parm:subDict callback:^(id responseObject, NSError *error) {
        
//        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if(responseObject){
            if(_timer_count == self.initialDataArray.count){
                if(reNameVoiceArray.count == 0){
                    [self batar_deleteOrder];
                    [self batar_stop];
                    NSLog(@"没有语音，删除本地，停止计时器");
                }else{
                    NSLog(@"开始上传语音，并停止计时器");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        [self sendVoiceToServer:reNameVoiceArray];
                        [self batar_stop];
                    });
                }
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)sendVoiceToServer:(NSMutableArray *)array{
    
    NetManager * manager = [NetManager shareManager];
    // 把语音数据（作为请求体）传过去
    AFHTTPSessionManager * fileManager = [AFHTTPSessionManager manager];
    fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    fileManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/octet-stream",@"application/x-www-form-urlencoded",@"text/plain",nil];
    NSString * voiceUrl = [NSString stringWithFormat:UPLOADVOICE,[manager getIPAddress]];
    [fileManager POST:voiceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //先将数据写入文件
        for(int i = 0;i<array.count;i++){
            
            NSDictionary * dict = array[i];
            NSString * fileName = [[dict allKeys]lastObject];
            NSData * data = [dict objectForKey:fileName];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            
            if(responseObject){
                NSLog(@"文字语音成功，删除本地");
                [self batar_deleteOrder];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

-(NSString *)arrayToJson:(NSMutableArray *)picArr{
    
    if (picArr && picArr.count > 0) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary * dict in picArr) {
            
            NSString * jsonText = [self dictionaryToJson:dict];
            [arr addObject:jsonText];
        }
        
        return [self objArrayToJSON:arr];
    }
    
    return nil;
}


#pragma mark -将字典转化成json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString*)myArrayToJson:(NSMutableArray *)array{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}


@end
