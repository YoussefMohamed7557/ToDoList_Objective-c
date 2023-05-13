//
//  TaskDetailsViewController.h
//  Youssef_todoApp
//
//  Created by Youssef on 30/04/2023.
//

#import <UIKit/UIKit.h>
#import"Task.h"
#import "EditTaskViewContoller.h"
#import "EditTaskDelegationProtocol.h"
#import "UpdateTaskAfterEdittingDelegationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskDetailsViewController : UIViewController<EditTaskDelegationProtocol>
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskSatrtDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDeadlinLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskPrioritylabel;
@property (weak, nonatomic) IBOutlet UILabel *taskStateLabe;
@property (weak, nonatomic) IBOutlet UITextView *taskDetailsTextView;
@property id <UpdateTaskAfterEdittingDelegationProtocol> updateTaskAfterEdittingDelegationProtocolRef;
@property Task* task;
@property NSInteger taskIndex;
@property BOOL taskIsEditted;
@property BOOL taskStateIsEditted;
@end

NS_ASSUME_NONNULL_END
