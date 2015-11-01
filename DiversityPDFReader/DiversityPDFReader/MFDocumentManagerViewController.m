//
//  MFDocumentManagerViewController.m
//  DiversityPDFReader
//
//  Created by Z on 10/31/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "MFDocumentManagerViewController.h"
#import "C4QReaderViewController.h"
#import "ScoreManager.h"

@interface MFDocumentManagerViewController () <SlidingViewDelegate>

@property (nonatomic) BOOL isRecording;
@property (nonatomic) C4QReaderViewController *readerViewController;

@end

const unsigned char SpeechKitApplicationKey[] = {0xb1, 0x0e, 0x79, 0x35, 0x3d, 0xbf, 0xe0, 0xfc, 0xf4, 0xc1, 0xad, 0x14, 0xd3, 0xea, 0x78, 0x50, 0x44, 0x5d, 0xbc, 0xd5, 0x40, 0x86, 0xdb, 0xef, 0x85, 0x5c, 0xe9, 0x1f, 0xb1, 0xba, 0xde, 0x62, 0xc8, 0x57, 0x98, 0x06, 0x16, 0x78, 0x02, 0x0a, 0x3a, 0xb0, 0x1f, 0x0d, 0x9a, 0x97, 0x5d, 0xde, 0xf5, 0x19, 0xb4, 0x35, 0xa0, 0x8f, 0x25, 0x25, 0xeb, 0x0e, 0x44, 0x9c, 0xc8, 0x22, 0xfe, 0x90};


@implementation MFDocumentManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SpeechKit setupWithID:@"NMDPTRIAL_bereket6725_gmail_com20151031144710"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
    self.isRecording = NO;
}

-(void)recognizerDidBeginRecording:(SKRecognizer *)recognizer{
}

-(void)recognizerDidFinishRecording:(SKRecognizer *)recognizer{
    
}
-(void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results{
    
    NSString* search = [results firstResult];
    self.recordedString = search;
    
    //do testy shit
    NSString *correctText = @"A dictionary is a collection of data consisting of key object pairs. Just as you would look up the definition of a word in a dictionary, you obtain the value object from an Objective-C dictionary by its key. The keys in a dictionary must be unique, and they can be of any object type, although they are typically strings. The value associated with the key can also be of any object type, but it cannot be nil.";
    NSString *noPunctuationCorrectText = [[[correctText stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];
    NSString *noPunctuationSpeechText = [[[self.recordedString stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];

   float levenshteinDistance = [self compareString:noPunctuationCorrectText withString:noPunctuationSpeechText];
    float charactersInCorrectText = (float)[noPunctuationCorrectText length];
    
    CGFloat percentage = (1.0 - (levenshteinDistance/charactersInCorrectText)) * 100;
    
        percentage+=25;
        if (percentage>100) {
            percentage = 100;
        }
    
    ScoreManager *manager = [[ScoreManager alloc] init];
    manager.score = percentage;
    
    self.readerViewController.percentage = percentage;
}


-(void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion{
    NSLog(@"Yo dude, something is Wrong!");
}

-(IBAction)actionOpenPlainDocument:(id)sender{
    /** Set document name */
    NSString *documentName = @"ObjectiveC";
    
    /** Get temporary directory to save thumbnails */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    /** Set thumbnails path */
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
    
    /** Get document from the App Bundle */
    NSURL *documentUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:documentName ofType:@"pdf"]];
    
    /** Instancing the documentManager */
    self.documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
    /** Instancing the readerViewController */
    C4QReaderViewController *pdfViewController = [[C4QReaderViewController alloc]initWithDocumentManager:self.documentManager];
    
    //set pdfViewController's divView delegate
    pdfViewController.divView.delegate = self;
    
    /** Set resources folder on the manager */
    self.documentManager.resourceFolder = thumbnailsPath;
    
    /** Set document id for thumbnail generation */
    pdfViewController.documentId = documentName;
    
    self.readerViewController = pdfViewController;
    
    /** Present the pdf on screen in a modal view */
    [self presentViewController:pdfViewController animated:YES completion:^{
        //
    }];
}

-(void)buttonPressed{
    NSLog(@"it works!");
    
    self.isRecording = !self.isRecording;
  
    if (self.isRecording == YES) {
        
        [self resignFirstResponder];
        self.recognizer = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType detection:SKNoEndOfSpeechDetection language:@"en_US" delegate:self];
    }
    else{
        [self.recognizer stopRecording];
    }
    
}

#pragma mark - Levenshtein Distance Algorithm

-(float)compareString:(NSString *)originalString withString:(NSString *)comparisonString
{
    // Normalize strings
    [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [comparisonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    originalString = [originalString lowercaseString];
    comparisonString = [comparisonString lowercaseString];
    
    // Step 1 (Steps follow description at http://www.merriampark.com/ld.htm)
    NSInteger k, i, j, cost, * d, distance;
    
    NSInteger n = [originalString length];
    NSInteger m = [comparisonString length];
    
    if( n++ != 0 && m++ != 0 ) {
        
        d = malloc( sizeof(NSInteger) * m * n );
        
        // Step 2
        for( k = 0; k < n; k++)
            d[k] = k;
        
        for( k = 0; k < m; k++)
            d[ k * n ] = k;
        
        // Step 3 and 4
        for( i = 1; i < n; i++ )
            for( j = 1; j < m; j++ ) {
                
                // Step 5
                if( [originalString characterAtIndex: i-1] ==
                   [comparisonString characterAtIndex: j-1] )
                    cost = 0;
                else
                    cost = 1;
                
                // Step 6
                d[ j * n + i ] = [self smallestOf: d [ (j - 1) * n + i ] + 1
                                            andOf: d[ j * n + i - 1 ] +  1
                                            andOf: d[ (j - 1) * n + i - 1 ] + cost ];
                
                // This conditional adds Damerau transposition to Levenshtein distance
                if( i>1 && j>1 && [originalString characterAtIndex: i-1] ==
                   [comparisonString characterAtIndex: j-2] &&
                   [originalString characterAtIndex: i-2] ==
                   [comparisonString characterAtIndex: j-1] )
                {
                    d[ j * n + i] = [self smallestOf: d[ j * n + i ]
                                               andOf: d[ (j - 2) * n + i - 2 ] + cost ];
                }
            }
        
        distance = d[ n * m - 1 ];
        
        free( d );
        
        return distance;
    }
    return 0.0;
}

// Return the minimum of a, b and c - used by compareString:withString:
-(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b andOf:(NSInteger)c
{
    NSInteger min = a;
    if ( b < min )
        min = b;
    
    if( c < min )
        min = c;
    
    return min;
}

-(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b
{
    NSInteger min=a;
    if (b < min)
        min=b;
    
    return min;
}


@end
