//
//  StatsSceneViewController.m
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import "StatsSceneViewController.h"

#define kHeadingToggle @"HeadingOnOff"

@interface StatsSceneViewController ()
@end

@implementation StatsSceneViewController

@synthesize currentCourse, currentHeading, currentSpeed;

- (void)viewDidLoad {
    
    locManSpeedCourse = [[CLLocationManager alloc] init];
    locManSpeedCourse.delegate = self;
    locManSpeedCourse.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locManSpeedCourse.distanceFilter = kCLDistanceFilterNone;
    
    [locManSpeedCourse startUpdatingLocation];
    
    if ([CLLocationManager headingAvailable]) {
        locManSpeedCourse.headingFilter = kCLHeadingFilterNone;
        [locManSpeedCourse startUpdatingHeading];
    }

    [super viewDidLoad];
}

-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingLocation];
        locManSpeedCourse = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation.horizontalAccuracy >= 0) {
        
        double tempdeviceSpeed = newLocation.speed;
        double tempdeviceCourse = newLocation.course;
        int deviceCourse = (int)tempdeviceCourse;
        
        
        if (tempdeviceSpeed < 1) {
            deviceSpeed = 0.0;
        } else {
            deviceSpeed = (tempdeviceSpeed * 1.943);
        }
        NSNumberFormatter *commaDelimited = [[NSNumberFormatter alloc] init];
        [commaDelimited setNumberStyle:NSNumberFormatterDecimalStyle];
        currentSpeed.text = [NSString stringWithFormat:@"%@ knots", [commaDelimited stringFromNumber:[NSNumber numberWithLong:deviceSpeed]]];
        
        
        if (deviceCourse < 0 || deviceSpeed < 0.5) {
            currentCourse.text = @"Course Unavalible";
        } else {
            currentCourse.text = [NSString stringWithFormat:@"%d", deviceCourse];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    double deviceHeading = 0.0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    HeadingToggle = [userDefaults boolForKey:kHeadingToggle];
    
    if (HeadingToggle == YES) {
        deviceHeading = newHeading.magneticHeading;
    }
    if (HeadingToggle == NO) {
        deviceHeading = newHeading.trueHeading;
    }
    
    if (deviceHeading < 0) {
        currentHeading.text = @"Heading Unavalible";
    } else if (deviceHeading > 337 && deviceHeading < 360) {
        currentHeading.text = @"N";
    } else if (deviceHeading > 0 && deviceHeading < 22) {
        currentHeading.text = @"N";
    } else if (deviceHeading > 22 && deviceHeading < 67) {
        currentHeading.text = @"NE";
    } else if (deviceHeading > 67 && deviceHeading < 112) {
        currentHeading.text = @"E";
    } else if (deviceHeading > 112 && deviceHeading < 157) {
        currentHeading.text = @"SE";
    } else if (deviceHeading > 157 && deviceHeading < 202) {
        currentHeading.text = @"S";
    } else if (deviceHeading > 202 && deviceHeading < 247) {
        currentHeading.text = @"SW";
    } else if (deviceHeading > 247 && deviceHeading < 292) {
        currentHeading.text = @"W";
    } else if (deviceHeading > 292 && deviceHeading < 337) {
        currentHeading.text = @"NW";
    } else {
        currentHeading.text = [NSString stringWithFormat:@"%2f", deviceHeading];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
