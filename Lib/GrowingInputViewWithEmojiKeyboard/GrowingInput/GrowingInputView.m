
#import "GrowingInputView.h"

#import "HPGrowingTextView.h"
#import "HPTextViewInternal.h"
#import "AGEmojiKeyboardView.h"


static const CGFloat GrowingInputView_Height = 45.0f;

@interface GrowingInputView () <
    HPGrowingTextViewDelegate,
    UIGestureRecognizerDelegate,
    AGEmojiKeyboardViewDelegate,
    AGEmojiKeyboardViewDataSource
    >
{
    NSInteger _keyboardHeight;
    
    UIPanGestureRecognizer *_panRecognizer;
    
    
    UIColor *_tipLabelNormalFontColor;
    UIColor *_tipLabelErrorFontColor;
    
    AGEmojiKeyboardView *_emojiKeyboardView;
    
}

@property (nonatomic, weak) IBOutlet UIButton *emojiBtn;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet HPGrowingTextView *growingTextView;
@property (nonatomic, weak) IBOutlet UIButton *sendBtn;
@property (nonatomic, weak) IBOutlet UILabel *tipLable;

@property (nonatomic, assign) NSInteger maxInputCount;
@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) GrowingInputType growingInputType;

@end

static NSInteger INPUT_COUNT_WHEN_TIP_LABLE_DISPLAY = 10;
static NSInteger MAX_INPUT_COUNT = 140;

@implementation GrowingInputView

- (void)dealloc
{
    [self releaseRecognizer];
    [self unregisterNotifications];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    // 1.UI
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GrowingInputView" owner:self options:nil];
    UIView *subview = [array objectAtIndex:0];
    self.bounds = subview.bounds;
    [self addSubview:subview];
    [self initGrowingTextView];
    
    // 2.Var
    self.maxInputCount = MAX_INPUT_COUNT;
    
    // 3.Others
    [self createRecognizer];
    
    // 4.
    [self changeLeftInputCount:self.growingTextView.text.length];
    
    // 5.
    self.growingTextView.backgroundColor = [UIColor whiteColor];
    
    // 6.
    // social_icon_emoji.png & social_icon_keyboard.png
    self.growingInputType = GrowingInputType_Text;
    self.growingTextView.internalTextView.inputView = nil;
    _emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216) dataSource:self];
    _emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _emojiKeyboardView.delegate = self;
    
    [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
}

#pragma mark - Private Init

- (void)initGrowingTextView
{
    self.growingTextView.delegate = self;
    
    [_contentView.layer setCornerRadius:6.0];
    [_contentView.layer setBorderWidth:1.0];
    [_contentView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
}

- (void)createRecognizer
{
    [self releaseRecognizer];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resignFromInput:)];
    _panRecognizer.delegate = self;
}

- (void)releaseRecognizer
{
    [self removeRecognizer];
    _panRecognizer = nil;
    
}

- (void)addRecognizer
{
    [self removeRecognizer];
    if (_panRecognizer) {
        [_parentView addGestureRecognizer:_panRecognizer];
    }
    }

- (void)removeRecognizer
{
    if (_panRecognizer) {
        [_parentView removeGestureRecognizer:_panRecognizer];
    }
    
}
//注册键盘事件通知
- (void)registerNotifications
{
    [self unregisterNotifications];
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
//    [defaultCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}


#pragma mark - Public
- (void)setPlaceholder:(NSString *)placeholder
{
    self.growingTextView.placeholder = placeholder;
    [self setNeedsDisplay];
}

- (NSString *)placeholder:(NSString *)placeholder
{
    return self.growingTextView.placeholder;
}

- (void)setText:(NSString *)text
{
    self.growingTextView.text = text;
    [self changeLeftInputCount:text.length];
}

- (NSString *)text
{
    return self.growingTextView.text;
}

- (void)setMinNumberOfLines:(NSInteger)minNumberOfLines
{
    _growingTextView.minNumberOfLines = 1;
}

- (void)resetInput
{
    self.text = @"";
//    [self.growingTextView resignFirstResponder];
    [self.growingTextView refreshHeight];
}

+ (CGFloat)defaultHeight
{
    return GrowingInputView_Height;
}

- (void)activateInput
{
    if (![self.growingTextView isFirstResponder]) {
        [self.growingTextView becomeFirstResponder];
    }
}

- (void)deactivateInput
{
    [self resetInput];
    [self unregisterNotifications];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSInteger length = growingTextView.text.length;
    [self changeLeftInputCount:length];
    _growingTextView.displayPlaceholder = (length == 0);

}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextView *textView = growingTextView.internalTextView;
    //输入\n会触发发送按钮
    if ([text isEqualToString:@"\n"]) {
        if ([self notifySendBtnClicked]) {
            [self resetInput];
        }
        return NO;
    }
    
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger length = str.length;
    
    [self changeLeftInputCount:length];
    
    return YES;
}
//高度改变
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
    
    [self notifyHeight:nil];
}
//开始编辑
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    
    [self addRecognizer];
    [self registerNotifications];

    self.hidden = NO;

    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
            return [_delegate growingTextViewShouldBeginEditing:self];
        }
    }
    return YES;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{

}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [self removeRecognizer];
    
    _growingTextView.displayPlaceholder = !(growingTextView.text.length > 0);
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
            return [_delegate growingTextViewDidEndEditing:self];
        }
    }
}

