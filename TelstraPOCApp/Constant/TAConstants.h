//
//  ViewController.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


// Screen Boundary
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define RIGHT_IMAGE_WIDTH 150
#define EXPECTED_HEIGHT 130
#define DEFAULT_HEIGHT 170
#define OFFSET_HEIGHT 60

#define MAX_HEIGHT 9999

// Color
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)a)]

#if !defined(StringOrEmpty)
#define StringOrEmpty(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })
#endif

//Json feed Url
#define JSON_FEED_URL @"https://dl.dropboxusercontent.com/u/746330/facts.json"

//Image Constant
#define TA_IMAGE_NOT_FOUND @"DefaultImage"
#define DESCRIPTION_NOT_FOUND @"No Description"
#define TITLE_NOT_FOUND @"No Title"

//Model Constant
#define NUMBER_OF_ROWS @"rows"
#define TITLE @"title"
#define IMAGE @"image"
#define DESCRIPTION @"description"
#define IMAGE_URL @"imageHref"

//Errors Notification
#define NO_INTERNET @"Internet access not available"
#define HOST_UNREACHABLE @"Host Unreachable"
#define REMOTE_UNAVALIABLE @"Problem with remote service"
#define Network_Err_MSG @"Network Error"
#define REQUEST_TIME_OUT @"Request Timed Out."
#define NETWORK_CONNECTION_LOST @"The Network Connection was lost."

//Font
#define TITLE_FONT_SIZE 13
#define DESCRIPTION_FONT_SIZE 12
#define TITLE_FONT_NAME @"AvenirNext-Bold"
#define DESCRIPTION_FONT_NAME @"AvenirNext-Medium"

