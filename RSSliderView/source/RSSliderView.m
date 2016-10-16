//
//  RSSliderView.m
//  RSSliderView
//
//  Created by Roman Simenok on 13.02.15.
//  Copyright (c) 2015 Roman Simenok. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "RSSliderView.h"

@implementation RSSliderView

-(instancetype)custom
{
    NSString *cellName = @"RSSliderView";
    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil];
    
    // 如果路径不存在，return nil
    if (arrayOfViews.count < 1)
    {
        return nil;
    }
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UIView class]])
    {
        return nil;
    }
    // 加载nib
    NSLog(@"init RSSliderView: %@", cellName);
    return [arrayOfViews objectAtIndex:0];;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self custom];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(id)initWithFrame:(CGRect)frame andOrientation:(Orientation)orientation {
    if (self = [super initWithFrame:frame]) {
        [self setOrientation:orientation];
        [self initSlider];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        if (self.frame.size.width>self.frame.size.height) {
            [self setOrientation:Horizontal];
        }else{
            [self setOrientation:Vertical];
        }
        
        [self initSlider];
    }
    return self;
}

-(void)initSlider {
    isHandleHidden = NO;
    self.foregroundView = [[UIView alloc] init];
    self.handleView = [[UIView alloc] init];
    self.handleView.layer.cornerRadius = viewCornerRadius;
    self.handleView.layer.masksToBounds = YES;
    
    self.progressFrontView = [[UIView alloc]init];
    self.progressFrontView.backgroundColor = [UIColor redColor];
    self.progressEndView = [[UIView alloc]init];
    self.progressEndView.backgroundColor = [UIColor grayColor];
    
    self.handleLabel = [[UILabel alloc]init];
    self.handleImage = [[UIImageView alloc]init];
    self.handelBtn = [[UIButton alloc]init];
    
    switch (self.orientation) {
        case Vertical:
            self.label = [[UILabel alloc] init];
            [self.label setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            self.label.frame = self.bounds;
            break;
        case Horizontal:
            self.label = [[UILabel alloc] initWithFrame:self.bounds];
            break;
        default:
            break;
    }
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"Helvetica" size:24];
    [self addSubview:self.progressFrontView];
    [self addSubview:self.progressEndView];
    [self addSubview:self.foregroundView];
    [self addSubview:self.label];
    [self addSubview:self.handleView];
    
    [self.handleView addSubview:self.handleLabel];
    self.handelBtn.enabled = NO;
    [self.handleView addSubview:self.handleImage];
    [self.handleView addSubview:self.handelBtn];
    
    self.layer.cornerRadius = viewCornerRadius;
    self.layer.masksToBounds = YES;
    [self.layer setBorderWidth:borderWidth];
    
    // set defauld value for slider. Value should be between 0 and 1
    [self setValue:0.0 withAnimation:NO completion:nil];
}

#pragma mark - Set Value

-(void)setValue:(float)value {
    [self setValue:value withAnimation:NO completion:nil];
}

