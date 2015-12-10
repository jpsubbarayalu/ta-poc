//
//  Transport.h
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TransportDelegate <NSObject>

-(void)fetchedData:(NSData *)data;
-(void)failureData:(NSError *)err;

@end


@interface Transport : NSObject <NSURLConnectionDelegate>{
}

- (void)handleRequestWith:(NSString *)requestUrl;

@property(strong, nonatomic)id delegate;


@end
