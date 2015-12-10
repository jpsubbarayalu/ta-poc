/**
 * @author   Cognizant
 * @author   Jayaprakash
 *
 * @brief    Helper & Utils Class
 * @version  1.0
 */

#import "TAUtils.h"
#import "TAConstants.h"
#import "Reachability.h"

@implementation TAUtils
//================================================================================
/*
 @method        ShowAlert
 @abstract      alert showing to the customer
 @param         NSString
 @return        void
 */
//================================================================================

// Alert Dialog
+(void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil,nil];
    [alert show];
}

//================================================================================
/*
 @method        checkReachability
 @abstract      Checking Internet Connectivity
 @param         Nil
 @return        Bool
 */
//================================================================================

#pragma -
#pragma mark - Network

+ (BOOL) isConnectedToNetwork {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}





@end
