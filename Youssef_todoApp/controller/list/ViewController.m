//
//  ViewController.m
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import "ViewController.h"

@interface ViewController ()
@end

const NSString *cellID = @"CustomCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSettings];
}
-(void)viewWillAppear:(BOOL)animated{
    [_tasksTableView reloadData];
}
-(void) initialSettings{
    [self.tasksTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self castListArraysFromIdToArrayOfTasks];
    _backupData = [NSUserDefaults standardUserDefaults];
    [self retrieveToDoBackupArrays];
    [self retrieveInProgressBackupArrays];
    [self retrieveDoneBackupArrays];
    [self restoreLists];
    [_tasksTableView reloadData];
}

- (IBAction)goToAddTaskScreen:(UIBarButtonItem *)sender {
    AddtaskViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddtaskViewController"];
    vc.addTaskDelegationProtocolRef = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            return [_toDoList count];
            break;
        case 1:
            return [_inprogressList count];
            break;
        case 2:
            return [_doneList count];
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell  = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"] ;
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            cell.nameLabel.text = [[_toDoList objectAtIndex:indexPath.row] taskName];
            cell.deadlineLabel.text = @"  Deadline: ";
            cell.deadlineLabel.text  = [cell.deadlineLabel.text stringByAppendingString:[[_toDoList objectAtIndex:indexPath.row] taskDeadline]];
            
            cell.startDateLabel.text = @"  Start: ";
            cell.startDateLabel.text  = [cell.startDateLabel.text stringByAppendingString:[[_toDoList objectAtIndex:indexPath.row] taskStartDate]];
    
            if ([[[_toDoList objectAtIndex:indexPath.row] taskPriority] isEqual:@"High"]) {
                cell.priorityView.backgroundColor = [UIColor redColor];
            }else if ([[[_toDoList objectAtIndex:indexPath.row]taskPriority] isEqual:@"Middle"]) {
                cell.priorityView.backgroundColor = [UIColor blueColor];
            }else{
                cell.priorityView.backgroundColor = [UIColor greenColor];
            }
            break;
        case 1:
            cell.nameLabel.text = [[_inprogressList objectAtIndex:indexPath.row] taskName];
            cell.deadlineLabel.text = @"  Deadline: ";
            cell.deadlineLabel.text  = [cell.deadlineLabel.text stringByAppendingString:[[_inprogressList objectAtIndex:indexPath.row] taskDeadline]];
            
            cell.startDateLabel.text = @"  Start: ";
            cell.startDateLabel.text  = [cell.startDateLabel.text stringByAppendingString:[[_inprogressList objectAtIndex:indexPath.row] taskStartDate]];
            
            if ([[[_inprogressList objectAtIndex:indexPath.row] taskPriority] isEqual:@"High"]) {
                cell.priorityView.backgroundColor = [UIColor redColor];
            }else if ([[[_inprogressList objectAtIndex:indexPath.row] taskPriority] isEqual:@"Middle"]) {
                cell.priorityView.backgroundColor = [UIColor blueColor];
            }else{
                cell.priorityView.backgroundColor = [UIColor greenColor];
            }
            break;
        case 2:
            cell.nameLabel.text = [[_doneList objectAtIndex:indexPath.row] taskName];
            
            cell.deadlineLabel.text = @"  Deadline: ";
            cell.deadlineLabel.text  = [cell.deadlineLabel.text stringByAppendingString:[[_doneList objectAtIndex:indexPath.row] taskDeadline]];
            
            cell.startDateLabel.text = @"  Start: ";
            cell.startDateLabel.text  = [cell.startDateLabel.text stringByAppendingString:[[_doneList objectAtIndex:indexPath.row] taskStartDate]];
            
            if ([[[_doneList objectAtIndex:indexPath.row] taskPriority] isEqual:@"High"]) {
                cell.priorityView.backgroundColor = [UIColor redColor];
            }else if ([[[_doneList objectAtIndex:indexPath.row]taskPriority] isEqual:@"Middle"]) {
                cell.priorityView.backgroundColor = [UIColor blueColor];
            }else{
                cell.priorityView.backgroundColor = [UIColor greenColor];
            }
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    Task *t = [Task new];
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            [t initBYName:[[_toDoList objectAtIndex:indexPath.row] taskName] AndDetails:[[_toDoList objectAtIndex:indexPath.row] taskDetails] AndPriority:[[_toDoList objectAtIndex:indexPath.row] taskPriority] AndSatrtDate:[[_toDoList objectAtIndex:indexPath.row] taskStartDate] AndState:[[_toDoList objectAtIndex:indexPath.row] taskState] AndDeadline:[[_toDoList objectAtIndex:indexPath.row] taskDeadline]];
            break;
        case 1:
            [t initBYName:[[_inprogressList objectAtIndex:indexPath.row] taskName] AndDetails:[[_inprogressList objectAtIndex:indexPath.row] taskDetails] AndPriority:[[_inprogressList objectAtIndex:indexPath.row] taskPriority] AndSatrtDate:[[_inprogressList objectAtIndex:indexPath.row] taskStartDate] AndState:[[_inprogressList objectAtIndex:indexPath.row] taskState] AndDeadline:[[_inprogressList objectAtIndex:indexPath.row] taskDeadline]];
            break;
        case 2:
            [t initBYName:[[_doneList objectAtIndex:indexPath.row] taskName] AndDetails:[[_doneList objectAtIndex:indexPath.row] taskDetails] AndPriority:[[_doneList objectAtIndex:indexPath.row] taskPriority] AndSatrtDate:[[_doneList objectAtIndex:indexPath.row] taskStartDate] AndState:[[_doneList objectAtIndex:indexPath.row] taskState] AndDeadline:[[_doneList objectAtIndex:indexPath.row] taskDeadline]];
            
            break;
        default:
            break;
    }
    [self removeTaskAtIndex:indexPath.row];
    TaskDetailsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailsViewController"];
    vc.task = t;
    vc.updateTaskAfterEdittingDelegationProtocolRef= self;
    vc.taskIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction* deletItem = [UIContextualAction contextualActionWithStyle:normal title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self removeTaskAtIndex:indexPath.row];
        [self->_tasksTableView reloadData];
    }];
    deletItem.backgroundColor = [UIColor systemRedColor];
    deletItem.image = [UIImage systemImageNamed:@"trash"];
    UISwipeActionsConfiguration* swip = [UISwipeActionsConfiguration configurationWithActions:@[deletItem]];
    return  swip;
}
//@"To Do",@"In Progress",@"Done"
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction* todo_inProgressMove = [UIContextualAction contextualActionWithStyle:normal title:@"In Progress" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Task* task = [Task new];
        task = [self->_toDoList objectAtIndex:indexPath.row];
        [self removeTaskAtIndex:indexPath.row];
        task.taskState = @"In Progress";
        [self->_inProgressNamesArr addObject:task.taskName];
        [self->_inProgressDetailsArr addObject:task.taskDetails];
        [self->_inProgressPriorityArr addObject:task.taskPriority];
        [self->_inProgressStatesArr addObject:task.taskState];
        [self->_inProgressStartDateArr addObject:task.taskStartDate];
        [self->_inProgressDeadlinesArr addObject:task.taskDeadline];
        [self->_inprogressList addObject:task];
        [self saveInProgressBackupArrays];
        [self saveToDoBackupArrays];
        [self->_tasksTableView reloadData];
    }];
    todo_inProgressMove.backgroundColor = [UIColor systemBlueColor];
    todo_inProgressMove.image = [UIImage systemImageNamed:@"cursorarrow.rays"];
    
    UIContextualAction* todo_doneMove = [UIContextualAction contextualActionWithStyle:normal title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Task* task = [Task new];
        task = [self->_toDoList objectAtIndex:indexPath.row];
        [self removeTaskAtIndex:indexPath.row];
        task.taskState = @"Done";
        [self->_doneNamesArr addObject:task.taskName];
        [self->_doneDetailsArr addObject:task.taskDetails];
        [self->_donePriorityArr addObject:task.taskPriority];
        [self->_doneStatesArr addObject:task.taskState];
        [self->_doneStartDateArr addObject:task.taskStartDate];
        [self->_doneDeadlinesArr addObject:task.taskDeadline];
        [self->_doneList addObject:task];
        [self saveDoneBackupArrays];
        [self saveToDoBackupArrays];
        [self->_tasksTableView reloadData];
    }];
    todo_doneMove.backgroundColor = [UIColor systemGreenColor];
    todo_doneMove.image = [UIImage systemImageNamed:@"hand.thumbsup.fill"];
    
    UIContextualAction* inProgress_doneMove = [UIContextualAction contextualActionWithStyle:normal title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Task* task = [Task new];
        task = [self->_inprogressList objectAtIndex:indexPath.row];
        [self removeTaskAtIndex:indexPath.row];
        task.taskState = @"Done";
        [self->_doneNamesArr addObject:task.taskName];
        [self->_doneDetailsArr addObject:task.taskDetails];
        [self->_donePriorityArr addObject:task.taskPriority];
        [self->_doneStatesArr addObject:task.taskState];
        [self->_doneStartDateArr addObject:task.taskStartDate];
        [self->_doneDeadlinesArr addObject:task.taskDeadline];
        [self->_doneList addObject:task];
        [self saveDoneBackupArrays];
        [self saveInProgressBackupArrays];
        [self->_tasksTableView reloadData];
    }];
    inProgress_doneMove.backgroundColor = [UIColor systemGreenColor];
    inProgress_doneMove.image = [UIImage systemImageNamed:@"hand.thumbsup.fill"];
    
    UIContextualAction* deletItem = [UIContextualAction contextualActionWithStyle:normal title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [self removeTaskAtIndex:indexPath.row];
                [self->_tasksTableView reloadData];
    }];
    deletItem.backgroundColor = [UIColor systemRedColor];
    deletItem.image = [UIImage systemImageNamed:@"trash"];
    UISwipeActionsConfiguration* swip;
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            swip = [UISwipeActionsConfiguration configurationWithActions:@[todo_inProgressMove,todo_doneMove]];
            break;
        case 1:
            swip = [UISwipeActionsConfiguration configurationWithActions:@[inProgress_doneMove]];
            break;
        case 2:
            swip = [UISwipeActionsConfiguration configurationWithActions:@[deletItem]];
            break;
        default:
            break;
    }
    return  swip;
}
- (IBAction)onStateChanged:(id)sender {
    [_tasksTableView reloadData];
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            self.title = @"To Do List";
            break;
        case 1:
            self.title = @"In Progress List";
            break;
        case 2:
            self.title = @"Done List";
            break;
        default:
            break;
    }
}

