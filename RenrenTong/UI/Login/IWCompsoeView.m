//
//  IWCompsoeView.m
//  9期微博
//
//  Created by teacher on 14-10-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWCompsoeView.h"
//#import "IWTabBarButton.h"
#import "IWComposeSelectButton.h"

// 距离
#define IWDatel 200

// 最大的列数
#define IWMacCols 6

@interface IWCompsoeView()
/**
 *  底部工具条
 */
@property (nonatomic, weak) UIView *toolBar;
/**
 *  加号按钮
 */
@property (nonatomic, weak) UIButton *addBtn;

@property (nonatomic, weak) UIButton *screenButton;

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *scrollview;

@property (nonatomic, strong) NSMutableArray *buttons;

/**
 *  记录菜单的打开状态
 */
@property (nonatomic, assign, getter = isOpen) BOOL open;
@end

@implementation IWCompsoeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.设置自己的背景颜色
        self.backgroundColor = [UIColor grayColor];
        
        
        // 2.创建scrollview
        [self setupScrollView];
        
        // 3.创建底部工具条
        [self setupToolBar];
        
        // 3.创建选择按钮
        [self setupOtherButtons];

    }
    return self;
}

/**
 *  初始化底部工具条
 */
- (void)setupToolBar
{
    
//    // 1.创建背景
//    UIImageView *toolBar = [[UIImageView alloc] init];
//    toolBar.image  = [self resizableImageWithName:@"tabbar_compose_below_background"];
//    [self addSubview:toolBar];
//    self.toolBar = toolBar;
//    
//    // 2.创建加号按钮
//    
//    UIButton *addBtn = [[UIButton alloc] init];
//    [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
//    addBtn.adjustsImageWhenHighlighted = NO;
//    
//    // 添加工具条点击事件
//    [addBtn addTarget:self action:@selector(toolBarClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    // 4.将按钮添加到蒙版上
//    [toolBar addSubview:addBtn];
//    self.addBtn = addBtn;
    
    // 1.创建背景
    UIImageView *toolBar = [[UIImageView alloc] init];
    //    toolBar.image  = [self resizableImageWithName:@"tabbar_compose_below_background"];
    toolBar.backgroundColor = theLoginButtonColor;
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 2.创建加号按钮
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [addBtn setImage:[UIImage imageNamed:@"JF"] forState:UIControlStateNormal];
    addBtn.adjustsImageWhenHighlighted = NO;
    
    // 添加工具条点击事件
    [addBtn addTarget:self action:@selector(toolBarClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 4.将按钮添加到蒙版上
    [toolBar addSubview:addBtn];
    self.addBtn = addBtn;
}

- (UIImage *)resizableImageWithName:(NSString *)imageNmae
{
    return [self resizableImageWithName:imageNmae leftRatio:0.5 topRatio:0.5];
}

- (UIImage *)resizableImageWithName:(NSString *)imageNmae leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio
{
    // 1.创建图片
    UIImage *image = [UIImage imageNamed:imageNmae];
    CGSize imageSize = image.size;
    // 2.设置拉伸不变形
    image = [image stretchableImageWithLeftCapWidth:imageSize.width * leftRatio topCapHeight:imageSize.height * topRatio];
    // 3.返回图片
    return image;
}
/**
 *  初始化ScrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor = [UIColor whiteColor];
    
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.scrollEnabled = NO;

    // 给scrollview注册监听
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollviewClick:)];
    [scrollview addGestureRecognizer:tap];
    
    [self addSubview:scrollview];
    self.scrollview = scrollview;
}

/**
 *  点击scrollview
 */
- (void)scrollviewClick:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

/**
 *  初始化选择按钮
 */
- (void)setupOtherButtons
{
    //文字按钮
    [self creatComposeButton:@"新浪" imageName:@"xl-" type:IWComposeButtonTypeSina];
    
    //相册按钮
    [self creatComposeButton:@"QQ空间" imageName:@"QQKJ-" type:IWComposeButtonTypeQzone];
    
    //拍摄按钮
    [self creatComposeButton:@"微信" imageName:@"wx-" type:IWComposeButtonTypeWenXin];
    

}
/**
 *  创建选择按钮
 *
 *  @param title     选择按钮的图片
 *  @param imageName 选择按钮的标题
 */
- (void)creatComposeButton:(NSString *)title imageName:(NSString *)imageName type:(IWComposeButtonType)type
{
    // 1.创建选择按钮
    IWComposeSelectButton *btn = [[IWComposeSelectButton alloc] init];
    btn.tag = type;
    // 设置图片
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    // 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    
    // 注册监听
    [btn addTarget:self action:@selector(composeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn bringSubviewToFront:self.scrollview];
    // 将选择按钮添加到scrollview
    [self.scrollview addSubview:btn];
    
    
    [self.buttons addObject:btn];
}
/**
 *  监听选择按钮的点击事件
 */
- (void)composeBtnClick:(IWComposeSelectButton *)btn
{
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(compsoeView:didClickType:)]) {
            [self .delegate compsoeView:self didClickType:btn.tag];
        }
        
         [self dismiss];
}



/**
 *  工具条点击事件
 */
- (void)toolBarClick
{
}

- (void)show
{
    // 2.将蒙版添加到window上
    _screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, SCREENHEIGHT - 170, SCREENWIDTH, 170);
    _screenButton.frame = window.frame;
    _screenButton.backgroundColor = [UIColor grayColor];
    _screenButton.alpha = 0.5f;
    [_screenButton addTarget:self action:@selector(removeOfScreen) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_screenButton];
    [window addSubview:self];

}

