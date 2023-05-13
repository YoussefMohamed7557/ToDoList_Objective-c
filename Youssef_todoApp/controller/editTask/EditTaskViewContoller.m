//
//  EditTaskViewContoller.m
//  Youssef_todoApp
//
//  Created by Youssef on 06/05/2023.
//

#import "EditTaskViewContoller.h"

@interface EditTaskViewContoller ()

@end

@implementation EditTaskViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarContent];
    [self initArrays];
    [self setDefaultScreen];
}
//MARK:-text view palceholder logic
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqual:@"Task Details"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqual:@""]){
        textView.text = @"Task Details";
        textView.textColor = [UIColor lightGrayColor];
    }
}
-(void) initArrays{
    if ([[_task taskState]isEqual:@"To Do"]) {
        _statesArray = [[NSArray alloc] initWithObjects:@"To Do",@"In Progress",@"Done", nil];
    }else if([[_task taskState]isEqual:@"In Progress"]) {
        _statesArray = [[NSArray alloc] initWithObjects:@"In Progress",@"Done", nil];
    }else{
        _statesArray = [[NSArray alloc] initWithObjects:@"Done", nil];
    }
    _prioritiesArray = [[NSArray alloc] initWithObjects:@"High",@"Middle",@"Low", nil];
}
-(void) setNavigationBarContent{
    self.navigationItem.title  = @"Edit Task";
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithTitle:@"submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonAction)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}
-(void) submitButtonAction{
    if (![_taskNameTextField hasText]) {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Missed Data" message:@"The task name is not exited" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:btn];
        [self presentViewController:myAlert animated:YES completion:nil];
        
    }else if ( [_taskDetailsTextView.text isEqual: @"Task Details"] || [_taskDetailsTextView.text isEqual: @""]){
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Missed Data" message:@"The task details is not exited" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:btn];
        [self presentViewController:myAlert animated:YES completion:nil];
        
    }else if ([self isDeadlineBeforeStartDate]){
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Not Valid Deadline" message:@"The deadline MUST be after current date" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->_deadlineDatePicker setDate:[NSDate new] animated:YES];
            [self->_deadlineDatePicker setTintColor:[UIColor blackColor]];
        }];
        [myAlert addAction:btn];
        [self presentViewController:myAlert animated:YES completion:nil];
    }else {
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Submit Editting" message:@"Do you want to submit editting this task ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesBtn = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self submitEdittingTheTask];
            }];
            [myAlert addAction:yesBtn];
        UIAlertAction *noBtn = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setDefaultScreen];
        }];
        [myAlert addAction:noBtn];
            [self presentViewController:myAlert animated:YES completion:nil];
    }
}
-(void) setDefaultScreen{
    _taskNameTextField.text = _task.taskName;
    _taskDetailsTextView.text = _task.taskDetails;
    _taskDetailsTextView.textColor = [UIColor blackColor];
    
    NSDate* currentDeadline = [NSDate new];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    currentDeadline= [dateFormatter dateFromString:_task.taskDeadline];
    [_deadlineDatePicker setDate:currentDeadline];
    [_deadlineDatePicker setTintColor:[UIColor blackColor]];
    //@"High",@"Middle",@"Low"
    if ([_task.taskPriority isEqual:@"High"]) {
        [_priorityPickerView selectRow:0 inComponent:0 animated:YES];
    } else if ([_task.taskPriority isEqual:@"Middle"]) {
        [_priorityPickerView selectRow:1 inComponent:0 animated:YES];
    }else{
        [_priorityPickerView selectRow:2 inComponent:0 animated:YES];
    }
    _selectedPriority = _task.taskPriority;
    _selectedState = _task.taskState;
}
-(void) submitEdittingTheTask{
    Task* task = [Task new];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setCalendar:[_deadlineDatePicker calendar]];
    NSString* deadLineString = [dateFormatter stringFromDate:[_deadlineDatePicker date]];
    [task initBYName:_taskNameTextField.text AndDetails:_taskDetailsTextView.text AndPriority:_selectedPriority AndSatrtDate:_task.taskStartDate AndState:_selectedState AndDeadline:deadLineString];
    
    if ([_task.taskState isEqual:task.taskState]) {
        [self.editTaskDelegationProtocolRef editTask:task isStateEditted:NO];
    }else{
        [self.editTaskDelegationProtocolRef editTask:task isStateEditted:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:-PRIORITY AND STATE PICKER VIEW
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger numberOfRowsInComponent = 0;
    switch (pickerView.tag) {
        case 0:
            numberOfRowsInComponent = [_prioritiesArray count];
            break;
        case 1:
            numberOfRowsInComponent = [_statesArray count];
            break;
        default:
            break;
    }
    return numberOfRowsInComponent;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* titleForRow  =[NSString new];
    switch (pickerView.tag) {
        case 0:
            titleForRow = [_prioritiesArray objectAtIndex:row];
            break;
        case 1:
            titleForRow = [_statesArray objectAtIndex:row];
            break;
        default:
            break;
    }
    return titleForRow;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 0:
            _selectedPriority = [_prioritiesArray objectAtIndex:row];
            NSLog(@" the priority %@",_selectedPriority);
            break;
        case 1:
            _selectedState = [_statesArray objectAtIndex:row];
            NSLog(@" the state %@",_selectedState);
            break;
        default:
            break;
    }
}

//MARK:_DATE PICKER
-(BOOL) isDeadlineBeforeStartDate{
    if (_deadlineDatePicker.date.timeIntervalSinceNow<0){
        return true;
    }else{
        return false;
    }
}
@end
