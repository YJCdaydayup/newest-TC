//
//  YLVer_UpManager.h
//  DianZTC
//
//  Created by 杨力 on 5/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Picker_CheckUpdatedBlock)(BOOL isupdated);

@interface YLVer_UpManager : NSObject

-(void)compareVersionWithPlist:(Picker_CheckUpdatedBlock)block;

@end
