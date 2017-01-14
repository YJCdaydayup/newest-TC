//
//  NSTimer+Net.h
//  perform传递三个参数
//
//  Created by 杨力 on 20/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerBlock)();

@interface NSTimer (Net)

+(instancetype)scheduledTimerWithTimeInterval:(float)time repeats:(BOOL)repeat callback:(TimerBlock)block;
//+(void)timerAction:(NSTimer *)timer;

@end
