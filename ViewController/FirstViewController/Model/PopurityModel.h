//
//  PopurityModel.h
//  DianZTC
//
//  Created by 杨力 on 27/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface PopurityModel : JSONModel
//{
//    "image" : "160727091032460_fdf02dc36bd618fc357cb99f4fb34c40.jpg",
//    "index" : 1,
//    "name" : "吊坠",
//    "number" : "N10N10N30N40N5-N60N1/N50"
//}
@property (nonatomic,copy) NSString * image;
@property (nonatomic,copy) NSString * index;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * number;

@end
