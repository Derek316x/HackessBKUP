//
//  C4QReaderViewController.h
//  DiversityPDFReader
//
//  Created by Z on 10/31/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <FastPdfKit/FastPdfKit.h>
#import "SlidingView.h"

@interface C4QReaderViewController : ReaderViewController

@property (nonatomic) SlidingView *divView;
@property (nonatomic) float percentage;

@end
