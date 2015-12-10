//
//  MBServiceClient.h
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transport.h"
#import "DetailsList.h"

@protocol TAServiceClientDelegate <NSObject>

-(void)TAResponseReceived:(id)jsonData;
-(void)TAServiceClientFailureData:(NSError *)err;

@end

@interface TAServiceClient : NSObject <TransportDelegate>

- (void) initializeWebService : (NSString *) requestURL;

@property(nonatomic,weak)id delegate;

@end
