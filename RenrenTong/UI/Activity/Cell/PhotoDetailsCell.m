//
//  PhotoDetailsCell.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "PhotoDetailsCell.h"
#import "QBAssetsCollectionOverlayView.h"

@interface PhotoDetailsCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QBAssetsCollectionOverlayView *overlayView;

@end

@implementation PhotoDetailsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsOverlayViewWhenSelected = YES;
        
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    if (selected && self.showsOverlayViewWhenSelected) {
        [self hideOverlayView];
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}

- (void)showOverlayView
{
    QBAssetsCollectionOverlayView *overlayView = [[QBAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:overlayView];
    self.overlayView = overlayView;
}

- (void)hideOverlayView
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}


#pragma mark - Accessors

- (void)setUrl:(NSString *)newUrl
{
    _url = newUrl;
    
    [self.imageView setImageWithUrlStr:newUrl
                       placholderImage:[UIImage imageNamed:@"defaultImage.png"]];
}

@end
