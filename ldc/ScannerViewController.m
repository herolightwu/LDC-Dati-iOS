//
//  ScannerViewController.m
//  Park Riga
//
//  Created by Armands Lazdiņš on 12/6/16.
//  Copyright © 2016 Cube Mobile. All rights reserved.
//

//Controllers
#import "ScannerViewController.h"
#import "ActivityView.h"

@interface ScannerViewController ()

//UI
@property (weak, nonatomic) IBOutlet UIView *scannerView;
@property (weak, nonatomic) IBOutlet ActivityView *activityView;

@property (nonatomic) MTBBarcodeScanner *scanner;

//Flags
@property (nonatomic) BOOL scannerLoaded;

@end

@implementation ScannerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setupController];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (!self.scannerLoaded) {
		self.scannerLoaded = YES;
		[self requestCameraPermission];
	}
}

#pragma mark - Targets

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Helpers

- (void)setupController
{
	[self.activityView startAnimatingAnimated:YES delay:0];
}

- (void)requestCameraPermission
{
	[MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
		if (success) {
			[self startScanner];
		} else {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
																		   message:@"Nav piekļuve kamerai"
																	preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Labi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
			UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Iestatījumi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
				NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
				[[UIApplication sharedApplication] openURL:URL];
			}];
			[alert addAction:okAction];
			[alert addAction:otherAction];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}];
}

#pragma mark - Scanner

-(void)startScanner
{
	__weak typeof(self) weakSelf = self;
	[self.scanner setDidStartScanningBlock:^{
		[weakSelf.activityView stopAnimatingAnimated:YES delay:0];
	}];
	[self.scanner startScanningWithResultBlock:^(NSArray *codes) {

		[weakSelf.scanner freezeCapture];
		[weakSelf.scanner stopScanning];
		//Notify delegates about results
		AVMetadataMachineReadableCodeObject *code = [codes firstObject];
		if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scannerViewcontroller:didCompleteScanningWithResults:)]) {
			[weakSelf.delegate scannerViewcontroller:weakSelf didCompleteScanningWithResults:code.stringValue];
			[weakSelf.delegate scannerViewcontroller:weakSelf shouldUseFlash:self.torchON];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}
	} error:nil];
}

#pragma mark - Lazy Load

-(MTBBarcodeScanner *)scanner
{
	if (!_scanner) {
		_scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode,
																			AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,
																			AVMetadataObjectTypeCode39Mod43Code,
																			AVMetadataObjectTypeCode93Code,
																			AVMetadataObjectTypeCode128Code
																			]



															  previewView:self.scannerView];
		_scanner.torchMode = self.torchON;
	}
	return _scanner;
}

@end
