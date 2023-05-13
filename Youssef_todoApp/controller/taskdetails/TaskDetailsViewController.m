//
//  TaskDetailsViewController.m
//  Youssef_todoApp
//
//  Created by Youssef on 30/04/2023.
//

#import "TaskDetailsViewController.h"

@interface TaskDetailsViewController ()

@end

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskIsEditted = NO;
    _taskStateIsEditted = NO;
    [self initUi];
    [self setNavigationContent];
}
-(void) initUi{
    _taskNameLabel.text = _task.taskName;
    _taskDetailsTextView.text = _task.taskDetails;
    _taskDeadlinLabel.text =_task.taskDeadline;
    _taskSatrtDateLabel.text = _task.taskStartDate;
    _taskStateLabe.text = _task.taskState;
    _taskPrioritylabel.text  =_task.taskPriority;
}
-(void) setNavigationContent{
    self.navigationItem.title  = @"Task Details";
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *back= [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(customBack)];
    UIBarButtonItem *edite= [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonAction)];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
    [self.navigationItem setRightBarButtonItem:edite];
}
-(void) customBack{
        [_updateTaskAfterEdittingDelegationProtocolRef putUpdatedTask:_task atIndex:_taskIndex isStateEditted:_taskStateIsEditted];
        [self.navigationController popViewControllerAnimated:YES];    
}
-(void) editBarButtonAction{
    EditTaskViewContoller* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewContoller"];
    [vc setTask:_task];
    [vc setEditTaskDelegationProtocolRef:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editTask:(nonnull Task *)task isStateEditted:(BOOL)stateIsEditted{
    _taskIsEditted = YES;
    _taskStateIsEditted = stateIsEditted;
    _task = task;
    [self initUi];
}


@end
