/**
 * Copyright (c) Seamless Payments, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "SPError.h"

@implementation SPError

+ (instancetype)errorWithResponse:(NSData *)data {
  NSError *error = nil;
  id errobj = [NSJSONSerialization JSONObjectWithData:data
                                      options:NSJSONReadingAllowFragments
                                        error:&error];
  if (error == nil && [errobj isKindOfClass:[NSDictionary class]]) {
      
      

    SPError *sperror =  [SPError errorWithDomain:@"api.seamlesspay.com"
                               code:[errobj[@"code"] integerValue]
                           userInfo:@{
                             NSLocalizedDescriptionKey :
                                 [SPError descriptionWithResponse:errobj]
                           }];
      sperror.errorMessage = errobj[@"message"];
      sperror.statusCode = errobj[@"data"] && errobj[@"data"][@"statusCode"] ? errobj[@"data"][@"statusCode"] : nil;
      sperror.statusDescription = errobj[@"data"] && errobj[@"data"][@"statusDescription"] ? errobj[@"data"][@"statusDescription"] : nil;
      sperror.errors = errobj[@"errors"];
      return sperror;
  }

  return nil;
}

+ (NSString *)descriptionWithResponse:(NSDictionary *)dict {
  NSMutableString *s = [NSMutableString new];
  [s appendFormat:@"Name=%@\n", dict[@"name"] ?: @""];
  [s appendFormat:@"Message=%@\n", dict[@"message"] ?: @""];
  [s appendFormat:@"ClassName=%@\n", dict[@"className"] ?: @""];
  [s appendFormat:@"StatusCode=%@\n",
                  dict[@"data"] && dict[@"data"][@"statusCode"]
                      ? dict[@"data"][@"statusCode"]
                      : @""];
  [s appendFormat:@"StatusDescription=%@\n",
                  dict[@"data"] && dict[@"data"][@"statusDescription"]
                      ? dict[@"data"][@"statusDescription"]
                      : @""];
  [s appendFormat:@"Errors=%@\n", dict[@"errors"] ?: @""];
  return s;
}

@end
