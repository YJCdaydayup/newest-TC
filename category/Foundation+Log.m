//
//  NSDictionary+Log.m
//  DianZTC
//
//  Created by 杨力 on 22/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

//所有的字典的打印
-(NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString * muStr = [NSMutableString string];
    
    //拼接字典的键值对
    [muStr appendString:@"\n{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [muStr appendString:[NSString stringWithFormat:@"%@:",key]];
        [muStr appendString:[NSString stringWithFormat:@"%@,",obj]];
    }];
    [muStr appendString:@"}"];
    
    NSRange range = [muStr rangeOfString:@"," options:NSBackwardsSearch];
    if(range.location != NSNotFound){
        [muStr deleteCharactersInRange:range];
    }
    return muStr;
}

@end

@implementation NSArray (Log)

-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString * muStr = [NSMutableString string];
    
    //拼接数组
    [muStr appendString:@"["];
    
   [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [muStr appendString:[NSString stringWithFormat:@"%@\n",obj]];
   }];
    
    [muStr appendString:@"]"];
    NSRange range = [muStr rangeOfString:@"," options:NSBackwardsSearch];
    if(range.location != NSNotFound){
        [muStr deleteCharactersInRange:range];
    }
    
    return muStr;
}

@end
