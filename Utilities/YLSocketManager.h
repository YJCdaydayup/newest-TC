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

-(void)ylSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

@end

@interface YLSocketManager : NSObject<SRWebSocketDelegate>

@property (nonatomic,weak) id<YLSocketDelegate>delegate;
@property (nonatomic,strong) SRWebSocket *webSocket;

+(instancetype)shareSocketManager;
-(void)createSocket:(NSString *)url delegate:(id)delegate;
-(void)start;
-(void)stop;
-(void)sendMessage:(id)msg;
-(BOOL)isOpen;

@end
