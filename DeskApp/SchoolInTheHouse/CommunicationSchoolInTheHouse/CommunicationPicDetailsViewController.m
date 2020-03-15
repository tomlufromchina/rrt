//
//  CommunicationPicDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommunicationPicDetailsViewController.h"

@interface CommunicationPicDetailsViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    NSInteger _currentIndex;//当前图片索引
    UILabel *titleLabel;
    int tempImagesCount;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation CommunicationPicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(deleteMessages)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"发通知"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backRootVC)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    NSUserDefaults *tmpUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[tmpUserDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    
    //图片数量的统计相关view：
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(25, 9, 100, 26);
    titleLabel.text = [NSString stringWithFormat:@"1/%d",[self.picArry count]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:19.0f];
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.contentSize = CGSizeMake([_theImageFiles count] * CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds));
        self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.backgroundColor = [UIColor lightGrayColor];
    //添加分页控件
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    pageControl.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT- 100);
    pageControl.currentPageIndicatorTintColor = theLoginButtonColor;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.numberOfPages = [_theImageFiles count];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:pageControl];
    
    tempImagesCount = [self.picArry count];
    [self showImages:tempImagesCount];
}

- (void)showImages:(int)imagesCount
{
    if (imagesCount && imagesCount > 0) {
        pageControl.numberOfPages = imagesCount;
        self.mainScrollView.contentSize = CGSizeMake(imagesCount * CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds));

        NSUserDefaults *tmpUserDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[tmpUserDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
        if (_theImageFiles && [_theImageFiles count] > 0) {
            for (int i = 0; i < imagesCount; i ++) {
                UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height)];
                imgview.contentMode=UIViewContentModeScaleAspectFill;
                imgview.clipsToBounds=YES;
                [imgview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,_theImageFiles[i]]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
                [self.mainScrollView addSubview:imgview];
            }
        }
    } else{
        [self.mainScrollView removeFromSuperview];
        [pageControl removeFromSuperview];
    }
}
#pragma mark -- 删除当前

- (void)deleteMessages
{
    NSUserDefaults *tmpUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[tmpUserDefaults objectForKey:@"_theImageFiles"] mutableCopy];
    if (_theImageFiles && [_theImageFiles count] > 0) {
        [_theImageFiles removeObjectAtIndex:_currentIndex];
        [tmpUserDefaults setObject:_theImageFiles forKey:@"_theImageFiles"];
        [tmpUserDefaults synchronize];
        int count = tempImagesCount - 1;
        tempImagesCount = count;
        [self showImages:count];
        titleLabel.text = [NSString stringWithFormat:@"%ld/%d",(long)_currentIndex + 1,tempImagesCount];
        if (tempImagesCount == 0) {
            titleLabel.text = @"0/0";
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if ([self.delegate respondsToSelector:@selector(deleteTheImage:WithCurrentIndex:)]) {
            [self.delegate deleteTheImage:_theImageFiles WithCurrentIndex:_currentIndex];
        }
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- 返回

- (void)backRootVC
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

//scrollView在滚动的时候调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex =floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
    pageControl.currentPage = _currentIndex;
    
    titleLabel.text = [NSString stringWithFormat:@"%ld/%d",(long)_currentIndex + 1,tempImagesCount];

}

@end
