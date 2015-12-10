//
//  Transport.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "Transport.h"
#import "TAConstants.h"

@interface Transport() {
    NSMutableData *mData;
}

@end

@implementation Transport
@synthesize delegate;


-(id)init
{
    if ((self=[super init])) {
    }
    
    return self;
}


- (void)handleRequestWith:(NSString *)requestUrl
{
    mData = [[NSMutableData alloc] init];
    NSLog(@"handleRequestWith Called");
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:100];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLConnection *connManager = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [connManager start];
}


#pragma mark - NSURLConnection delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mData appendData:data];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading fetchedData Called");
    [delegate fetchedData:mData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate failureData:error];
}


@end
