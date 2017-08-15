//
//  LSAgendaModel.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSAgendaModel.h"
#import "LSUtils.h"
#import "MJExtension.h"

@implementation LSAgendaModel

#pragma mark - NSCopying
/*
- (id)copyWithZone:(nullable NSZone *)zone {
    LSAgendaModel *model = [[[self class] allocWithZone:zone] init];
    model.leaders = [self.leaders mutableCopy];
    //一个个字段写？
    

    return model;
}
*/

+(LSAgendaModel*)copyModel:(LSAgendaModel*)model{

    return (LSAgendaModel*)[LSAgendaModel mj_objectWithKeyValues:[model mj_keyValues]];
}

/*  不把这些属性转换出来
+(NSArray *)mj_ignoredPropertyNames{

    return @[@"", @"", @""];
}
*/

//SELECT 字段列表 FROM 表名 WHERE 条件 ORDER BY 字段名1 [ASC|DESC][,字段名2 [ASC|DESC]...]; 如果不指明排序顺序，默认的排序顺序为升序ASC。如果要降序，必须书写DESC关键字
+(NSArray<LSAgendaModel*>*)queryModelsDate:(NSDate*)date{

    NSString* where = [NSString stringWithFormat:@"where startTime like '%%%@%%' order by startTime,endTime", [LSUtils stringFromDate:date format:@"yyyy-MM-dd"]];
    NSArray* array = [LSAgendaModel objectsWhere:where arguments:nil];
    return array;
}

/**
 通过日期和领导id 查询对应日程
 
 @param date 日期  格式  2020-12-12
 @param leadersId 根据后台返回数据样式，领导之间是用空格分开的，可能好几个空格，不确定
 @return 对应天的日程数组
 */
+(NSArray<LSAgendaModel*>*)queryModelsDate:(NSDate*)date leadersId:(NSString*)leadersId{

    NSArray<LSAgendaModel*>* queryModels = [self queryModelsDate:date];
    if (queryModels.count == 0) {
        return @[];
    }
    
    //如果人员ID是空，那么全量返回
    if (!leadersId || leadersId.length == 0) {
        return queryModels;
    }
    
    NSArray* leaderIDs = [leadersId componentsSeparatedByString:@" "];
    if (leaderIDs.count == 0) {
        return @[];
    }
    
    NSMutableSet* set = [NSMutableSet setWithArray:leaderIDs];
    if ([set containsObject:@""]) {
        [set removeObject:@""];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (LSAgendaModel* model in queryModels) {
        
        NSArray* originLeaderIDs = [model.leadersId componentsSeparatedByString:@" "];
        NSMutableSet* originSet = [NSMutableSet setWithArray:originLeaderIDs];
        if ([originSet containsObject:@""]) {
            [originSet removeObject:@""];
        }
        if (originLeaderIDs.count > 0 && [originSet intersectsSet:set]) {
//            [originSet intersectsSet:set]//是否有交集          我们公司的刷选逻辑
//            [set isSubsetOfSet:originSet] A 是否是 B的子集     淘宝的筛选逻辑
            [array addObject:model];
        }
    }
    
    return array;
}

/**
 查询合法日程数据
 
 @param date 日期  格式  2020-12-12
 @param leadersId 根据后台返回数据样式，领导之间是用空格分开的，可能好几个空格，不确定
 @return 对应天的日程数组
 */
+(NSArray<LSAgendaModel*>*)queryLegalModelsDate:(NSDate*)date leadersId:(NSString*)leadersId{
    NSMutableArray* queryModels = [NSMutableArray arrayWithArray:[self queryModelsDate:date leadersId:leadersId]];
    
    //据说这个视图要删除开始时间大于结束时间的日程
    NSMutableArray* tempArr = [NSMutableArray array];
    for (LSAgendaModel* tempModel in queryModels) {
        
        NSString* start_time = tempModel.startTime.length > 16 ? [tempModel.startTime substringToIndex:16] : tempModel.startTime;
        NSString* end_time = tempModel.endTime.length > 16 ? [tempModel.endTime substringToIndex:16] : tempModel.endTime;
        
        if ([start_time compare:end_time] != NSOrderedAscending) {
            [tempArr addObject:tempModel];
        }
    }
    
    for (id obj in tempArr) {
        if([queryModels containsObject:obj]) [queryModels removeObject:obj];
    }

    return queryModels;
}

+(NSString*)holidays{

    NSString* holidays = [[NSUserDefaults standardUserDefaults] stringForKey:@"holidays"];
    
    return holidays ? : @"";
}

#pragma mark -
#pragma mark - getter

#pragma mark -
#pragma mark - setter

//实现了这个方法，那么不存在的key  去setValue 也不会崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setMeetType:(NSString *)meetType{
    
    if ([meetType isEqualToString:@"会议"]) {
        self.shType = 0;
    }else if ([meetType isEqualToString:@"活动"]) {
        self.shType = 1;
    }else if ([meetType isEqualToString:@"其他"]) {
        self.shType = 2;
    }else{
        self.shType = 0;
    }
}


