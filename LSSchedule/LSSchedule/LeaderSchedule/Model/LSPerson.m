//
//  LSPerson.m
//  LSchedule
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSPerson.h"

@implementation LSPerson

+ (NSString *)dbName {
    
    return @"LSDataBase";
}

+ (NSString *)tableName {
    
    return NSStringFromClass([LSPerson class]);
}

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSArray *)persistentProperties {
    
    return [[[LSPerson  alloc] init] getAllProperties];
}

@end

@implementation LSUser

+ (NSString *)dbName {
    
    return @"LSDataBase";
}

+ (NSString *)tableName {
    
    return NSStringFromClass([LSUser class]);
}

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSArray *)persistentProperties {
    
    return [[[LSPerson  alloc] init] getAllProperties];
}

+(NSMutableArray<LSUser*>*)parserAndSaveUsers:(NSArray<NSDictionary*>*)infos{

    if (![infos isKindOfClass:[NSArray class]]) {
        NSLog(@"解析不合法数据结构的人员信息");
        return [NSMutableArray array];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in infos) {
        LSUser* user = [[LSUser alloc] init];
        
        for (id key in [self persistentProperties]) {//遍历自己的属性， 逐个赋值
            if (dic[key]) [user setValue:dic[key] forKey:key];
        }
        
        [array addObject:user];
        [user save];
        
        NSLog(@"-----------%@", NSHomeDirectory());
    }
    
    return array;
}

+(BOOL)canCreateSchedule{
    NSString* query = [NSString stringWithFormat:@"where mobile like %@", kLSTempPhoneNumber];
    NSArray* array = [LSUser objectsWhere:query arguments:nil];
    if (array.count == 0) {
        return NO;
    }
    LSUser* user = (LSUser*)[array lastObject];
    
    return [user.role integerValue] == 1;
}

+(LSUser*)currentUser{
    NSString* query = [NSString stringWithFormat:@"where mobile like %@", kLSTempPhoneNumber];
    NSArray* array = [LSUser objectsWhere:query arguments:nil];
    if (array.count == 0) {
        return nil;
    }
    LSUser* user = (LSUser*)[array lastObject];
    
    return user;
}

@end

@implementation LSLeader

+ (NSString *)dbName {
    
    return @"LSDataBase";
}

+ (NSString *)tableName {
    
    return NSStringFromClass([LSLeader class]);
}

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSArray *)persistentProperties {
    
    return [[[LSPerson  alloc] init] getAllProperties];
}

+(NSMutableArray<LSLeader*>*)parserAndSaveLeaders:(NSArray<NSDictionary*>*)infos{
    
    if (![infos isKindOfClass:[NSArray class]]) {
        NSLog(@"解析不合法数据结构的人员信息");
        return [NSMutableArray array];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in infos) {
        LSLeader* leader = [[LSLeader alloc] init];
        
        for (id key in [self persistentProperties]) {//遍历自己的属性， 逐个赋值
            if (dic[key]) [leader setValue:dic[key] forKey:key];
        }
        
        [array addObject:leader];
        [leader save];
    }
    
    return array;
}

+(NSMutableArray<LSLeader*>*)queryLeaders{
    NSArray* array = [LSLeader objectsWhere:@"where length(userId) > 0 order by sort" arguments:nil];
    return array ? [NSMutableArray arrayWithArray:array] : nil;
}

@end
