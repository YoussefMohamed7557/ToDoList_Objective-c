//
//  AddtaskViewController.m
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import "AddtaskViewController.h"

@interface AddtaskViewController ()

@end

@implementation AddtaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarContent];
    _statesArray = [[NSArray alloc] initWithObjects:@"To Do",@"In Progress",@"Done", nil];
    _prioritiesArray = [[NSArray alloc] initWithObjects:@"High",@"Middle",@"Low", nil];
    _selectedState = @"To Do";
    _selectedPriority = @"High";
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
//MARK:-===== the navigation bar content and its related actions ==//
- (void) setNavigationBarContent{
    self.navigationItem.title  = @"Add Task";
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithTitle:@"submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonAction)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}
- (void) submitButtonAction{
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
            [self->_deadlinDatePicker setDate:[NSDate new] animated:YES];
            [self->_deadlinDatePicker setTintColor:[UIColor blackColor]];
        }];
        [myAlert addAction:btn];
        [self presentViewController:myAlert animated:YES completion:nil];
    }else {
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Submit Adding" message:@"Do you want to submit adding new task ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesBtn = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self submitAddingTheTask];
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
    _taskNameTextField.text = @"";
    _taskDetailsTextView.text = @"Task Details";
    _taskDetailsTextView.textColor = [UIColor lightGrayColor];
    [_deadlinDatePicker setDate:[NSDate new] animated:YES];
    [_deadlinDatePicker setTintColor:[UIColor blackColor]];
    [_priorityPickerView selectRow:0 inComponent:0 animated:YES];
    _selectedPriority = @"High";
    [_statesPickerView selectRow:0 inComponent:0 animated:YES];
    _selectedState = @"To Do";
}
-(void) submitAddingTheTask{
    Task* task = [Task new];
    NSDate* currentDate = [NSDate new];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString* currentDateString = [dateFormatter stringFromDate:currentDate];
    [dateFormatter setCalendar:[_deadlinDatePicker calendar]];
    NSString* deadLineString = [dateFormatter stringFromDate:[_deadlinDatePicker date]];
    [task initBYName:_taskNameTextField.text AndDetails:_taskDetailsTextView.text AndPriority:_selectedPriority AndSatrtDate:currentDateString AndState:_selectedState AndDeadline:deadLineString];
    [self.addTaskDelegationProtocolRef addTask:task];
    [self setDefaultScreen];
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
    if (_deadlinDatePicker.date.timeIntervalSinceNow<0){
        return true;
    }else{
        return false;
    }
}
@end
