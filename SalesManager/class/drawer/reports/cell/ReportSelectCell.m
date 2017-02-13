//
//  SelectCell.m
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportSelectCell.h"
#import "YformFileds.h"
#import "CustomIOS7AlertView.h"

@implementation ReportSelectCell

//- (void)initalizeInputView
//{
//	self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
//	self.picker.showsSelectionIndicator = YES;
//	self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.picker.delegate = self;
//    self.picker.dataSource = self;
//
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//		UIViewController *popoverContent = [[UIViewController alloc] init];
//		popoverContent.view = self.picker;
//		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
//		popoverController.delegate = self;
//	}
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//		[self initalizeInputView];
    }
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
////        [self.selectTextField addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventAllEvents];
//        [self.button addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}

//- (UIView *)inputView {
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		return nil;
//	} else {
//		return self.picker;
//	}
//}



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
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    self.picker.showsSelectionIndicator = YES;
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
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
    alertView.delegate = self;
    [alertView setContainerView:self.picker];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if ([alertView.parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)alertView.parentView;
        tableView.scrollEnabled = YES;
    }
    
    NSLog(@"Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    self.selectTextField.text = [values objectAtIndex:[self.picker selectedRowInComponent:0]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportSelectCell:didEndEditingWithDictionary:)]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectTextField.text, self.formFiled.formReferName, nil];
		[_delegate reportSelectCell:self didEndEditingWithDictionary:dic];
	}
    [alertView close];
}

//- (void)done:(id)sender {
//
////    _isDone = YES;
//    
//    self.selectTextField.text = [values objectAtIndex:[self.picker selectedRowInComponent:0]];
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(reportSelectCell:didEndEditingWithDictionary:)]) {
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectTextField.text, self.formFiled.formReferName, nil];
//		[_delegate reportSelectCell:self didEndEditingWithDictionary:dic];
//	}
////    [self resignFirstResponder];
//}

//- (UIView *)inputAccessoryView {
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		return nil;
//	} else {
//		if (!inputAccessoryView) {
//			inputAccessoryView = [[UIToolbar alloc] init];
//			inputAccessoryView.barStyle = UIBarStyleDefault;
//			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//			[inputAccessoryView sizeToFit];
//			CGRect frame = inputAccessoryView.frame;
//			frame.size.height = 44.0f;
//			inputAccessoryView.frame = frame;
//			
//			UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
//			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			
//			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
//			[inputAccessoryView setItems:array];
//		}
//		return inputAccessoryView;
//	}
//}
//
//- (BOOL)becomeFirstResponder {
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
//		CGRect frame = self.picker.frame;
//		frame.size = pickerSize;
//		self.picker.frame = frame;
//		popoverController.popoverContentSize = pickerSize;
//		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//		// resign the current first responder
//		for (UIView *subview in self.superview.subviews) {
//			if ([subview isFirstResponder]) {
//				[subview resignFirstResponder];
//			}
//		}
//		return NO;
//	} else {
//        [self initalizeInputView];
//		[self.picker setNeedsLayout];
//	}
//	return [super becomeFirstResponder];
//}
//
//- (void)deviceDidRotate:(NSNotification*)notification {
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		// we should only get this call if the popover is visible
//		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//	} else {
//		[self.picker setNeedsLayout];
//	}
//}
//
//- (BOOL)resignFirstResponder {
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
//    
//	return [super resignFirstResponder];
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//	if (selected) {
//
////		[self becomeFirstResponder];
//        
//        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
//        self.picker.showsSelectionIndicator = YES;
//        self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        self.picker.delegate = self;
//        self.picker.dataSource = self;
//
//        UITableView *tableView;
//        if ([self.superview class] != [UITableView class])
//        {
//            tableView = (UITableView *)self.superview.superview;
//        }
//        else
//        {
//            tableView = (UITableView *)self.superview;
//        }
//
//        
//        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:tableView];
//        [alertView setContainerView:self.picker];
//        [alertView show];
//	}
//}

- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.label.text = [NSString stringWithFormat:@"%@:",formFiled.formName];
    NSLog(@"%@",formFiled);
    
    if (formFiled.selectivity) {
        values = [formFiled.selectivity componentsSeparatedByString:@"&&"];
    }
    if (formFiled.need) {
        self.selectTextField.placeholder = @"必填";
    }
    
}
//
//#pragma mark -
//#pragma mark Respond to touch and become first responder.
//
//- (BOOL)canBecomeFirstResponder {
//	return YES;
//}
//
//#pragma mark -
//#pragma mark UIKeyInput Protocol Methods
//
//- (BOOL)hasText {
//	return YES;
//}
//
//- (void)insertText:(NSString *)theText {
//    
//}
//
//- (void)deleteBackward {
//    
//}
//
//#pragma mark -
//#pragma mark UIPopoverControllerDelegate Protocol Methods
//
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
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

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [values count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [values objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectTextField.text = [values objectAtIndex:row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportSelectCell:didEndEditingWithDictionary:)]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectTextField.text, self.formFiled.formReferName, nil];
		[_delegate reportSelectCell:self didEndEditingWithDictionary:dic];
	}
}

@end
