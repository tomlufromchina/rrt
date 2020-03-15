//
//  KZColorWheelView.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KZColorPicker.h"
#import "KZColorPickerHSWheel.h"
#import "KZColorPickerBrightnessSlider.h"
#import "KZColorPickerAlphaSlider.h"
#import "HSV.h"
#import "UIColor-Expanded.h"

@interface KZColorPicker()
@property (nonatomic, retain) KZColorPickerHSWheel *colorWheel;
@property (nonatomic, retain) KZColorPickerBrightnessSlider *brightnessSlider;
@property (nonatomic, retain) KZColorPickerAlphaSlider *alphaSlider;

@end


@implementation KZColorPicker
@synthesize colorWheel;
@synthesize brightnessSlider;
@synthesize selectedColor;
@synthesize alphaSlider;

- (void) setup
{
	// set the frame to a fixed 300 x 300
	//self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 300, 280);
	self.backgroundColor = [UIColor clearColor];
    
    UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-60, 30)];

    title.text=@"设置画笔颜色和大小";
    title.textColor=[UIColor blackColor];
    [self addSubview:title];
    
	// HS wheel
	KZColorPickerHSWheel *wheel = [[KZColorPickerHSWheel alloc] initAtOrigin:CGPointMake(10, 50)];
	[wheel addTarget:self action:@selector(colorWheelColorChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:wheel];
	self.colorWheel = wheel;
	[wheel release];
	
	// brightness slider
	KZColorPickerBrightnessSlider *slider = [[KZColorPickerBrightnessSlider alloc] initWithFrame:CGRectMake(24, 
																											277,
																											272,
																											38)];
	[slider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slider];
    self.brightnessSlider = slider;
    self.brightnessSlider.hidden=YES;
	[slider release];
    
    // alpha slider
    KZColorPickerAlphaSlider *alpha = [[KZColorPickerAlphaSlider alloc] initWithFrame:CGRectMake(24, 
                                                                                                 321,
                                                                                                 272,
                                                                                                 38)];
    [alpha addTarget:self action:@selector(alphaChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:alpha];
    self.alphaSlider = alpha;
    self.alphaSlider.hidden=YES;
	[alpha release];
    
    UILabel* pintcolor=[[UILabel alloc] initWithFrame:CGRectMake(wheel.right+10, wheel.top, 60, 30)];
    
    pintcolor.text=@"画笔颜色：";
    pintcolor.textColor=[UIColor blackColor];
    pintcolor.font=[UIFont systemFontOfSize:12];
    [self addSubview:pintcolor];
    
    colorview=[[UIView alloc] initWithFrame:CGRectMake(pintcolor.right+10, pintcolor.top+5, 20, 20)];
    [self addSubview:colorview];
    
    UILabel* pintsize=[[UILabel alloc] initWithFrame:CGRectMake(wheel.right+10, pintcolor.bottom+30, 60, 30)];
    
    pintsize.text=@"画笔大小：";
    pintsize.textColor=[UIColor blackColor];
    pintsize.font=[UIFont systemFontOfSize:12];
    [self addSubview:pintsize];
    
    self.sizelable=[[UILabel alloc] initWithFrame:CGRectMake(pintsize.right+10, pintsize.top+5, 20, 20)];
    self.sizelable.text=@"1";
    self.sizelable.textAlignment=NSTextAlignmentCenter;
    self.sizelable.textColor=[UIColor blackColor];
    self.sizelable.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.sizelable];
    
    self.sizeslider=[[UISlider alloc] initWithFrame:CGRectMake(10, wheel.bottom+10, SCREENWIDTH-60, 30)];
    self.sizeslider.minimumValue = 1;  //设置滑轮所能滚动到的最小值
    
    self.sizeslider.maximumValue = 10;  //设置滑轮所能滚动到的最大值
    [self.sizeslider addTarget:self action:@selector(changePintSize:) forControlEvents:UIControlEventValueChanged];
    
    //为slider添加方法当slider的值改变时就会触发change方法
    self.sizeslider.continuous = YES;
    [self addSubview:self.sizeslider];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		[self setup];
    }
    return self;
}

-(void)changePintSize:(UISlider*) sender{
    self.sizelable.text=[NSString stringWithFormat:@"%i",(int)[sender value]];
}

- (void)dealloc 
{
	[selectedColor release];
	[colorWheel release];
	[brightnessSlider release];
    [alphaSlider release];
    [super dealloc];
}

- (void) awakeFromNib
{
	[self setup];
}



RGBType rgbWithUIColor(UIColor *color)
{
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	CGFloat r,g,b;
	
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor))) 
	{
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			break;
		default:	// We don't know how to handle this model
			return RGBTypeMake(0, 0, 0);
	}
	
	return RGBTypeMake(r, g, b);
}

- (void) setSelectedColor:(UIColor *)color animated:(BOOL)animated
{
	if (animated) 
	{
		[UIView beginAnimations:nil context:nil];
		self.selectedColor = color;
		[UIView commitAnimations];
	}
	else 
	{
		self.selectedColor = color;
	}
}


- (void) setSelectedColor:(UIColor *)c
{
	[c retain];
	[selectedColor release];
	selectedColor = c;
	
	RGBType rgb = rgbWithUIColor(c);
	HSVType hsv = RGB_to_HSV(rgb);
	
	self.colorWheel.currentHSV = hsv;
	self.brightnessSlider.value = hsv.v;
    self.alphaSlider.value = [c alpha];
	
    UIColor *keyColor = [UIColor colorWithHue:hsv.h 
                                   saturation:hsv.s
                                   brightness:1.0
                                        alpha:1.0];
	[self.brightnessSlider setKeyColor:keyColor];
    
    keyColor = [UIColor colorWithHue:hsv.h 
                          saturation:hsv.s
                          brightness:hsv.v
                               alpha:1.0];
    [self.alphaSlider setKeyColor:keyColor];
    colorview.backgroundColor=c;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) colorWheelColorChanged:(KZColorPickerHSWheel *)wheel
{
	HSVType hsv = wheel.currentHSV;
	self.selectedColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:self.brightnessSlider.value
										 alpha:self.alphaSlider.value];
}

- (void) brightnessChanged:(KZColorPickerBrightnessSlider *)slider
{
	HSVType hsv = self.colorWheel.currentHSV;
	
	self.selectedColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:0
										 alpha:1];
	
}

- (void) alphaChanged:(KZColorPickerAlphaSlider *)slider
{
	HSVType hsv = self.colorWheel.currentHSV;
	
	self.selectedColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:0
										 alpha:1];
	
}




@end
