//
//  AMViewController.m
//  ParseTester
//
//  Created by Arthur Mayes on 3/6/13.
//  Copyright (c) 2013 Arthur Mayes. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSArray *arrayOfObjectIdsAndCollegeNames;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)charactersChanged:(UITextField *)sender;
- (IBAction)favoriteThisSchool:(id)sender;
@end

@implementation AMViewController

-(NSArray *)arrayOfObjectIdsAndCollegeNames{
    if (!_arrayOfObjectIdsAndCollegeNames) {
        _arrayOfObjectIdsAndCollegeNames = [NSArray new];
    }
    return _arrayOfObjectIdsAndCollegeNames;
}

#pragma mark - UIPickerView stuff
-(void)setPickerValueToRow:(int)i inComponent:(int)j animated:(BOOL)k{
    [self.picker selectRow:i inComponent:j animated:k];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    NSLog(@"called for number of components");
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.arrayOfObjectIdsAndCollegeNames count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"title = %@", [[self.arrayOfObjectIdsAndCollegeNames objectAtIndex:row] objectAtIndex:1]);
    return [[self.arrayOfObjectIdsAndCollegeNames objectAtIndex:row] objectAtIndex:1];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@", [self.arrayOfObjectIdsAndCollegeNames objectAtIndex:row]);
}

#pragma mark - UITextField stuff

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (IBAction)charactersChanged:(UITextField *)sender {
    for (NSArray *array in self.arrayOfObjectIdsAndCollegeNames) {
        NSString *college = [array objectAtIndex:1];
        
        if ([[college substringToIndex:[self.searchTextField.text length]] isEqualToString:[self.searchTextField text]]) {
            [self setPickerValueToRow:[self.arrayOfObjectIdsAndCollegeNames indexOfObject:array] inComponent:0 animated:YES];
            break;
        }
    }}

- (IBAction)favoriteThisSchool:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
	PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
     */
    PFQuery *query = [PFQuery queryWithClassName:@"college"];
    AMViewController *__weak weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        //NSLog(@"Objects = %@", objects);
        NSMutableArray *arrayForSettingUpArray = [NSMutableArray new];
        for (PFObject *dict in objects) {
            NSArray *array = @[[dict objectForKey:@"ID"], [dict objectForKey:@"SchoolName"]];
            [arrayForSettingUpArray addObject:array];
        }
        weakSelf.arrayOfObjectIdsAndCollegeNames = (NSArray *)arrayForSettingUpArray;
        //NSLog(@"arrayOfObjects = %@", weakSelf.arrayOfObjectIdsAndCollegeNames);
        [weakSelf.picker reloadAllComponents];
        }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
