//
//  NSDictionary+Extras.h
//
//  Copyright (c) 2017-2020 Seamless Payments, Inc. All Rights Reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extras)

- (NSDictionary *)sp_dictionaryByRemovingNulls;

- (NSDictionary<NSString *, NSString *> *)sp_dictionaryByRemovingNonStrings;

// Getters

- (nullable NSArray *)sp_arrayForKey:(NSString *)key;

- (BOOL)sp_boolForKey:(NSString *)key or:(BOOL)defaultValue;

- (nullable NSDate *)sp_dateForKey:(NSString *)key;

- (nullable NSDictionary *)sp_dictionaryForKey:(NSString *)key;

- (NSInteger)sp_intForKey:(NSString *)key or:(NSInteger)defaultValue;

- (nullable NSNumber *)sp_numberForKey:(NSString *)key;

- (nullable NSString *)sp_stringForKey:(NSString *)key;

- (nullable NSURL *)sp_urlForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

void linkNSDictionaryCategory(void);
