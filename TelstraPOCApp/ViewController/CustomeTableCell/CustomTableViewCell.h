//
//  ViewController.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) NSURLSessionDataTask *imageDownloadTask;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


+(NSString *)reuseIdentifier;

@end
