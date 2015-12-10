//
//  ViewController.m
//  TelstraPOCApp
//
//  Created by Jayaprakash on 12/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsList.h"
#import "TAConstants.h"
#import "CustomTableViewCell.h"
#import "TAUtils.h"
#import "TAServiceClient.h"
#import "NSDictionary+checkNull.h"

@interface HomeViewController () <TAServiceClientDelegate>

@end

@implementation HomeViewController

#pragma mark - viewDidAppear
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Fetch json feed from the server
    [self fetchJsonFeed];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create session for downloading images
    _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:_sessionConfig];
    
    // Register notification for orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Refresh button on navigation bar
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
    self.navigationItem.rightBarButtonItem = refresh;
    
    // Loading Activity View.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setCenter:self.view.center];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    // Create a new NSMutableDictionary object so we can store images once they are downloaded.
    self.ImagesCacheDictionary = [[NSMutableDictionary alloc]init];
    
    // Register custom cell
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:[CustomTableViewCell reuseIdentifier]];
    
    // Remove separator
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - TbleViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Models for json feed
    DetailsList *listData = self.resultantData[indexPath.row];
    NSString *description = listData.description.length > 0 ? listData.description : DESCRIPTION_NOT_FOUND;
    
    //Calculate height of the description text
    CGSize descSize = CGSizeMake(SCREEN_WIDTH - RIGHT_IMAGE_WIDTH,MAX_HEIGHT);
    UIFont *descFont = [UIFont fontWithName:DESCRIPTION_FONT_NAME size:DESCRIPTION_FONT_SIZE];

    
    //Expected height
    CGSize expectedDescSize = [self rectForText:description
                                      usingFont:descFont
                                  boundedBySize:descSize].size;
    
    CGFloat totalHeight = expectedDescSize.height;
    if (totalHeight > EXPECTED_HEIGHT)
        return totalHeight + OFFSET_HEIGHT;
    else
        return DEFAULT_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultantData.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CustomTableViewCell reuseIdentifier]];
    
    // Get feed data based on indexpath
    DetailsList *listData = self.resultantData[indexPath.row];
    NSString *title=  listData.title.length > 0 ? listData.title : TITLE_NOT_FOUND;
    cell.title.text = title;
    
    NSString *description = listData.description.length > 0 ? listData.description : DESCRIPTION_NOT_FOUND;
    cell.desc.text = description;
    
    //Calculate height of the text
    CGSize descSize = CGSizeMake(SCREEN_WIDTH - RIGHT_IMAGE_WIDTH,MAX_HEIGHT);
    UIFont *descFont = [UIFont fontWithName:DESCRIPTION_FONT_NAME size:DESCRIPTION_FONT_SIZE];
    
    CGRect expectedDescRect = [self rectForText:description                                usingFont:descFont
                                  boundedBySize:descSize];
    //Adjust the label to the new height.
    CGRect descFrame = cell.desc.frame;
    descFrame.size.height = expectedDescRect.size.height;
    
    // Set description frame
    cell.desc.frame = descFrame;
    
    // Assign key for each images
    NSString *key =  [NSString stringWithFormat:@"%li",(long)indexPath.row];
    
    // Cancel when scroll the tableview
    if (cell.imageDownloadTask)
        [cell.imageDownloadTask cancel];
    
    [cell.activityView startAnimating];
    cell.photo.image = nil;
    
    // Check Image Exists
    if (![self.ImagesCacheDictionary valueForKey:key])
    {
        // Set Image Url
        NSURL *imageURL = [NSURL URLWithString:listData.imageURL];
        if (imageURL)
        {
            // Send request to download image
            cell.imageDownloadTask = [_session dataTaskWithURL:imageURL
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (error) {
                                                  [self.ImagesCacheDictionary setValue:[UIImage imageNamed:TA_IMAGE_NOT_FOUND] forKey:key];
                                                  [cell.photo setImage:[UIImage imageNamed:TA_IMAGE_NOT_FOUND]];
                                                  [cell.activityView stopAnimating];
                                                  
                                              }
                                              else {
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                  
                                                  if (httpResponse.statusCode == 200) {
                                                      UIImage *image = [UIImage imageWithData:data];
                                                      
                                                      [self.ImagesCacheDictionary setValue:image forKey:key];
                                                      [cell.photo setImage:image];
                                                      [cell.activityView stopAnimating];
                                                      
                                                  }
                                                  else {
                                                      [self.ImagesCacheDictionary setValue:[UIImage imageNamed:TA_IMAGE_NOT_FOUND] forKey:key];
                                                      [cell.photo setImage:[UIImage imageNamed:TA_IMAGE_NOT_FOUND]];
                                                      [cell.activityView stopAnimating];
                                                  }
                                              }
                                          });
                                      }];
            
            [cell.imageDownloadTask resume];
        }
    }
    else {
        // Set loaded image in the cell
        [cell.photo setImage:[self.ImagesCacheDictionary valueForKey:key]];
        [cell.activityView stopAnimating];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor whiteColor]];
    // set gradient background color of the cell
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = cell.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [cell setBackgroundView:[[UIView alloc] init]];
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
}