-(NSString *)meetType{
    switch (self.shType) {
        case 0:
            return @"会议";
            break;
        case 1:
            return @"活动";
            break;
        case 2:
            return @"其他";
            break;
            
        default:
            return @"其他";
            break;
    }
}

+(NSMutableArray<LSAgendaModel *> *)forgeDataSource{
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        LSAgendaModel* model = [[LSAgendaModel alloc] init];
        model.noId = [NSString stringWithFormat:@"%@", @(arc4random() % 100000 + 10000)];
        model.startTime = @"2017-05-02 09:00:00.0";
        model.endTime = @"2017-05-02 10:00:00.0";
        model.content = @"[会议]今天两点60有会";
        model.meetType = @"会议";
        model.leaders = @"戴忠;方力;杨林";
        model.address = @"朝阳门悠唐生活广场";
        model.remark = @"只要我能控制一个国家的货币发行，我不在乎谁制订法律。";
        
        [array addObject:model];
    }
    
    return array;
}


#pragma mark -
#pragma mark - dataBase
+ (NSString *)dbName {
    
    return @"LSDataBase";
}

+ (NSString *)tableName {
    
    return NSStringFromClass([LSAgendaModel class]);
}

+ (NSString *)primaryKey {
    return @"noId";
}

+ (NSArray *)persistentProperties {
   
    return [[[LSAgendaModel alloc] init] getAllProperties];
}

//获取固定时间段的领导日程
+(void)asyncGetAgendaListStartTime:(NSTimeInterval)startTime
                           endTime:(NSTimeInterval)endTime
                      successBlock:(void(^)(NSMutableDictionary* data))successBlock
                      failureBlock:(void(^)(id msg, ERequestState state))failureBlock{

    BOOL useLocalData = [[NSUserDefaults standardUserDefaults] boolForKey:@"useLocalData"];
    if (useLocalData) {
        if(successBlock) successBlock([self forgeDataSource1]);
        
        return;
    }
    
//    kLSBaseURL = @"hangyanBaseUrl";
    NSString* url = @"lschedule_xinmei/draSchedule.do";
    
    [LSRequest cancelTaskUrl:url];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"startTime"] = @(startTime);
    params[@"endTime"] = @(endTime);
    params[@"draType"] = @"dra-ajax";
    params[@"cmd"] = @"initSchedule";
    //    dic[@"password"] = @"123456";
    params[@"holiday"] = @"true";
    params[@"isleaders"] = @"true";
    
    [self asyncGetUrl:url param:params successBlock:^(id resObj) {
        
//        如果请求成功，那么目前没有删除的更新接口，为了满足删除的需求，直接清空本地当月的数据
        [self deleteModelsTimeInterval:startTime];
        
        if(successBlock)successBlock([self parserServerData:resObj]);
    } failureBlock:^(id msg, ERequestState state) {
        if(failureBlock) failureBlock(msg, state);
    }];

}

//读取一波假数据，因为接口还没对上
+(NSMutableDictionary*)forgeDataSource1{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TempData" ofType:@".json"];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSError* error = nil;
    if (!data) {
        return nil;
    }
    NSDictionary* originInfo = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:&error];
    
    NSLog(@"本地数据%@", originInfo);
    
    return [self parserServerData:originInfo];
}

+(NSMutableDictionary*)parserServerData:(NSDictionary*)originInfo{
    NSMutableDictionary* dataInfo = [NSMutableDictionary dictionary];
    
    for (NSString* key in originInfo) {
        if ([key isEqualToString:@"holidays"]) {
            dataInfo[@"holidays"] = originInfo[@"holidays"];
            [[NSUserDefaults standardUserDefaults] setObject:[LSUtils getAbsolutText:originInfo[@"holidays"]] forKey:@"holidays"];
        }else if ([key isEqualToString:@"leaders"]){
            dataInfo[@"leaders"] = [LSLeader parserAndSaveLeaders:originInfo[@"leaders"]];
        }else if ([key isEqualToString:@"user"]){
            dataInfo[@"user"] = [LSUser parserAndSaveUsers:originInfo[@"user"]];
        }else if ([key isEqualToString:@"schedule"]){
            dataInfo[@"schedule"] = [LSAgendaModel parserAndSaveAgenda:originInfo[@"schedule"]];
        }
        
    }
    
    return dataInfo;
}

