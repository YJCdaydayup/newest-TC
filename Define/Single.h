//
//  Single.h
//  单例
//
//  Created by 杨力 on 20/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

//带参数的宏
#define singleH(name) +(instancetype)share##name;

#if __has_feature(objc_arc)
#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
    @synchronized(self) {\
        if(_instance == nil){\
            _instance = [super allocWithZone:zone];}\
    }\
    return _instance;\
}\
\
+(instancetype)share##name{\
    return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone{\
    return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone{\
    return _instance;\
}
#else
#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
@synchronized(self) {\
if(_instance == nil){\
_instance = [super allocWithZone:zone];}\
}\
return _instance;\
}\
\
+(instancetype)share##name{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone{\
return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone{\
return _instance;\
}\
-(oneway void)release{ \
} \
-(instancetype)retain{ \
    return _instance; \
} \
-(NSUInteger)retainCount{ \
    return MAXFLOAT; \
}
#endif
