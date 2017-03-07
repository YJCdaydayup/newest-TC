//
//  YLSocketManager.h
//  socket111
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@protocol YLSocketDelegate <NSObject>

-(void)ylSocketDidOpen:(SRWebSocket *)webSocket;
-(void)ylSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
-(void)ylSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
-(void)ylSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

@end

@interface YLSocketManager : NSObject<SRWebSocketDelegate>

@property (nonatomic,weak) id<YLSocketDelegate>delegate;
-(instancetype)initWithUrl:(NSString *)urlStr delegate:(id)delegate;
-(void)start;
-(void)stop;
-(void)sendMessage:(id)msg;

@end
