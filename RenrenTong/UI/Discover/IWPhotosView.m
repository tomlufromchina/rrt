//
//  IWPhotosView.m
//  9期微博
//
//  Created by teacher on 14-10-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWPhotosView.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

// 图片的宽度
#define IWPhotoWidth 70
// 图片的高度
#define IWPhotoHeight IWPhotoWidth
// 图片间隙
#define IWPhotoMargin 10

@interface IWPhotosView ()
// 放大的图片
@property (nonatomic, weak) UIImageView *bigIV;

// 子配图原始的frame
@property (nonatomic, assign) CGRect oldFrame;
// 蒙版
@property (nonatomic, weak)  UIView *cover;
@end

@implementation IWPhotosView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        // 1.初始化子配图
        for (int i = 0; i < 9; i++) {
            // 1.1创建子配图, 并添加到配图容器中
            UIImageView  *iv = [[UIImageView alloc] init];
            iv.tag = i;
            
            // 1.2设置图片显示的内容模式
            iv.contentMode = UIViewContentModeScaleAspectFill;
            
            // 1.3设置超出UIIimageview的部分不显示
            iv.layer.masksToBounds = YES;
            iv.userInteractionEnabled = YES;
            
            
            // 1.4给子配图添加点击事件监听
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [iv addGestureRecognizer:tap];
            
            [self addSubview:iv];
        }
    }
    return self;
}


- (void)imageClick:(UITapGestureRecognizer *)tap
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置浏览器需要显示的数据
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < self.picUrls.count; i++) {
        
        // 创建MJPhoto对象
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置MJPhoto对象需要显示的图片的URL
        NSString *urlStr = self.picUrls[i];
        photo.url = [NSURL URLWithString:urlStr];
        
        // 告诉浏览器图片的来源
        photo.srcImageView = self.subviews[i];
        
        // 将MJPhoto对象添加到数组中
        [arrM addObject:photo];
        
    }
    browser.photos = arrM;
    
    // 设置当前点击图片的索引
    browser.currentPhotoIndex = tap.view.tag;
    
    // 3.显示浏览器
    [browser show];
    
}

// 计算配图容器的宽高
+ (CGSize)sizeWithCount:(int)count
{
    // 有配图
    CGFloat photoW = IWPhotoWidth;
    CGFloat photoH = IWPhotoHeight;
    CGFloat photoMargin = IWPhotoMargin;
    
    // 1.计算列数
    int maxClos = count > 3 ? 3 : count;
    // 2.计算配图容器的宽度
    // 配图容器的宽度 = (配图的列数 * 配图的宽度) + (配图的列数- 1) * 间隙
    CGFloat photosViewWidth = (maxClos * photoW) + ((maxClos - 1) * photoMargin);
    
    // 3.计算行数
    int maxRow = 1;
    // 3/6/9
    if ((count % 3) == 0) {
        maxRow = count / 3 ;// 1 2 3
    }else
    {
        maxRow = count / 3 + 1; // 1 2 3
    }
    
    // 4.计算配图容器的高度
    // 配图容器的高度 = (配图的行数 * 配图的高度) + (配图的行数 - 1) * 间隙
    CGFloat photosViewHeight = (maxRow * photoH) + (maxRow - 1) * photoMargin;

    return CGSizeMake(photosViewWidth, photosViewHeight);


}

// 5   0~4
// 8  0~7
- (void)setPicUrls:(NSArray *)picUrls
{
    _picUrls = picUrls;
    
    //  做一次安全判断
    int photoCount = _picUrls.count;
    if (photoCount == 0) {
        self.hidden = YES;
        return;
    }else
    {
        self.hidden = NO;
    }
    
    // 1.根据配图数据创建子配图
    // 遍历所有的子配图
    for (int i = 0; i < 9; i++) {
        // 1.1 取出对应位置的子配图
        UIImageView *iv = self.subviews[i];
        
        // 显示应该显示的子配图
        if (i < photoCount) {
            iv.hidden = NO;
            
            // 1.2.下载子配图数据
            NSString *photo = _picUrls[i];
            [iv setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"default"]];
        }else
        {
            // 隐藏不需要显示的子配图
            iv.hidden = YES;
        }

    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置子配图的frame
    int count = self.subviews.count;
    
    for (int i = 0; i < count; i++) {
        // 1.1取出对应位置的子配图
        UIImageView *iv = self.subviews[i];
        
        // 1.2计算frame
        iv.width = IWPhotoWidth;
        iv.height = IWPhotoHeight;
        
        // 列数
        int col = i % 3;
        // 计算X的值
        // X = 列数 * (图片的宽度 + 间隙)
        iv.left = col * (IWPhotoWidth + IWPhotoMargin);
        
        // 行数
        int row = i / 3;
        // 计算Y的值
        // Y = 行数 * (图片的高度 + 间隙)
        iv.top = row * (IWPhotoHeight + IWPhotoMargin);

    }
}
@end
