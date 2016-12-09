//
//  STShareTool.h
//  STShareTool
//
//  Created by TangJR on 2/17/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const STShareTitleKey = @"STShareTitleKey"; ///< 分享标题的 key (title 是 NSString)
static NSString * const STShareImageKey = @"STShareImageKey"; ///< 分享图片的 key （传入的是字典，所以这个作为key）（image 是 UIImage）
static NSString * const STShareContentKey = @"STShareContentKey"; ///< 分享内容的 key （content 是 NSString）
static NSString * const STShareURLKey = @"STShareURLKey"; ///< 分享 url 的 key （url 是 NSString）

static NSString * const STShareURL = @"http://www.swift.gg"; ///< 分享的url，实际没用到，写在这占位

static NSString * const STShareQQAppId = @"1105775306";
static NSString * const STShareQQAppKey = @"W5Sx2uPFdle53RND";

static NSString * const STShareWeiboAppKey = @"";
static NSString * const STShareWeiboAppSecret = @"";
static NSString * const STShareWeiboCallbackURL = @"http://sns.whalecloud.com/sina2/callback"; ///< 微博回调的 url，就是微博申请高级信息里面那个

static NSString * const STShareWechatAppId = @"wx4808642f2b98a17d";
static NSString * const STShareWechatAppSecret = @"";

static NSString * const STShareUMAppKey = @"582af317f43e481729000e46";

@interface STShareTool : NSObject

@property (nonatomic, copy) dispatch_block_t success; ///< 成功回调
@property (nonatomic, copy) dispatch_block_t failure; ///< 失败回调

+ (instancetype)toolWithViewController:(UIViewController *)viewController;

+ (BOOL)canSendMail;

- (void)shareToQQ:(NSDictionary *)shareContent;
- (void)shareToQZone:(NSDictionary *)shareContent;
- (void)shareToWeChatSession:(NSDictionary *)shareContent;
- (void)shareToWeChatTimeline:(NSDictionary *)shareContent;
- (void)shareToWeibo:(NSDictionary *)shareContent;
- (void)shareToMail:(NSDictionary *)shareContent;

@end
