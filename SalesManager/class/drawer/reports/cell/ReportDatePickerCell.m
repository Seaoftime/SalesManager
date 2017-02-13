//
//  DatePickerCell.m
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportDatePickerCell.h"
#import "YformFileds.h"
#import "CustomIOS7AlertView.h"

@implementation ReportDatePickerCell

- (void)dateChanged:(id)sender
{
    NSDateFormatter* YMD = [[NSDateFormatter alloc]init];
    switch (_datePicker.datePickerMode)
    {
        case UIDatePickerModeDateAndTime:
            [YMD setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        default:
            [YMD setDateFormat:@"yyyy-MM-dd"];
            break;
    }
//    [YMD setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    self.dateLabel.text = [YMD stringFromDate:self.datePicker.date];
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportDatePickerCell:didEndEditingWithDictionary:)] )
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)[self.datePicker.date timeIntervalSince1970]], self.formFiled.formReferName, nil];
		[_delegate reportDatePickerCell:self didEndEditingWithDictionary:dic];
    }
}
//
//- (void)initalizeInputView
//{
//    // Initialization code
//	self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
//	[_datePicker setDatePickerMode:UIDatePickerModeDate];
//	_datePicker.date = [NSDate date];
//	[_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//	
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//		UIViewController *popoverContent = [[UIViewController alloc] init];
//		popoverContent.view = self.datePicker;
//		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
//		popoverController.delegate = self;
//	} else {
//		CGRect frame = self.inputView.frame;
//		frame.size = [self.datePicker sizeThatFits:CGSizeZero];
//		self.inputView.frame = frame;
//		self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//	}
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//		[self initalizeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//		[self initalizeInputView];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        _datePicker.date = [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


- (void)awakeFromNib
{
    self.bggImgV.backgroundColor = [UIColor whiteColor];
    
}




- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

- (IBAction)showAlert:(UIButton *)aButton
{

    
    UITableView *tableView;
    if ([self.superview class] != [UITableView class])
    {
        tableView = (UITableView *)self.superview.superview;
    }
    else
    {
        tableView = (UITableView *)self.superview;
    }
    
    [self resignKeyBoardInView:tableView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:tableView];
    [alertView setContainerView:self.datePicker];
    [alertView show];
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//	if (selected)
//    {
//		[self becomeFirstResponder];
//	}
//}
//
- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.label.text = [NSString stringWithFormat:@"%@:",formFiled.formName];
    
    NSDateFormatter* YMD = [[NSDateFormatter alloc]init];
    
    switch (_datePicker.datePickerMode)
    {
        case UIDatePickerModeDateAndTime:
            [YMD setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        default:
            [YMD setDateFormat:@"yyyy-MM-dd"];
            break;
    }
    
    
//    [YMD setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    self.dateLabel.text = [YMD stringFromDate:[NSDate date]];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportDatePickerCell:didEndEditingWithDictionary:)] )
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)[self.datePicker.date timeIntervalSince1970]], self.formFiled.formReferName, nil];
		[_delegate reportDatePickerCell:self didEndEditingWithDictionary:dic];
    }
}
//
//- (UIView *)inputView
//{
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//		return nil;
//	} else {
//		return self.datePicker;
//	}
//}
//
//- (UIView *)inputAccessoryView
//{
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//		return nil;
//	} else {
//		if (!inputAccessoryView)
//        {
//			inputAccessoryView = [[UIToolbar alloc] init];
//			inputAccessoryView.barStyle = UIBarStyleDefault;
//			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//			[inputAccessoryView sizeToFit];
//			CGRect frame = inputAccessoryView.frame;
//			frame.size.height = 44.0f;
//			inputAccessoryView.frame = frame;
//			
//            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
//			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			
//			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
//			[inputAccessoryView setItems:array];
//		}
//		return inputAccessoryView;
//	}
//}
//
//- (void)done:(id)sender
//{
//    _isDone = YES;
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(reportDatePickerCell:didEndEditingWithDictionary:)] )
//    {
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)[self.datePicker.date timeIntervalSince1970]], self.formFiled.formReferName, nil];
//		[_delegate reportDatePickerCell:self didEndEditingWithDictionary:dic];
//    }
////	[self resignFirstResponder];
//}
//
//- (BOOL)becomeFirstResponder
//{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
//		CGRect frame = self.datePicker.frame;
//		frame.size = pickerSize;
//		self.datePicker.frame = frame;
//		popoverController.popoverContentSize = pickerSize;
//		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//	} else {
//		// nothing to do
//	}
//    
//    return [super becomeFirstResponder];
//}
//
//- (BOOL)resignFirstResponder
//{
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//	} else {
//		// Nothing to do
//	}
//    UITableView *tableView;
//    if ([self.superview class] != [UITableView class])
//    {
//        tableView = (UITableView *)self.superview.superview;
//    }
//    else
//    {
//        tableView = (UITableView *)self.superview;
//    }
//    
//	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
//	return [super resignFirstResponder];
//}
//
//- (void)deviceDidRotate:(NSNotification*)notification
//{
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//		// we should only get this call if the popover is visible
//		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//	} else {
//		[self.datePicker setNeedsLayout];
//	}
//}
//
//
//
//#pragma mark -
//#pragma mark Respond to touch and become first responder.
//
//- (BOOL)canBecomeFirstResponder
//{
//	return YES;
//}
//
//#pragma mark -
//#pragma mark UIPopoverControllerDelegate Protocol Methods
//
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//	UITableView *tableView;
//    if ([self.superview class] != [UITableView class])
//    {
//        tableView = (UITableView *)self.superview.superview;
//    }
//    else
//    {
//        tableView = (UITableView *)self.superview;
//    }
//	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
//	[self resignFirstResponder];
//}

@end
