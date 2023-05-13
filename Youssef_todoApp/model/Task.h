//
//  Task.h
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject
@property NSString* taskName;
@property NSString* taskDetails;
@property NSString* taskPriority;
@property NSString* taskStartDate;
@property NSString* taskState;
@property NSString* taskDeadline;
-(void) initBYName:(NSString*)name AndDetails:(NSString*)details AndPriority:(NSString*) priority AndSatrtDate:(NSString*) startDate AndState:(NSString*)stete AndDeadline:(NSString*) deadline;

@end

NS_ASSUME_NONNULL_END
