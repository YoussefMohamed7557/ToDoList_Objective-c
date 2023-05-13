//
//  EditTaskViewContoller.h
//  Youssef_todoApp
//
//  Created by Youssef on 06/05/2023.
//

#import <UIKit/UIKit.h>
#import "EditTaskDelegationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditTaskViewContoller : UIViewController
@property NSArray* prioritiesArray;
@property NSArray* statesArray;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *statePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *priorityPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *taskDetailsTextView;
@property NSString* selectedPriority;
@property NSString* selectedState;
@property id <EditTaskDelegationProtocol> editTaskDelegationProtocolRef;
@property Task* task;
@end

NS_ASSUME_NONNULL_END
