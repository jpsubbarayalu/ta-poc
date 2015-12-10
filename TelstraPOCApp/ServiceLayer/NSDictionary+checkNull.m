/**
 * @author   Cognizant
 * @author   Jayaprakash
 *
 * @brief    NSDictionary+CheckNull
 * @version  1.0
 */

#import "NSDictionary+checkNull.h"

@implementation NSDictionary (checkNull)

//================================================================================
/*
 @method        CheckForNull
 @abstract      Checking null from server respose params
 @param         id
 @return        id
 */
//================================================================================
- (id)safeObjectForKey:(id)aKey {
    NSObject *object = self[aKey];
    
    if (object == [NSNull null]) {
        return @"";
    }
    
    return object;
}
@end
