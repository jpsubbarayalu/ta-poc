//
//  ViewController.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "TAConstants.h"

@implementation CustomTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont fontWithName:TITLE_FONT_NAME size:TITLE_FONT_SIZE];
        self.title.textColor = UIColorWithRGBA(0.0, 0.0, 255.0, 1.0);
        self.title.numberOfLines = 1;
        [self.contentView addSubview:self.title];
        
        self.desc = [[UILabel alloc] initWithFrame:CGRectZero];
        self.desc.numberOfLines = 0;
        self.desc.font = [UIFont fontWithName:DESCRIPTION_FONT_NAME size:DESCRIPTION_FONT_SIZE];
        self.desc.lineBreakMode = NSLineBreakByWordWrapping;
        self.desc.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:self.desc];
        
        self.photo =[[UIImageView alloc] initWithFrame:CGRectZero];
        self.photo.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.photo];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.photo addSubview:self.activityView];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}


// Set Frame for layout
-(void)layoutSubviews {
    
    [super layoutSubviews];
   
    [self.title sizeToFit];
    
    CGRect rect=self.title.frame;
    rect.origin.x= 10;
    rect.origin.y= 10;
    rect.size.width = SCREEN_WIDTH - 20;
    rect.size.height = 30;
    self.title.frame=rect;
    
    rect=self.desc.frame;
    rect.origin.x=10;
    rect.size.width = SCREEN_WIDTH - 150;
    rect.origin.y=CGRectGetHeight(self.title.frame) + 20;
    self.desc.frame=rect;

    rect=self.photo.frame;
    rect.origin.x= SCREEN_WIDTH - 120;
    rect.origin.y=CGRectGetHeight(self.title.frame) + 20;
    rect.size.width= 100;
    rect.size.height= 100;
    self.photo.frame=rect;
    
    rect = self.activityView.frame;
    rect.size.height = 50;
    rect.size.width = 50;
    rect.origin.x = 25;
    rect.origin.y = 25;
    self.activityView.frame = rect;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Custom Cell Identifier
+(NSString *)reuseIdentifier {
    
    return @"CustomCell";
}

@end
