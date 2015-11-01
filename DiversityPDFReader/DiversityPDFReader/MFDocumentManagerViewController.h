//
//  MFDocumentManagerViewController.h
//  DiversityPDFReader
//
//  Created by Z on 10/31/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <FastPdfKit/FastPdfKit.h>
#import "SlidingViewDelegate.h"
#import <SpeechKit/SpeechKit.h>

@interface MFDocumentManagerViewController : UIViewController  <SKRecognizerDelegate>

@property (nonatomic) MFDocumentManager *documentManager;
@property (nonatomic, retain) SKRecognizer* recognizer;
@property NSString* recordedString;

-(IBAction)actionOpenPlainDocument:(id)sender;

@end
