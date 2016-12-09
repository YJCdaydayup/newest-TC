
//
//  NSTimer+Net.m
//  perform传递三个参数
//
//  Created by 杨力 on 20/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "NSTimer+Net.h"

@implementation NSTimer (Net)

+(instancetype)scheduledTimerWithTimeInterval:(float)time repeats:(BOOL)repeat callback:(TimerBlock)block{
    
    NSTimer * timer = [self scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAction:) userInfo:block repeats:repeat];
    return timer;
}

+(void)timerAction:(NSTimer *)timer{
    
    TimerBlock block = (TimerBlock)timer.userInfo;
    if(block){
        block();
    }
}


@end
