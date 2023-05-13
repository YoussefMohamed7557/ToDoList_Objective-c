//
//  CustomCell.m
//  Youssef_todoApp
//
//  Created by Youssef on 29/04/2023.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.priorityView.layer.cornerRadius = self.priorityView.layer.frame.size.height/2;
    self.cellView.layer.cornerRadius = self.cellView.frame.size.height/5;
    self.startDateLabel.layer.cornerRadius = self.startDateLabel.layer.frame.size.height/2;
    self.deadlineLabel.layer.cornerRadius = self.deadlineLabel.layer.frame.size.height/2;
}
@end
