//
//  ViewController.m
//  RS_SliderView
//
//  Created by Roman Simenok on 16.02.15.
//  Copyright (c) 2015 Roman Simenok. All rights reserved.
//

#import "ViewController.h"
#import "RSSliderView.h"
#import "TestViewController.h"

@interface ViewController () <RSliderViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RSSliderView *horSlider = [[RSSliderView alloc] initWithFrame:CGRectMake(20, 40 + 60, 280, 70) andOrientation:Horizontal];
    horSlider.delegate = self;
    [horSlider setColorsForBackground:[UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:37.0/255.0 alpha:1.0]
                           foreground:[UIColor colorWithRed:0.0 green:106.0/255.0 blue:95.0/255.0 alpha:1.0]
                               handle:[UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0]
                               border:[UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0]];
    horSlider.label.text = @"Horizontal slider";
    // default font is Helvetica, size 24, so set font only if you need to change it.
    horSlider.label.font = [UIFont fontWithName:@"Helvetica" size:25];
    horSlider.label.textColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0];
    [self.view addSubview:horSlider];
    
    [horSlider useProcessView:YES];
    
    RSSliderView *vertSlider = [[RSSliderView alloc] initWithFrame:CGRectMake(150, 200 + 60, 80, 300) andOrientation:Vertical];
    vertSlider.delegate = self;
    [vertSlider setColorsForBackground:[UIColor colorWithRed:37.0/255.0 green:46.0/255.0 blue:38.0/255.0 alpha:1.0]
                            foreground:[UIColor colorWithRed:32.0/255.0 green:86.0/255.0 blue:0.0 alpha:1.0]
                                handle:[UIColor colorWithRed:128.0/255.0 green:209.0/255.0 blue:79.0/255.0 alpha:1.0]
                                border:[UIColor colorWithRed:128.0/255.0 green:209.0/255.0 blue:79.0/255.0 alpha:1.0]];
    // If you don't need handle
    [vertSlider hideHandle];
    // if you don't like round corners or border
    [vertSlider removeRoundCorners:YES removeBorder:YES];
    // Coment code below if you donn't need text on you slider
    vertSlider.label.text = @"Vertical slider";
    vertSlider.label.font = [UIFont fontWithName:@"Helvetica" size:25];
    vertSlider.label.textColor = [UIColor colorWithRed:128.0/255.0 green:209.0/255.0 blue:79.0/255.0 alpha:1.0];
    [self.view addSubview:vertSlider];
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 300, 400)];
//    [btn setTitle:@"next view" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

- (void)pushView
{
    TestViewController *vc = [[TestViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:^{
    //}];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sliderValueChanged:(RSSliderView *)sender {
    NSLog(@"Value Changed: %f", sender.value);
    
    CGFloat max = 10.0f;
    CGFloat min = -10.0f;
    
    CGFloat value = (max - min)* sender.value + min;
    sender.handleLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

-(void)sliderValueChangeEnded:(RSSliderView *)sender {
    NSLog(@"Touсh ended: %f", sender.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