- (void)addTask:(nonnull Task *)task {
    if([task.taskState isEqual:@"To Do"]){
        [_todoNamesArr addObject:task.taskName];
        [_todoDetailsArr addObject:task.taskDetails];
        [_todoPriorityArr addObject:task.taskPriority];
        [_todoStatesArr addObject:task.taskState];
        [_todoStartDateArr addObject:task.taskStartDate];
        [_todoDeadlinesArr addObject:task.taskDeadline];
        [_toDoList addObject:task];
        [self saveToDoBackupArrays];
    }else if ([task.taskState isEqual:@"In Progress"]){
        [_inProgressNamesArr addObject:task.taskName];
        [_inProgressDetailsArr addObject:task.taskDetails];
        [_inProgressPriorityArr addObject:task.taskPriority];
        [_inProgressStatesArr addObject:task.taskState];
        [_inProgressStartDateArr addObject:task.taskStartDate];
        [_inProgressDeadlinesArr addObject:task.taskDeadline];
        [_inprogressList addObject:task];
        [self saveInProgressBackupArrays];
    }else{
        [_doneNamesArr addObject:task.taskName];
        [_doneDetailsArr addObject:task.taskDetails];
        [_donePriorityArr addObject:task.taskPriority];
        [_doneStatesArr addObject:task.taskState];
        [_doneStartDateArr addObject:task.taskStartDate];
        [_doneDeadlinesArr addObject:task.taskDeadline];
        [_doneList addObject:task];
        [self saveDoneBackupArrays];
    }
    [_tasksTableView reloadData];
}


