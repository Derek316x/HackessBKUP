//
//  C4QReaderViewController.m
//  DiversityPDFReader
//
//  Created by Z on 10/31/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "C4QReaderViewController.h"
#import "SlidingView.h"

@interface C4QReaderViewController ()

@end

@implementation C4QReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.divView.percentage = self.percentage;
}

-(instancetype)initWithDocumentManager:(MFDocumentManager *)aDocumentManager{
    self = [super initWithDocumentManager:aDocumentManager];
    
    CGFloat height = self.view.bounds.size.height * 0.8;
    self.divView = [[SlidingView alloc]initWithFrame:CGRectMake(-1500, height, 3000, 1000)];
    
    [self.view addSubview:self.divView];
    
    return self;
    
}

-(void)setPercentage:(float)percentage{
    _percentage = percentage;
    self.divView.percentage = percentage;
}

@end
