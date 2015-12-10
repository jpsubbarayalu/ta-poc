//
//  MBServiceClient.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "TAServiceClient.h"
#import "TAConstants.h"

@implementation TAServiceClient
@synthesize delegate;

- (void) initializeWebService : (NSString *) requestURL {
    Transport *trans =[[Transport alloc] init];
    [trans setDelegate:self];
    [trans handleRequestWith:requestURL];
}

-(void)fetchedData:(NSData *)data
{
    //NSLog(@"fetchedData Called");
    NSString *feedString = [[NSString
                             alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSData *jsonData = [feedString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    NSDictionary *responseDictionary=[NSJSONSerialization JSONObjectWithData:jsonData  options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"Error: was not able to load messages.");
        [delegate TAServiceClientFailureData:error];
    }
    
    if (responseDictionary != nil)
    {
        [delegate TAResponseReceived:responseDictionary];
    }
    
}


-(void)failureData:(NSError *)err{
    [delegate TAServiceClientFailureData:err];
}



@end

