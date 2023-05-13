//
//  AddtaskViewController.h
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import <UIKit/UIKit.h>
#import "AddTaskDelegationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddtaskViewController : UIViewController<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property NSArray* prioritiesArray;
@property NSArray* statesArray;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *priorityPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *statesPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadlinDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *taskDetailsTextView;
@property NSString* selectedPriority;
@property NSString* selectedState;
@property id <AddTaskDelegationProtocol> addTaskDelegationProtocolRef;
@end

NS_ASSUME_NONNULL_END