#pragma mark - NSNotificationCenter
//监听到的键盘事件
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(growingWillShow:)]) {
//        [_delegate growingWillShow:self];
//    }
//    
//    NSDictionary *info = [notification userInfo];
//    _keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    
//    CGFloat offsetY = self.parentView.bounds.size.height - _keyboardHeight - self.bounds.size.height;
//    if (_keyboardVisible) {
//        CGRect frame = self.frame;
//        frame.origin.y = offsetY;
////        self.frame = frame;
//        self.transform = CGAffineTransformMakeTranslation(0, offsetY);
//    } else {
//        NSTimeInterval cur = [self getCurve:notification.userInfo];
//        NSTimeInterval dur = [self getDuration:notification.userInfo];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:cur];
//        [UIView setAnimationDuration:dur];
//        CGRect frame = self.frame;
//        frame.origin.y = offsetY;
//        self.frame = frame;
//        [UIView commitAnimations];
//    }
//    
//    _keyboardVisible = YES;
//
//    [self notifyHeight:notification];
//}

//- (void)keyboardWillHide:(NSNotification *)notification
//{    
//    NSDictionary *info = [notification userInfo];
//    _keyboardHeight = 0;
//    CGFloat offsetY = self.parentView.bounds.size.height - self.bounds.size.height;
//
//    NSTimeInterval cur = [self getCurve:notification.userInfo];
//    NSTimeInterval dur = [self getDuration:notification.userInfo];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:cur];
//    [UIView setAnimationDuration:dur];
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(growingWillHide:)]) {
//        [_delegate growingWillHide:self];
//    }
//    CGRect frame = self.frame;
//    frame.origin.y = offsetY;
////    self.frame = frame;
//    self.transform = CGAffineTransformIdentity;
//    [UIView commitAnimations];
//    
//    _keyboardVisible = NO;
//    [self notifyHeight:notification];
//}

- (void)keyboardDidHide:(NSNotification *)notification
{
//    self.growingInputType = GrowingInputType_Text;
//    _growingTextView.internalTextView.inputView = nil;
//    if (_delegate && [_delegate respondsToSelector:@selector(growingDidHide:)]) {
//        [_delegate growingDidHide:self];
//    }
}

- (void)atFriend:(NSString*)content
{
    [self registerNotifications];
    if (!content) {
        [self.growingTextView becomeFirstResponder];
        return;
    }
    
    NSString *string = content;
    NSInteger length = string.length;
    [self.growingTextView becomeFirstResponder];
    NSUInteger location = self.growingTextView.selectedRange.location;
    if(self.growingTextView.text){
        if (location == 0) {
            string = [NSString stringWithFormat:@"%@%@",string,self.growingTextView.text];
        }else if(location == self.growingTextView.text.length){
            string = [NSString stringWithFormat:@"%@%@",self.growingTextView.text,string];
        }else{
            string = [NSString stringWithFormat:@"%@%@%@",
                      [self.growingTextView.text substringToIndex:location],
                      string,
                      [self.growingTextView.text substringFromIndex:location]];
        }
    }
    self.growingTextView.text = string;
    self.growingTextView.selectedRange = NSMakeRange(location+length,0);
    
    [self changeLeftInputCount:string.length];
}

#pragma mark - Private
//键盘高
- (CGFloat)getKeyboardHeight:(NSDictionary *)userInfo
{
    return [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}
//键盘动画时间
- (NSTimeInterval)getDuration:(NSDictionary *)userInfo
{
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    return animationDuration;
}
//键盘动画曲线
- (NSInteger)getCurve:(NSDictionary *)userInfo
{
    return [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
}


- (BOOL)isOnScreen:(UIView *)view
{
    return NO;
}

- (void)changeLeftInputCount:(NSInteger)length
{
    if (self.maxInputCount > 0) {
        NSInteger leftCount = self.maxInputCount - length;
        if (leftCount < 0) {
            self.tipLable.textColor = _tipLabelErrorFontColor;
        } else {
            self.tipLable.textColor = _tipLabelNormalFontColor;
        }
        self.tipLable.hidden = (leftCount > INPUT_COUNT_WHEN_TIP_LABLE_DISPLAY);
        self.tipLable.text = [NSString stringWithFormat:@"%ld", (long)leftCount];
    } else {
        self.tipLable.hidden = YES;
    }
}

- (void)notifyHeight:(NSNotification *)notification
{
    NSTimeInterval cur = (notification != nil) ? [self getCurve:notification.userInfo] : 7;
    NSTimeInterval dur = (notification != nil) ? [self getDuration:notification.userInfo] : 0.25;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:cur];
    [UIView setAnimationDuration:dur];
    
    CGFloat h = _keyboardHeight + self.frame.size.height;
    if (_delegate && [_delegate respondsToSelector:@selector(growingInputView:didChangeHeight:keyboardVisible:)]) {
        [_delegate growingInputView:self didChangeHeight:h keyboardVisible:_keyboardVisible];
    }
    
    [UIView commitAnimations];
}

- (BOOL)notifySendBtnClicked
{
    if (_growingTextView.internalTextView.text.length > self.maxInputCount) {
        NSString *formatStr = @"不能超过%ld个字";
        NSString *msg = [NSString stringWithFormat:formatStr, (long)self.maxInputCount];
        NSLog(@"%@",msg);
        return NO;
    }
    
    BOOL ret = YES;
    NSString *str = self.text;
    if (_delegate && [_delegate respondsToSelector:@selector(growingInputView:didSendText:)]) {
        ret = [_delegate growingInputView:self didSendText:str];
    }
    return ret;
}
//切换按钮图片
- (void)setGrowingInputType:(GrowingInputType)growingInputType
{
    _growingInputType = growingInputType;
    
    UIImage *image = [UIImage imageNamed:@"表情"];
    if (growingInputType == GrowingInputType_Emoji) {
        
        image = [UIImage imageNamed:@"键盘"];
    }
    [_emojiBtn setImage:image forState:UIControlStateNormal];
    
    
}

#pragma mark - @selector xib & ui
//点击emoji切换键盘
- (IBAction)emojiBtnClicked:(id)sender
{
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(growingInputViewEmojiBtnClick:)]) {
        [_delegate growingInputViewEmojiBtnClick:self];
    }
    //切换键盘
    if (_growingInputType == GrowingInputType_Text) {
        [_growingTextView resignFirstResponder];
        _growingTextView.internalTextView.inputView = _emojiKeyboardView;
        
        [_growingTextView becomeFirstResponder];
        self.growingInputType = GrowingInputType_Emoji;
    } else if (_growingInputType == GrowingInputType_Emoji) {
        [_growingTextView resignFirstResponder];
        //切换到普通键盘
        _growingTextView.internalTextView.inputView = nil;
        [_growingTextView becomeFirstResponder];
        self.growingInputType = GrowingInputType_Text;
    }
}
//点击发送按钮
- (IBAction)sentBtnClicked:(id)sender
{
    if ([self notifySendBtnClicked]) {//判断长度并通知代理
        [self resetInput];//清空
    }
}

