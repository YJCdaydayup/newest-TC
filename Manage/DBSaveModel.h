//
//  DBSaveModel.h
//  DianZTC
//
//  Created by 杨力 on 4/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface DBSaveModel : NSObject

@property (nonatomic,copy) NSString * number;
@property (nonatomic,strong) id img;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * date;
@property (nonatomic,assign) BOOL selected;

@end
