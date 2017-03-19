
//
//  YLSocketManager.m
//  socket111
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLSocketManager.h"
#import "BatarManagerTool.h"

@interface YLSocketManager(){
    
    NSString *_url;
    BOOL _forceClosed;
}

/** 断开后就启动计时器，重新连接三次 */
@property (nonatomic,strong) NSTimer * connectTimer;
@property (nonatomic,assign) NSInteger connectCount;

/** 每隔两秒请求一次 */
@property (nonatomic,strong) NSTimer *beatTimer;
@property (nonatomic,assign) NSInteger beatCount;
@property (nonatomic,strong) id mesg;

@end

@implementation YLSocketManager

+(instancetype)shareSocketManager{
    
    static YLSocketManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YLSocketManager alloc]init];
    });
    return instance;
}

-(void)createSocket:(NSString *)url delegate:(id)delegate{
    
    //每次连接之前先断开连接
    self.webSocket.delegate = nil;
    [self.webSocket close];
    _url = nil;
    
    self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:url]];
    _url = url;
    self.webSocket.delegate = self;
    self.delegate = delegate;
    [self.webSocket open];
    
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(openServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
    [self.connectTimer setFireDate:[NSDate distantFuture]];
    self.connectCount = 0;
}

-(void)sendMessage:(id)msg{
    
    @WeakObj(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if(selfWeak.webSocket.readyState == SR_OPEN){
            
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            [selfWeak.webSocket send:msg];
            
        }else if (selfWeak.webSocket.readyState == SR_CONNECTING){
            
            //开启计时器，检测是否连接上，连接上了才发送数据
            selfWeak.mesg = msg;
            selfWeak.beatTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkState) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.beatTimer forMode:NSRunLoopCommonModes];
            [selfWeak.beatTimer setFireDate:[NSDate distantPast]];
            
        }else if (selfWeak.webSocket.readyState == SR_CLOSED||selfWeak.webSocket.readyState== SR_CLOSING){
            //webSocket断开了，需要重新连接
            [self openServer];
        }
    });
}

#pragma mark - 每隔2s检测一次socket的状态
-(void)checkState{
    
    if(self.beatCount <10){
        
        if(self.webSocket.readyState == SR_OPEN){
            
            [self.webSocket send:self.mesg];
            [self stopTimer];
        }
    }else{
        NSLog(@"服务器错误，发送数据失败");
    }
    self.beatCount ++;
}

// 停止计时
- (void)stopTimer
{
    if (self.beatTimer) {
        [self.beatTimer invalidate];
        self.beatTimer = nil;
        self.beatCount = 0; // 清零计数
    }
}

-(void)closeServerByForce:(BOOL)force{
    
    _forceClosed = force;
    [self closeServer];
    
    //主动断开
    if(_forceClosed){
        
        //清空"待确认"订单角标
        SocketModel.state_0 = @0;
        SocketModel.state_1 = @0;
        SocketModel.state_2 = @0;
        [[NSNotificationCenter defaultCenter]postNotificationName:ServerMsgNotification object:nil];
        
        [BatarManagerTool caculateDatabaseOrderCar];
        
        return;
    }
}

// 关闭连接
- (void)closeServer
{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

// 建立连接
- (void)openServer
{
    self.connectCount ++;
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:_url]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    NSLog(@"第%zi次",self.connectCount);
}

//是否连接
-(BOOL)isOpen{
    
    if(self.webSocket.readyState == SR_OPEN){
        return YES;
    }else{
        return NO;
    }
}

#pragma SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    [self.connectTimer setFireDate:[NSDate distantFuture]];
    [self.delegate ylWebSocketDidOpen:webSocket];
    self.connectCount = 0;
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    message = (NSString *)message;
    if([message containsString:@"hello"]){
        
        NSString * heartBeatMsg = [NSString stringWithFormat:@"{\"\cmd\"\:%@,\"\message\"\:\"\%@\"\}",@"hello",CUSTOMERID];
        [webSocket send:heartBeatMsg];
        return;
    }
    
//    NSLog(@"收到消息,%@------%p",message,webSocket);
    BatarSocketModel * model = [BatarSocketModel shareBatarSocketModel];
    //将数据封装成模型
    NSMutableDictionary * dict = [self dictionaryWithJsonString:message];
    if([dict[@"type"]integerValue]==0){
        
        NSMutableDictionary * dict1 = [self dictionaryWithJsonString:dict[@"message"]];
        model.all = dict1[@"all"];
        model.state_0 = dict1[@"state_0"];
        model.state_1 = dict1[@"state_1"];
        model.state_2 = dict1[@"state_2"];
        
    }else{
        if([dict[@"message"]boolValue]==YES){
            //查看成功
            model.state_1 = @([model.state_1 integerValue]-1);
        }else{
            //查看失败
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:ServerMsgNotification object:nil];
    [self.delegate ylSocket:webSocket didReceiveMessage:message];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    sleep(5);
    webSocket.delegate = nil;
    [webSocket close];
    [self socketConnect];
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    
    webSocket.delegate = nil;
    [webSocket close];
    if(code == SRStatusCodeUnhandledType||code == SRStatusCodeUnhandledType)return;
    
    sleep(5);
    [self socketConnect];
}

#pragma 连接错误或者失败，启动计时器，重连三次
-(void)socketConnect{
    
    [self.connectTimer setFireDate:[NSDate distantPast]];
    if(self.connectCount<3){
        
    }else{
        [self closeServer];
        [self.connectTimer setFireDate:[NSDate distantFuture]];
        if (self.connectTimer) {
            [self.connectTimer invalidate];
            self.connectTimer = nil;
            self.connectCount = 0; // 清零计数
        }
    }
}

//将json字符串转字典
-(NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData                                                        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
