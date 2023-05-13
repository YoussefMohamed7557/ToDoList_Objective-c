//
//  Task.m
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import "Task.h"

@implementation Task
-(void) initBYName:(NSString*)name AndDetails:(NSString*)details AndPriority:(NSString*) priority AndSatrtDate:(NSString*) startDate AndState:(NSString*)stete AndDeadline:(NSString*) deadline{
    _taskName = name;
    _taskDetails = details;
    _taskPriority = priority;
    _taskStartDate = startDate;
    _taskDeadline = deadline;
    _taskState = stete;
}

@end
