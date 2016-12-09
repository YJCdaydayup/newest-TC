//
//  HeaderModel.h
//  DianZTC
//
//  Created by 杨力 on 12/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface HeaderModel : JSONModel

@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy) NSString * orderid;

@end
