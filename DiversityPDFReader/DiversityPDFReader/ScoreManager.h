//
//  ScoreManager.h
//  DiversityPDFReader
//
//  Created by Z on 11/1/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreManager : NSObject

+ (id)sharedManager;

@property (nonatomic) float score;

@end