#pragma mark - @selector others

- (void)resignFromInput:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(growingInputView:didRecognizer:)]) {
        [_delegate growingInputView:self didRecognizer:sender];
        }
    [self.growingTextView resignFirstResponder];
}


#pragma mark - AGEmojiKeyboardViewDelegate
//点击了某个Emoji表情
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    
    NSInteger loc = self.growingTextView.selectedRange.location;
    NSMutableString *text = [NSMutableString stringWithString:self.growingTextView.text];
    [text insertString:emoji atIndex:loc];
    self.growingTextView.text = text;
    NSRange range = NSMakeRange(loc + emoji.length, 0);
    self.growingTextView.selectedRange = range;
}
//点击后退删除按钮
- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    [self.growingTextView.internalTextView deleteBackward];
}
//后退删除按钮的图片
- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage imageNamed:@"showEnd退出按钮"];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}
/****************以下本Demo中没用,在有多组表情时使用*************/

- (UIColor *)randomColor {
    return [UIColor colorWithRed:drand48()
                           green:drand48()
                            blue:drand48()
                           alpha:drand48()];
}
//生成图片
- (UIImage *)randomImage {
    CGSize size = CGSizeMake(30, 10);
    UIGraphicsBeginImageContextWithOptions(size , NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    
    fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGFloat xxx = 3;
    rect = CGRectMake(xxx, xxx, size.width - 2 * xxx, size.height - 2 * xxx);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//选中分组的标题图片
- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}
//未选中分组的标题图片
- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}
@end
