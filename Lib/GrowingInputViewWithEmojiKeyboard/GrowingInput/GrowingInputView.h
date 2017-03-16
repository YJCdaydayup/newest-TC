
#import <UIKit/UIKit.h>

typedef enum _GrowingInputType
{
    GrowingInputType_Text     = 0,
    GrowingInputType_Emoji    = 1,
} GrowingInputType;


@protocol GrowingInputViewDelegate;
@interface GrowingInputView : UIView
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *parentView;
/**
 *  最小行数
 */
@property (nonatomic, assign) NSInteger minNumberOfLines;
/**
 *  内部textView的文本
 */
@property (nonatomic, strong) NSString *text;
/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, weak) id <GrowingInputViewDelegate> delegate;
/**
 *  默认高度
  */
+ (CGFloat)defaultHeight;
/**
 *  激活键盘
 */
- (void)activateInput;
/**
 *  退键盘
 */
- (void)deactivateInput;

@end


@protocol GrowingInputViewDelegate <NSObject>

@optional
/**
 点击了Emoji切换按钮
 */
- (void)growingInputViewEmojiBtnClick:(GrowingInputView *)growingInputView;
/**
 点击了发送或输入了回车
 */
- (BOOL)growingInputView:(GrowingInputView *)growingInputView didSendText:(NSString *)text;
/**
 输入框调试改变
 */
- (void)growingInputView:(GrowingInputView *)growingInputView didChangeHeight:(CGFloat)height keyboardVisible:(BOOL)keyboardVisible;

/**
 是否能进入编辑状态
 */
- (BOOL)growingTextViewShouldBeginEditing:(GrowingInputView *)growingInputView;
/**
 用户在输入框上滑动(默认退键盘)
 */
- (void)growingInputView:(GrowingInputView *)growingInputView didRecognizer:(id)sender;
/**
 输入框将要显示出来
 */
- (void)growingWillShow:(GrowingInputView *)growingInputView;
/**
 输入框将要隐藏
 */
- (void)growingWillHide:(GrowingInputView *)growingInputView;
/**
 输入框被隐藏
 */
- (void)growingDidHide:(GrowingInputView *)growingInputView;
/**
 结束编辑
 */
- (void)growingTextViewDidEndEditing:(GrowingInputView *)growingInputView;
@end

