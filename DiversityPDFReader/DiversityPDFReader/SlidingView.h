//
//  MyView.h
//  dyslexiaTest
//
//  Created by Christian Maldonado on 10/31/15.
//  Copyright © 2015 Christian Maldonado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFDocumentManagerViewController.h"

@interface SlidingView : UIView

@property (nonatomic) CGPoint lastLocation;

@property (nonatomic, weak) id <SlidingViewDelegate> delegate;

@property (nonatomic) float percentage;
@property (nonatomic) float score;


@end