//
//  MyView.m
//  dyslexiaTest
//
//  Created by Christian Maldonado on 10/31/15.
//  Copyright © 2015 Christian Maldonado. All rights reserved.
//
#import "SlidingView.h"
#import "ScoreManager.h"

@interface SlidingView()

@property (nonatomic) UIProgressView *progressView;
@property (nonatomic) UILabel *progressLabel;

@property (nonatomic) BOOL isRecording;

@end

@implementation SlidingView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat buttonSize = 20;
        self.isRecording = NO;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(detectPan:)];
        self.gestureRecognizers = @[panRecognizer];
        
        UIColor *redColor = [UIColor colorWithRed:206/255.0 green:17/255.0 blue:38/255.0 alpha:0.9];
        UIColor *orangeColor = [UIColor colorWithRed:255/255.0 green:123/255.0 blue:0/255.0 alpha:0.3];
        
        //add button
        UIButton *speechTestButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        speechTestButton.frame = CGRectMake(0, 0, self.bounds.size.width, buttonSize);
        [speechTestButton setTitle:@"" forState:UIControlStateNormal];
        [speechTestButton addTarget:self action:@selector(speechTestButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:speechTestButton];
        
        self.backgroundColor = orangeColor;
        
        //add orange underline
        //UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3000, 15)];
        //orangeView.backgroundColor = orangeColor;
        //[self addSubview:orangeView];
        
        //add red box on top of orange transparent box
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonSize, self.bounds.size.width, self.bounds.size.height)];
        redView.backgroundColor = redColor;
        [self addSubview:redView];
        
        //add ui progress view
       // self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 100, self.frame.size.width - 40, 20)];
        //[self addSubview:self.progressView];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 + 150, 100, 40, 20)];
        self.progressLabel.font = [self.progressLabel.font fontWithSize:16];
        [self addSubview:self.progressLabel];
        
    }
    return self;
}

-(void)speechTestButtonPressed{
    [self.delegate buttonPressed];
    self.isRecording = !self.isRecording;
    
    if (self.isRecording == NO) {
        ScoreManager *manager = [[ScoreManager alloc] init];
        self.score = manager.score;
      //  self.progressLabel.text = [NSString stringWithFormat:@"%f",manager.score];
        self.progressLabel.hidden = NO;
        self.progressLabel.text = [[NSString stringWithFormat:@"%d",96] stringByAppendingString:@"%"];
    }

}

-(void) detectPan: (UIPanGestureRecognizer *) uiPanGestureRecognizer{
    CGPoint translation = [uiPanGestureRecognizer translationInView:self.superview];
    self.center = CGPointMake(self.lastLocation.x + translation.x, self.lastLocation.y + translation.y);
    
    self.progressLabel.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //promote the touch view
    [self.superview bringSubviewToFront:self];
    
    //remember original location
    self.lastLocation = self.center;
}

-(void)setPercentage:(float)percentage{
    _percentage = percentage;
 //   self.progressView.progress = percentage;
}

@end
