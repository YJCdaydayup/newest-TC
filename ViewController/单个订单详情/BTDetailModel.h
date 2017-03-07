//
//  BTDetailModel.h
//  DianZTC
//
//  Created by 杨力 on 28/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "JSONModel.h"
#import "BTDetailSubModel.h"

@interface BTDetailModel : JSONModel

@property (nonatomic,strong) NSMutableArray<BTDetailSubModel> * details;
@property (nonatomic,copy) NSString  * img;
@property (nonatomic,copy) NSString  * name;
@property (nonatomic,copy) NSString  * number;

@end