- (void)putUpdatedTask:(nonnull Task *)task atIndex:(NSInteger)_index isStateEditted:(BOOL)stateIsEditted{
    if (stateIsEditted) {
        if([task.taskState isEqual:@"To Do"]){
            [_todoNamesArr addObject:task.taskName];
            [_todoDetailsArr addObject:task.taskDetails];
            [_todoPriorityArr addObject:task.taskPriority];
            [_todoStatesArr addObject:task.taskState];
            [_todoStartDateArr addObject:task.taskStartDate];
            [_todoDeadlinesArr addObject:task.taskDeadline];
            [_toDoList addObject:task];
            [self saveToDoBackupArrays];
        }else if ([task.taskState isEqual:@"In Progress"]){
            [_inProgressNamesArr addObject:task.taskName];
            [_inProgressDetailsArr addObject:task.taskDetails];
            [_inProgressPriorityArr addObject:task.taskPriority];
            [_inProgressStatesArr addObject:task.taskState];
            [_inProgressStartDateArr addObject:task.taskStartDate];
            [_inProgressDeadlinesArr addObject:task.taskDeadline];
            [_inprogressList addObject:task];
            [self saveInProgressBackupArrays];
        }else{
            [_doneNamesArr addObject:task.taskName];
            [_doneDetailsArr addObject:task.taskDetails];
            [_donePriorityArr addObject:task.taskPriority];
            [_doneStatesArr addObject:task.taskState];
            [_doneStartDateArr addObject:task.taskStartDate];
            [_doneDeadlinesArr addObject:task.taskDeadline];
            [_doneList addObject:task];
            [self saveDoneBackupArrays];
        }
    }else{
        if([task.taskState isEqual:@"To Do"]){
            [_todoNamesArr insertObject:task.taskName atIndex:_index];
            [_todoDetailsArr insertObject:task.taskDetails atIndex:_index];
            [_todoPriorityArr insertObject:task.taskPriority atIndex:_index];
            [_todoStatesArr insertObject:task.taskState atIndex:_index];
            [_todoStartDateArr insertObject:task.taskStartDate atIndex:_index];
            [_todoDeadlinesArr insertObject:task.taskDeadline atIndex:_index];
            [_toDoList insertObject:task atIndex:_index];
            [self saveToDoBackupArrays];
        }else if ([task.taskState isEqual:@"In Progress"]){
            [_inProgressNamesArr insertObject:task.taskName atIndex:_index];
            [_inProgressDetailsArr insertObject:task.taskDetails atIndex:_index];
            [_inProgressPriorityArr insertObject:task.taskPriority atIndex:_index];
            [_inProgressStatesArr insertObject:task.taskState atIndex:_index];
            [_inProgressStartDateArr insertObject:task.taskStartDate atIndex:_index];
            [_inProgressDeadlinesArr insertObject:task.taskDeadline atIndex:_index];
            [_inprogressList insertObject:task atIndex:_index];
            [self saveInProgressBackupArrays];
        }else{
            [_doneNamesArr insertObject:task.taskName atIndex:_index];
            [_doneDetailsArr insertObject:task.taskDetails atIndex:_index];
            [_donePriorityArr insertObject:task.taskPriority atIndex:_index];
            [_doneStatesArr insertObject:task.taskState atIndex:_index];
            [_doneStartDateArr insertObject:task.taskStartDate atIndex:_index];
            [_doneDeadlinesArr insertObject:task.taskDeadline atIndex:_index];
            [_doneList insertObject:task atIndex:_index];
            [self saveDoneBackupArrays];
        }
    }
    [_tasksTableView reloadData];
}
-(void) removeTaskAtIndex:(NSInteger) _index{
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            [_todoNamesArr removeObjectAtIndex:_index];
            [_todoDetailsArr removeObjectAtIndex:_index];
            [_todoStatesArr removeObjectAtIndex:_index];
            [_todoPriorityArr removeObjectAtIndex:_index];
            [_todoStartDateArr removeObjectAtIndex:_index];
            [_todoDeadlinesArr removeObjectAtIndex:_index];
            [_toDoList removeObjectAtIndex:_index];
            [self saveToDoBackupArrays];
            break;
        case 1:
            [_inProgressNamesArr removeObjectAtIndex:_index];
            [_inProgressDetailsArr removeObjectAtIndex:_index];
            [_inProgressStatesArr removeObjectAtIndex:_index];
            [_inProgressPriorityArr removeObjectAtIndex:_index];
            [_inProgressStartDateArr removeObjectAtIndex:_index];
            [_inProgressDeadlinesArr removeObjectAtIndex:_index];
            [_inprogressList removeObjectAtIndex:_index];
            [self saveInProgressBackupArrays];
            break;
        case 2:
            [_doneNamesArr removeObjectAtIndex:_index];
            [_doneDetailsArr removeObjectAtIndex:_index];
            [_doneStatesArr removeObjectAtIndex:_index];
            [_donePriorityArr removeObjectAtIndex:_index];
            [_doneStartDateArr removeObjectAtIndex:_index];
            [_doneDeadlinesArr removeObjectAtIndex:_index];
            [_doneList removeObjectAtIndex:_index];
            [self saveDoneBackupArrays];
            break;
        default:
            break;
    }
}
-(void) saveToDoBackupArrays{
    [_backupData setObject:_todoNamesArr forKey:@"_todoNamesArr"];
    [_backupData synchronize];
    [_backupData setObject:_todoDetailsArr forKey:@"_todoDetailsArr"];
    [_backupData synchronize];
    [_backupData setObject:_todoStatesArr forKey:@"_todoStatesArr"];
    [_backupData synchronize];
    [_backupData setObject:_todoPriorityArr forKey:@"_todoPriorityArr"];
    [_backupData synchronize];
    [_backupData setObject:_todoStartDateArr forKey:@"_todoStartDateArr"];
    [_backupData synchronize];
    [_backupData setObject:_todoDeadlinesArr forKey:@"_todoDeadlinesArr"];
    [_backupData synchronize];
}
-(void) retrieveToDoBackupArrays{
    if ([_backupData objectForKey:@"_todoNamesArr"] != nil){
    _todoNamesArr = [[_backupData objectForKey:@"_todoNamesArr"] mutableCopy];
    _todoDetailsArr = [[_backupData objectForKey:@"_todoDetailsArr"] mutableCopy];
    _todoStatesArr = [[_backupData objectForKey:@"_todoStatesArr"] mutableCopy];
    _todoPriorityArr = [[_backupData objectForKey:@"_todoPriorityArr"] mutableCopy];
    _todoStartDateArr = [[_backupData objectForKey:@"_todoStartDateArr"] mutableCopy];
    _todoDeadlinesArr = [[_backupData objectForKey:@"_todoDeadlinesArr"] mutableCopy];
    }
}
-(void) saveInProgressBackupArrays{
    [_backupData setObject:_inProgressNamesArr forKey:@"_inProgressNamesArr"];
    [_backupData synchronize];
    [_backupData setObject:_inProgressDetailsArr forKey:@"_inProgressDetailsArr"];
    [_backupData synchronize];
    [_backupData setObject:_inProgressStatesArr forKey:@"_inProgressStatesArr"];
    [_backupData synchronize];
    [_backupData setObject:_inProgressPriorityArr forKey:@"_inProgressPriorityArr"];
    [_backupData synchronize];
    [_backupData setObject:_inProgressStartDateArr forKey:@"_inProgressStartDateArr"];
    [_backupData synchronize];
    [_backupData setObject:_inProgressDeadlinesArr forKey:@"_inProgressDeadlinesArr"];
    [_backupData synchronize];
}
-(void) retrieveInProgressBackupArrays{
    if ([_backupData objectForKey:@"_inProgressNamesArr"] != nil){
    _inProgressNamesArr = [[_backupData objectForKey:@"_inProgressNamesArr"] mutableCopy];
    _inProgressDetailsArr = [[_backupData objectForKey:@"_inProgressDetailsArr"] mutableCopy];
    _inProgressStatesArr = [[_backupData objectForKey:@"_inProgressStatesArr"] mutableCopy];
    _inProgressPriorityArr = [[_backupData objectForKey:@"_inProgressPriorityArr"] mutableCopy];
    _inProgressStartDateArr = [[_backupData objectForKey:@"_inProgressStartDateArr"] mutableCopy];
    _inProgressDeadlinesArr = [[_backupData objectForKey:@"_inProgressDeadlinesArr"] mutableCopy];
    }
}
-(void) saveDoneBackupArrays{
    [_backupData setObject:_doneNamesArr forKey:@"_doneNamesArr"];
    [_backupData synchronize];
    [_backupData setObject:_doneDetailsArr forKey:@"_doneDetailsArr"];
    [_backupData synchronize];
    [_backupData setObject:_doneStatesArr forKey:@"_doneStatesArr"];
    [_backupData synchronize];
    [_backupData setObject:_donePriorityArr forKey:@"_donePriorityArr"];
    [_backupData synchronize];
    [_backupData setObject:_doneStartDateArr forKey:@"_doneStartDateArr"];
    [_backupData synchronize];
    [_backupData setObject:_doneDeadlinesArr forKey:@"_doneDeadlinesArr"];
    [_backupData synchronize];
}
-(void) retrieveDoneBackupArrays{
    if ([_backupData objectForKey:@"_doneNamesArr"] != nil){
        _doneNamesArr = [[_backupData objectForKey:@"_doneNamesArr"] mutableCopy];
        _doneDetailsArr = [[_backupData objectForKey:@"_doneDetailsArr"] mutableCopy];
        _doneStatesArr = [[_backupData objectForKey:@"_doneStatesArr"] mutableCopy];
        _donePriorityArr = [[_backupData objectForKey:@"_donePriorityArr"] mutableCopy];
        _doneStartDateArr = [[_backupData objectForKey:@"_doneStartDateArr"] mutableCopy];
        _doneDeadlinesArr = [[_backupData objectForKey:@"_doneDeadlinesArr"] mutableCopy];
    }
}

