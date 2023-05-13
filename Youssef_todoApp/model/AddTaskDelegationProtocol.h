//
//  AddTaskDelegationProtocol.h
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import <Foundation/Foundation.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AddTaskDelegationProtocol
-(void) addTask:(Task*)task;
@end

NS_ASSUME_NONNULL_END