-(void)setValue:(float)value withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((value >= 0.0)&&(value <= 1.0), @"Value must be between 0 and 1");
    
    if (value < 0) {
        value = 0;
    }
    
    if (value > 1) {
        value = 1;
    }
    
    CGPoint point;
    switch (self.orientation) {
        case Vertical:
            point = CGPointMake(0, (1-value) * self.frame.size.height);
            break;
        case Horizontal:
            point = CGPointMake(value * self.frame.size.width, 0);
            break;
        default:
            break;
    }
    
    if(isAnimate) {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:animationSpeed animations:^ {
            [weakSelf changeStarForegroundViewWithPoint:point];
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Other methods

-(void)setOrientation:(Orientation)orientation {
    _orientation = orientation;
}

-(void)setColorsForBackground:(UIColor *)bCol foreground:(UIColor *)fCol handle:(UIColor *)hCol border:(UIColor *)brdrCol {
    self.backgroundColor = bCol;
    self.foregroundView.backgroundColor = fCol;
    self.handleView.backgroundColor = hCol;
    [self.layer setBorderColor:brdrCol.CGColor];
}

-(void)removeRoundCorners:(BOOL)corners removeBorder:(BOOL)borders {
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
    }
    if (borders) {
        [self.layer setBorderWidth:0.0];
    }
}

-(void)hideHandle {
    self.handleView.hidden = YES;
    isHandleHidden = YES;
    [self.handleView removeFromSuperview];
}

-(void)useProcessView:(BOOL)hide
{
    self.progressEndView.hidden = !hide;
    self.progressFrontView.hidden = !hide;
    self.foregroundView.hidden = hide;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

#pragma mark - Touch Events

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSLog(@"the moved %@", NSStringFromCGPoint(point));
    switch (self.orientation) {
        case Vertical:
            if (!(point.y < 0) && !(point.y > self.frame.size.height)) {
                [self changeStarForegroundViewWithPoint:point];
            }
            break;
        case Horizontal:
            if (!(point.x < 0) && !(point.x > self.frame.size.width)) {
                [self changeStarForegroundViewWithPoint:point];
            }
            break;
        default:
            break;
    }
    
    if ((point.x >= 0) && point.x <= self.frame.size.width-handleWidth) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
            [self.delegate sliderValueChanged:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
   
    NSLog(@"the move end %@", NSStringFromCGPoint(point));
    [UIView animateWithDuration:animationSpeed animations:^ {
        [weakSelf changeStarForegroundViewWithPoint:point];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChangeEnded:)]) {
            [self.delegate sliderValueChangeEnded:self];
        }
    }];
}

#pragma mark - Change Slider Foreground With Point

- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    switch (self.orientation) {
        case Vertical: {
            if (p.y < 0) {
                p.y = 0;
            }
            
            if (p.y > self.frame.size.height) {
                p.y = self.frame.size.height;
            }
            
            self.value = 1-(p.y / self.frame.size.height);
            self.foregroundView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, p.y-self.frame.size.height);
            
            if (!isHandleHidden) {
                if (self.foregroundView.frame.origin.y <= 0) {
                    self.handleView.frame = CGRectMake(borderWidth, 0, self.frame.size.width-borderWidth*2, handleWidth);
                }else if (self.foregroundView.frame.origin.y >= self.frame.size.height) {
                    self.handleView.frame = CGRectMake(borderWidth, self.frame.size.height-handleWidth, self.frame.size.width-borderWidth*2, handleWidth);
                }else{
                    self.handleView.frame = CGRectMake(borderWidth, self.foregroundView.frame.origin.y-handleWidth/2, self.frame.size.width-borderWidth*2, handleWidth);
                }
            }
        }
            break;
        case Horizontal: {
            if (p.x < 0) {
                p.x = 0;
            }
            
            if (p.x > self.frame.size.width) {
                p.x = self.frame.size.width;
            }
            
            self.value = p.x / self.frame.size.width;
            self.foregroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
           
            self.progressFrontView.frame = CGRectMake(0, proessViewOffset, p.x, self.frame.size.height - proessViewOffset*2);
            self.progressEndView.frame = CGRectMake(p.x, proessViewOffset, self.frame.size.width-p.x, self.frame.size.height - proessViewOffset*2);
            
            if (!isHandleHidden) {
                CGFloat height = self.foregroundView.frame.size.height - borderWidth*2 - borderoffset*2;
                CGFloat posY = self.foregroundView.center.y - height/2;//borderWidth + borderoffset;
                
                if (self.foregroundView.frame.size.width <= 0) {
                    self.handleView.frame = CGRectMake(0, posY, handleWidth, height);
                    [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
                }else if (self.foregroundView.frame.size.width >= self.frame.size.width) {
                    self.handleView.frame = CGRectMake(self.foregroundView.frame.size.width-handleWidth, posY, handleWidth, height);
                    [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
                }else{
                    self.handleView.frame = CGRectMake(self.foregroundView.frame.size.width-handleWidth/2, posY, handleWidth, height);
                }
                
                self.handleLabel.frame = self.handleView.bounds;
                self.handleImage.frame = self.handleView.bounds;
                self.handelBtn.frame = self.handleView.bounds;
            }
        }
            break;
        default:
            break;
    }
}

@end