-(void) restoreToDoList{
    [_toDoList removeAllObjects];
    int i ;
    if ([_todoNamesArr count]!=0){
        for(i=0 ;(i <[_todoNamesArr count]) ;i++){
            Task* temp = [Task new];
            [temp setTaskName:[_todoNamesArr objectAtIndex:i]];
            [temp setTaskDetails:[_todoDetailsArr objectAtIndex:i]];
            [temp setTaskState:@"To Do"];
            [temp setTaskDeadline:[_todoDeadlinesArr objectAtIndex:i]];
            [temp setTaskPriority:[_todoPriorityArr objectAtIndex:i]];
            [temp setTaskStartDate:[_todoStartDateArr objectAtIndex:i]];
            [_toDoList addObject:temp];
        }
        [_tasksTableView reloadData];
    }
}
-(void) restoreInProgressList{
    [_inprogressList removeAllObjects];
    int i ;
    if ([_inProgressNamesArr count]!=0){
        for(i=0 ;(i <[_inProgressNamesArr count]) ;i++){
            Task* temp = [Task new];
            [temp setTaskName:[_inProgressNamesArr objectAtIndex:i]];
            [temp setTaskDetails:[_inProgressDetailsArr objectAtIndex:i]];
            [temp setTaskState:@"In Progress"];
            [temp setTaskDeadline:[_inProgressDeadlinesArr objectAtIndex:i]];
            [temp setTaskPriority:[_inProgressPriorityArr objectAtIndex:i]];
            [temp setTaskStartDate:[_inProgressStartDateArr objectAtIndex:i]];
            [_inprogressList addObject:temp];
        }
        [_tasksTableView reloadData];
    }
}
-(void) restoreDoneList{
    [_doneList removeAllObjects];
    int i ;
    if ([_doneNamesArr count]!=0){
        for(i=0 ;(i <[_doneNamesArr count]) ;i++){
            Task* temp = [Task new];
            [temp setTaskName:[_doneNamesArr objectAtIndex:i]];
            [temp setTaskDetails:[_doneDetailsArr objectAtIndex:i]];
            [temp setTaskState:@"Done"];
            [temp setTaskDeadline:[_doneDeadlinesArr objectAtIndex:i]];
            [temp setTaskPriority:[_donePriorityArr objectAtIndex:i]];
            [temp setTaskStartDate:[_doneStartDateArr objectAtIndex:i]];
            [_doneList addObject:temp];
        }
        [_tasksTableView reloadData];
    }
}
-(void) restoreLists{
    [self restoreToDoList];
    [self restoreInProgressList];
    [self restoreDoneList];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    switch (_statesSegmentView.selectedSegmentIndex) {
        case 0:
            [self restoreToDoList];
            break;
        case 1:
            [self restoreInProgressList];
            break;
        case 2:
            [self restoreDoneList];
            break;
        default:
            break;
    }
    [_tasksTableView reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqual:@""]) {
        switch (_statesSegmentView.selectedSegmentIndex) {
            case 0:
                [self restoreToDoList];
                break;
            case 1:
                [self restoreInProgressList];
                break;
            case 2:
                [self restoreDoneList];
                break;
            default:
                break;
        }
        [_tasksTableView reloadData];
       
    }else{
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.taskName contains[c] %@",searchText];
        switch (_statesSegmentView.selectedSegmentIndex) {
            case 0:
                _toDoList = [[_toDoList filteredArrayUsingPredicate:(predicate)] mutableCopy];
                [_tasksTableView reloadData];
                break;
            case 1:
               _inprogressList =  [[_inprogressList filteredArrayUsingPredicate:(predicate)] mutableCopy];
                [_tasksTableView reloadData];
                break;
            case 2:
                _doneList = [[_doneList filteredArrayUsingPredicate:(predicate)] mutableCopy];
                [_tasksTableView reloadData];
                break;
            default:
                break;
        }
        [_tasksTableView reloadData];
    }
}
-(void) castListArraysFromIdToArrayOfTasks{
    Task* dummyTask = [Task new];
    [dummyTask initBYName:@"name" AndDetails:@"deatils" AndPriority:@"High" AndSatrtDate:@"1/1/2001" AndState:@"2/2/2002" AndDeadline:@""];
    _toDoList = [NSMutableArray new];
    [_toDoList addObject:dummyTask];
    _inprogressList  = [NSMutableArray new];
    [_inprogressList addObject:dummyTask];
    _doneList =  [NSMutableArray new];
    [_doneList addObject:dummyTask];
   
    _todoNamesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _todoDetailsArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _todoStatesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _todoPriorityArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _todoStartDateArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _todoDeadlinesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    
    _inProgressNamesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _inProgressDetailsArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _inProgressStatesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _inProgressPriorityArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _inProgressStartDateArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _inProgressDeadlinesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    
    _doneNamesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _doneDetailsArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _doneStatesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _donePriorityArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _doneStartDateArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    _doneDeadlinesArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    
    [_doneList removeAllObjects];
    [_inprogressList removeAllObjects];
    [_toDoList removeAllObjects];
    
    [_todoNamesArr removeAllObjects];
    [_todoDetailsArr removeAllObjects];
    [_todoStatesArr removeAllObjects];
    [_todoPriorityArr removeAllObjects];
    [_todoStartDateArr removeAllObjects];
    [_todoDeadlinesArr removeAllObjects];
    [_inProgressNamesArr removeAllObjects];
    [_inProgressDetailsArr removeAllObjects];
    [_inProgressStatesArr removeAllObjects];
    [_inProgressPriorityArr removeAllObjects];
    [_inProgressStartDateArr removeAllObjects];
    [_inProgressDeadlinesArr removeAllObjects];
    [_doneNamesArr removeAllObjects];
    [_doneDetailsArr removeAllObjects];
    [_doneStatesArr removeAllObjects];
    [_donePriorityArr removeAllObjects];
    [_doneStartDateArr removeAllObjects];
    [_doneDeadlinesArr removeAllObjects];
}
@end
