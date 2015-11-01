//
//  ScoreManager.m
//  DiversityPDFReader
//
//  Created by Z on 11/1/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "ScoreManager.h"

@implementation ScoreManager

+ (id)sharedManager {
    static ScoreManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