//Calculate Height of Label
-(CGRect)rectForText:(NSString *)text
           usingFont:(UIFont *)font
       boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}

#pragma mark - TelstraService Delegate Success and Failure Methods
-(void)TAResponseReceived:(id)jsonData {
    
    // Initialise nsmutablearray for json feed
    self.resultantData = [[NSMutableArray alloc] init];
    for(NSDictionary *results in [jsonData objectForKey:NUMBER_OF_ROWS]) {
        
        DetailsList *data = [[DetailsList alloc] init];
        data.title = [results safeObjectForKey:TITLE];
        data.description = [results safeObjectForKey:DESCRIPTION];
        data.imageURL = [results safeObjectForKey:IMAGE_URL];
        // Added json feed model in an array
        [self.resultantData addObject:data];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.title = [jsonData objectForKey:TITLE];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
        [self.activityIndicatorView stopAnimating];
        
    });
}

-(void)TAServiceClientFailureData:(NSError *)err {
    [self.activityIndicatorView stopAnimating];
     if(err.code == -1001){
        UIAlertView *Alertview =[[UIAlertView alloc]initWithTitle:Network_Err_MSG message:REQUEST_TIME_OUT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alertview show];
    }
    else if(err.code == -1005){
        UIAlertView *Alertview =[[UIAlertView alloc]initWithTitle:Network_Err_MSG message:NETWORK_CONNECTION_LOST delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alertview show];
    }
}

#pragma mark - WebService Called Method
//================================================================================
/*
 @method        fetchJsonFeed
 @abstract      get the json feed from server and update data in to UITablview
 @param         nil
 @return        void
 */
//================================================================================

// Downloading Json feed
-(void)fetchJsonFeed {
    
    // Check Network Connection
    if([TAUtils isConnectedToNetwork]) {
        TAServiceClient *webServiceClient = [[TAServiceClient alloc] init];
        [webServiceClient setDelegate:self];
        [webServiceClient initializeWebService:JSON_FEED_URL];
        
    } else {
        [TAUtils showAlertWithMessage:NO_INTERNET];
        [self.activityIndicatorView stopAnimating];
    }
        
    
}

#pragma mark - Detect Orientation
// Orientaion change detection
-(void) detectOrientation {
    [self.tableView reloadData];
}

#pragma mark - Refresh Button Method
//================================================================================
/*
 @method        refreshList
 @abstract      Refresh the List Items
 @param         id
 @return        void
 */
//================================================================================

// Refresh List Feed
-(void)refreshList:(id)sender {
    // Refresh Json Feeds
    if([TAUtils isConnectedToNetwork]) {
        [self.resultantData removeAllObjects];
        [self.tableView reloadData];
        [self.activityIndicatorView startAnimating];
        [self fetchJsonFeed];
    } else {
        [TAUtils showAlertWithMessage:NO_INTERNET];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