+(void)deleteModelsTimeInterval:(NSTimeInterval)timeInterval{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    NSString* where = [NSString stringWithFormat:@"where startTime like '%%%@%%'", [LSUtils stringFromDate:date format:@"yyyy-MM"]];
    
    [LSAgendaModel deleteObjectsWhere:where arguments:nil];
}

+(NSMutableArray<LSAgendaModel*>*)parserAndSaveAgenda:(NSArray<NSDictionary*>*)infos{
    
    if (![infos isKindOfClass:[NSArray class]]) {
        NSLog(@"解析不合法数据结构的日程信息");
        return [NSMutableArray array];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in infos) {
//        LSAgendaModel* model = [[LSAgendaModel alloc] init];
////        for (id key in dic) {//遍历字典， 逐个赋值，因为实现了-(void)setValue:(id)value forUndefinedKey:(NSString *)key 所以不用担心找不到key崩溃的问题
//        for (id key in [self persistentProperties]) {//遍历自己的属性， 逐个赋值
//            NSLog(@"=======%@  key ::::: %@", dic[key], key);// && ![key isEqualToString:@"holiday"]
//            if (dic[key]) [model setValue:dic[key] forKey:key];
//        }
        
        [LSAgendaModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"shType": @"type"};
        }];
        
        LSAgendaModel* model = [LSAgendaModel mj_objectWithKeyValues:dic];
        if (model) {
            [array addObject:model];
            [model save];
        }
        
    }
    
    return array;
}


//新增或者修改日程   当id存在的时候就是修改
+(void)asyncUpdateAgendaInfo:(LSAgendaModel*)model
                successBlock:(void(^)(id data))successBlock
                failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
//    kLSBaseURL = @"hangyanBaseUrl";
    NSString* url = @"lschedule_xinmei/draSchedule.do";
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[model getAllPropertyKeyValues]];
    
    //修改还是更新
    if (model.noId) {
        params[@"type"] = @"update";
        params[@"id"] = model.noId;
        [params removeObjectForKey:@"agendaId"];
    }else{
        params[@"type"] = @"add";
    }
    //固定参数
    params[@"draType"] = @"dra-ajax";
    params[@"cmd"] = @"addorUpdateSchedule";
    params[@"isHoliday"] = @(model.holiday);
    
    //创建人ID
    LSUser* user = [LSUser currentUser];
    params[@"creator"] = [NSString stringWithFormat:@"%@", user.name];
    params[@"creatorId"] = [NSString stringWithFormat:@"%@", user.userId];

    //开始时间
    NSDate* startDate = [LSUtils serverDateFromString:model.startTime];
    if (!startDate) {//如果不是服务器的时间格式，那么用我们自己的时间格式化
        startDate = [LSUtils dateFormString:model.startTime format:@"yyyy-MM-dd HH:mm:ss"];
    }
    params[@"startTime"] = @([startDate timeIntervalSince1970] * 1000);// @"1493946000000";
    
    //结束时间
    NSDate* endDate = [LSUtils serverDateFromString:model.endTime];
    if (!endDate) {//如果不是服务器的时间格式，那么用我们自己的时间格式化
        endDate = [LSUtils dateFormString:model.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    }
    params[@"endTime"] = @([endDate timeIntervalSince1970] * 1000);// @"1493978400000";

    if (!model.leaders || model.leaders.length == 0) {
        params[@"leaders"] = @"";
        params[@"leadersId"] = @"";
        params[@"pending"] = @"0";
    }else{
        params[@"pending"] = @"1";
    }
    

    [self asyncPostUrl:url param:params successBlock:^(id resObj) {
        
        [self parserAndSaveAgenda:resObj[@"schedule"]];
        
        if(successBlock)successBlock(resObj);
    } failureBlock:^(id msg, ERequestState state) {
        if(failureBlock) failureBlock(msg, state);
    }];
}

//删除日程
+(void)asyncDeleteAgendaById:(NSString*)agendaId
                successBlock:(void(^)(id data))successBlock
                failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
//    kLSBaseURL = @"hangyanBaseUrl";
    NSString* url = @"lschedule_xinmei/draSchedule.do";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"draType"] = @"dra-ajax";
    params[@"cmd"] = @"deleteSchedule";
    params[@"id"] = agendaId;

    [self asyncPostUrl:url param:params successBlock:^(id resObj) {
        if(successBlock)successBlock(resObj);
    } failureBlock:^(id msg, ERequestState state) {
        if(failureBlock) failureBlock(msg, state);
    }];
}




@end