- (void)removeOfScreen
{
    [self dismiss];
}

- (void)dismiss
{

    for (int i = 0; i < self.buttons.count; i++)
    {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //让加号按钮做动画
            self.addBtn.transform = CGAffineTransformIdentity;
            
            // 让按钮做动画
            UIButton *btn = self.buttons[i];
            btn.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            if (i == (self.buttons.count - 1)) {
                // 每次隐藏的时候修改当前view的frame, 以便于下次继续调用layoutsubviews
                self.frame = CGRectZero;
                self.open = NO;
                [self removeFromSuperview];
                [_screenButton removeFromSuperview];
            }
        }];
    }
    
    
}

/*
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、更改view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    

    // 1.设置scrollview的frame
    [self setScrollviewFrame];
    
    // 2.设置工具条的frame
    [self setupToolBarFrame];
    
    // 3.设置其它按钮的frame
    [self setupOtherButtonsFrame];

}

/**
 *  设置工具条的frame
 */
- (void)setupToolBarFrame
{
    // 1.设置工具条背景的frame
    
    CGFloat toolBarW = self.width - 20;
    CGFloat toolBarH = 40;
    CGFloat toolBarX = 10;
    CGFloat toolBarY = self.height - toolBarH - 10;
    self.toolBar.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    // 2.设置加号按钮的frame
//    self.addBtn.size = self.addBtn.currentImage.size;
    self.addBtn.size = CGSizeMake(100, 21);
    self.addBtn.centerX = self.toolBar.width * 0.5;
    self.addBtn.centerY = self.toolBar.height * 0.5;
    
    // 2.设置选择按钮的frame
//    int count = self.buttons.count;
}
/**
 *  设置scrollview的frame
 */
- (void)setScrollviewFrame
{
    // 1.设置scrollview的frame
    self.scrollview.frame = self.bounds;
    
    // 2.设置scrollview的其他属性
     self.scrollview.contentSize = CGSizeMake(self.width, self.height);
    
}
/**
 *  设置其他按钮的frame
 */
- (void)setupOtherButtonsFrame
{
    int count = self.buttons.count;
    for (int i = 0; i < count; i++) {
        // 2.1取出对应的按钮
        UIButton *btn = self.buttons[i];

        // 2.2计算按钮的frame
        CGFloat btnWidth = btn.currentImage.size.width;
        CGFloat btnHeight = btnWidth + 50;
        
        // 1.获取列号
        int col = i % IWMacCols;
        // 2.获取行号
        int row = i / IWMacCols;
        
        // 按钮的间隙
        CGFloat btnMargin = (self.width * 2 - (IWMacCols * btnWidth)) /(IWMacCols + 1);
        
        CGFloat btnX =  btnMargin + col * (btnWidth + btnMargin)- 20;
        CGFloat btnY = self.height + row * (btnHeight + btnMargin) + i * IWDatel + 50;
        
        btn.frame = CGRectMake(btnX, btnY, btnWidth + 20, btnHeight);
        
        if (!self.open) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                // 让加号按钮旋转
//                self.addBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
                
                // 让btn执行动画
                CGFloat moveY = (self.height - (btnHeight * 2 + btnMargin)) / 2 ;
                
                btn.transform = CGAffineTransformMakeTranslation(0, -self.height + moveY - i * IWDatel);
            } completion:^(BOOL finished) {
                self.open = YES;
            }];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end
