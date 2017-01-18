//
//  YLNetObseverManager.h
//  DianZTC
//
//  Created by 杨力 on 17/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum :NSInteger{
    
    BatarNetNotFound,
    BatarNetChangedUnknow,
    BatarNetChangeWWAN,
    BatarNetChangeWifi,
    
}BatarNetChangeType;

@protocol YLNetObseverDelegate <NSObject>

-(void)batarNetChange:(BatarNetChangeType)type;

@end

@interface YLNetObseverManager : NSObject

@property (nonatomic,assign) id<YLNetObseverDelegate>delegate;

+(instancetype)shareInstanceWithDelegate:(id)delegate;

@end
