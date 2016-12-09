//
//  RecommandImageModel.h
//  DianZTC
//
//  Created by 杨力 on 25/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface RecommandImageModel : JSONModel

@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * img;
@property (nonatomic,copy) NSString * name;

@end
