//
//  ViewController.h
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "Task.h"
#import "AddTaskDelegationProtocol.h"
#import "AddtaskViewController.h"
#import "TaskDetailsViewController.h"
#import "UpdateTaskAfterEdittingDelegationProtocol.h"
@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,AddTaskDelegationProtocol,UpdateTaskAfterEdittingDelegationProtocol,UISearchBarDelegate>

@property NSMutableArray* todoNamesArr;
@property NSMutableArray* todoDetailsArr;
@property NSMutableArray* todoPriorityArr;
@property NSMutableArray* todoStartDateArr;
@property NSMutableArray* todoDeadlinesArr;
@property NSMutableArray* todoStatesArr;

@property NSMutableArray* inProgressNamesArr;
@property NSMutableArray* inProgressDetailsArr;
@property NSMutableArray* inProgressPriorityArr;
@property NSMutableArray* inProgressStartDateArr;
@property NSMutableArray* inProgressDeadlinesArr;
@property NSMutableArray* inProgressStatesArr;

@property NSMutableArray* doneNamesArr;
@property NSMutableArray* doneDetailsArr;
@property NSMutableArray* donePriorityArr;
@property NSMutableArray* doneStartDateArr;
@property NSMutableArray* doneDeadlinesArr;
@property NSMutableArray* doneStatesArr;

@property NSMutableArray* toDoList;
@property NSMutableArray* inprogressList;
@property NSMutableArray* doneList;

@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statesSegmentView;
@property (weak, nonatomic) IBOutlet UISearchBar *taskSearchBar;

@property NSUserDefaults* backupData;

@end

