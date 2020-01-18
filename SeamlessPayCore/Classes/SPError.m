//
//  SPError.m
//  SeamlessPayCore
//


#import "SPError.h"

@implementation SPError

+ (instancetype)errorWithResponse:(NSData*)data
{
    NSError *error = nil;
    id errobj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if (error == nil && [errobj isKindOfClass:[NSDictionary class]]) {
        
       return [SPError errorWithDomain:@"api.seamlesspay.com"
                            code:[errobj[@"code"] integerValue]
                        userInfo:@{NSLocalizedDescriptionKey:[SPError descriptionWithResponse:errobj]}];
        
    }
    
    return nil;
}

+ (NSString *)descriptionWithResponse:(NSDictionary *)dict
{
    NSMutableString *s = [NSMutableString new];
    [s appendFormat:@"Name=%@\n",dict[@"name"] ? : @""];
    [s appendFormat:@"Message=%@\n",dict[@"message"] ? : @""];
    [s appendFormat:@"ClassName=%@\n",dict[@"className"] ? : @""];
    [s appendFormat:@"StatusCode=%@\n",dict[@"data"] && dict[@"data"][@"statusCode"] ? dict[@"data"][@"statusCode"] : @""];
    [s appendFormat:@"StatusDescription=%@\n",dict[@"data"] && dict[@"data"][@"statusDescription"] ? dict[@"data"][@"statusDescription"] : @""];    
    [s appendFormat:@"Errors=%@\n",dict[@"errors"] ? : @""];
    return s;
}

@end