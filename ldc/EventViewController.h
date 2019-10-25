//
//  EventViewController.h
//  ldc
//
//  Created by meixiang wu on 10/15/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimalObj.h"
#import <BEMCheckBox.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    
@property (weak, nonatomic) IBOutlet UILabel *mVardsLb;
@property (weak, nonatomic) IBOutlet UILabel *mIdLb;
@property (weak, nonatomic) IBOutlet UIView *mTypeView;
@property (weak, nonatomic) IBOutlet UIView *mParentView;
@property (weak, nonatomic) IBOutlet UIView *mStartDateView;
@property (weak, nonatomic) IBOutlet UITextField *mStartDateTxt;
@property (weak, nonatomic) IBOutlet UIView *mDangerView;
@property (weak, nonatomic) IBOutlet UITextField *mEndDateTxt;
@property (weak, nonatomic) IBOutlet UIView *mVaccineView;
@property (weak, nonatomic) IBOutlet UITextField *mCertText;
@property (weak, nonatomic) IBOutlet UITextField *mNextDateTxt;
@property (weak, nonatomic) IBOutlet UIView *mAddrView;
@property (weak, nonatomic) IBOutlet UIView *mKeptView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mKeptCheck;
@property (weak, nonatomic) IBOutlet UITextField *mIsoCodeText;
@property (weak, nonatomic) IBOutlet UITextField *mAddrCodeText;
@property (weak, nonatomic) IBOutlet UITextField *mDetailText;
@property (weak, nonatomic) IBOutlet UILabel *mVaccineTypeLb;
@property (weak, nonatomic) IBOutlet UITextView *mCommentText;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;


- (IBAction)onSaveClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;
- (IBAction)onKeptClick:(id)sender;
- (IBAction)onSDateClick:(id)sender;
- (IBAction)onEDateClick:(id)sender;
- (IBAction)onVaccineClick:(id)sender;
- (IBAction)onNDateClick:(id)sender;
- (IBAction)onEditCancel:(id)sender;

@property (nonatomic) AnimalObj *animalObj;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) NSMutableArray *vaccineArray;
@property (nonatomic) NSMutableArray *addrArray;

@end

NS_ASSUME_NONNULL_END
