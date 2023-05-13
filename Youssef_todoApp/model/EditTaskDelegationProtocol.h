//
//  EditTaskDelegationProtocol.h
//  Youssef_todoApp
//
//  Created by Youssef on 06/05/2023.
//

#import <Foundation/Foundation.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EditTaskDelegationProtocol <NSObject>
-(void) editTask:(Task*)task isStateEditted:(BOOL) stateIsEditted;
@end

NS_ASSUME_NONNULL_END
