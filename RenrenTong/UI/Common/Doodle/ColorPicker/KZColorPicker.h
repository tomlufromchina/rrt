//
//  KZColorWheelView.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZColorPickerHSWheel;
@class KZColorPickerBrightnessSlider;
@class KZColorPickerAlphaSlider;

@interface KZColorPicker : UIControl
{
	KZColorPickerHSWheel *colorWheel;
	KZColorPickerBrightnessSlider *brightnessSlider;
    KZColorPickerAlphaSlider *alphaSlider;
    
	UIColor *selectedColor;
    BOOL displaySwatches;
    UIView *colorview;
}

@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, retain) UILabel* sizelable;
@property (nonatomic, retain) UISlider* sizeslider;
- (void) setSelectedColor:(UIColor *)color animated:(BOOL)animated;
@end
