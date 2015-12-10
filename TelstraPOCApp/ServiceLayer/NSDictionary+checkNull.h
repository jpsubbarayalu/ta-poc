/**
 * @author   Cognizant
 * @author   Jayaprakash
 *
 * @brief    NSDictionary+CheckNull
 * @version  1.0
 */

#import <Foundation/Foundation.h>

@interface NSDictionary (checkNull)
- (id)safeObjectForKey:(id)aKey;
@end
