//
//  HomeSceneViewController.m
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import "HomeSceneViewController.h"

#define kHomeLatitude @"SavedHomeLat"
#define kHomeLongitude @"SavedHomeLon"
#define kTwoLatitude @"SavedTwoLat"
#define kTwoLongitude @"SavedTwoLon"
#define kThreeLatitude @"SavedThreeLat"
#define kThreeLongitude @"SavedThreeLon"
#define deg2rad 0.0174532925
#define rad2deg 57.2957795

@interface HomeSceneViewController ()
@end

@implementation HomeSceneViewController

@synthesize recentLocation;
@synthesize distanceLable, displayPort, displayCurrentLocation, distanceToLabel, onCourse;
@synthesize waitView, directionArrow;
@synthesize lat, lon;
@synthesize HomeOtherToggle;

- (void)viewDidLoad {
    [super viewDidLoad];
    locMan = [[CLLocationManager alloc] init];
    [locMan requestAlwaysAuthorization];
    locMan.delegate = self;
    locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locMan.distanceFilter = kCLDistanceFilterNone;
    
    [locMan startUpdatingLocation];
    
    if ([CLLocationManager headingAvailable]) {
        locMan.headingFilter = kCLHeadingFilterNone;
        [locMan startUpdatingHeading];
    }
    
    //onCourse.text = @"No Data";
    //onCourse.textColor = [UIColor colorWithRed:0.80 green:0.00 blue:0.00 alpha:1.0];

}

-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingLocation];
        locMan = nil;
    }
    waitView.hidden = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation.horizontalAccuracy >= 0) {
        
        self.recentLocation = newLocation;
        
        CLLocation *TargetLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocationDistance delta = [TargetLocation distanceFromLocation: newLocation];
        double miles = (delta * 0.000539956803456);
        
        if (delta < 50) {
            [manager stopUpdatingLocation];
            [manager stopUpdatingHeading];
            //directionArrow.hidden = YES;
            directionArrow.image = [UIImage imageNamed:@"AtPort.png"];
            onCourse.text = @"Port < 50m";
            onCourse.textColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.00 alpha:1.0];
        }
        waitView.hidden = YES;
        
        double templat = newLocation.coordinate.latitude;
        double templon = newLocation.coordinate.longitude;
        
        NSString *latNS;
        NSString *lonEW;
        
        if (templat > 0) {
            latNS = @"N";
        } else {
            latNS = @"S";
        }
        
        if (templon > 0) {
            lonEW = @"E";
        } else {
            lonEW = @"W";
        }
        
        NSString *currentLocation = [NSString stringWithFormat:@"%.4f˚%@  %.4f˚%@", templat, latNS, templon, lonEW];
        
        displayCurrentLocation.text = currentLocation;
        
        NSNumberFormatter *commaDelimited = [[NSNumberFormatter alloc] init];
        [commaDelimited setNumberStyle:NSNumberFormatterDecimalStyle];
        distanceLable.text = [NSString stringWithFormat:@"%@ nautical miles", [commaDelimited stringFromNumber:[NSNumber numberWithLong:miles]]];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if (self.recentLocation != nil && newHeading.headingAccuracy >= 0) {
        CLLocation *TargetLocationHeading = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        double course = [self headingToLocation:TargetLocationHeading.coordinate current:recentLocation.coordinate];
        
        double deltaTwo = newHeading.trueHeading - course;
        
        if (fabs(deltaTwo) <= 5) {
            directionArrow.image = [UIImage imageNamed:@"UpArrow.png"];
            onCourse.text = @"On Course";
            onCourse.textColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.00 alpha:1.0];
        } else {
            if (deltaTwo > 180) {
                directionArrow.image = [UIImage imageNamed:@"RightArrow.png"];
                onCourse.text = @"Off Course";
                onCourse.textColor = [UIColor colorWithRed:0.80 green:0.00 blue:0.00 alpha:1.0];
            }
            else if (deltaTwo > 0) {
                directionArrow.image = [UIImage imageNamed:@"LeftArrow.png"];
                onCourse.text = @"Off Course";
                onCourse.textColor = [UIColor colorWithRed:0.80 green:0.00 blue:0.00 alpha:1.0];
            }
            else if (deltaTwo > -180) {
                directionArrow.image = [UIImage imageNamed:@"RightArrow.png"];
                onCourse.text = @"Off Course";
                onCourse.textColor = [UIColor colorWithRed:0.80 green:0.00 blue:0.00 alpha:1.0];
            }
            else {
                directionArrow.image = [UIImage imageNamed:@"LeftArrow.png"];
                onCourse.text = @"Off Course";
                onCourse.textColor = [UIColor colorWithRed:0.80 green:0.00 blue:0.00 alpha:1.0];
            }
        }
        directionArrow.hidden = NO;
    } else {
        directionArrow.hidden = YES;
        onCourse.text = @"No Data";
        onCourse.textColor = [UIColor redColor];
    }
}

-(double)headingToLocation:(CLLocationCoordinate2D)desired current:(CLLocationCoordinate2D)current {
    
    double lat1 = current.latitude*deg2rad;
    double lat2 = desired.latitude*deg2rad;
    double lon1 = current.longitude;
    double lon2 = desired.longitude;
    double dlon = (lon2-lon1)*deg2rad;
    
    double y = sin(dlon)*cos(lat2);
    double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dlon);
    
    double heading=atan2(y, x);
    heading=heading*rad2deg;
    heading=heading+360.0;
    heading=fmod(heading, 360.0);
    return heading;
}


-(IBAction)ChoosePort:(id)sender {
    [self LoadSelectedPort];
    [locMan startUpdatingLocation];
    if ([CLLocationManager headingAvailable]) {
        locMan.headingFilter = kCLHeadingFilterNone;
        [locMan startUpdatingHeading];
    }
}

-(void)LoadSelectedPort {
    
    if (HomeOtherToggle.selectedSegmentIndex == 0) {
        distanceToLabel.text = @"Distance to Home Port";
    } else if (HomeOtherToggle.selectedSegmentIndex == 1) {
        distanceToLabel.text = @"Distance to Port Two";
    } else if (HomeOtherToggle.selectedSegmentIndex == 2) {
        distanceToLabel.text = @"Distance to Port Three";
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedLatNS;
    NSString *selectedLonEW;
    
    if (HomeOtherToggle.selectedSegmentIndex == 0) {
        
        lat = [userDefaults doubleForKey:kHomeLatitude];
        lon = [userDefaults doubleForKey:kHomeLongitude];
        
        if (lat > 0) {
            selectedLatNS = @"N";
        } else {
            selectedLatNS = @"S";
        }
        
        if (lon > 0) {
            selectedLonEW = @"E";
        } else {
            selectedLonEW = @"W";
        }
        displayPort.text = [NSString stringWithFormat:@"%.4f˚%@  %.4f˚%@", lat, selectedLatNS, lon, selectedLonEW];
        
    } else if (HomeOtherToggle.selectedSegmentIndex == 1) {
        
        lat = [userDefaults doubleForKey:kTwoLatitude];
        lon = [userDefaults doubleForKey:kTwoLongitude];
        
        if (lat > 0) {
            selectedLatNS = @"N";
        } else {
            selectedLatNS = @"S";
        }
        
        if (lon > 0) {
            selectedLonEW = @"E";
        } else {
            selectedLonEW = @"W";
        }
        displayPort.text = [NSString stringWithFormat:@"%.4f˚%@  %.4f˚%@", lat, selectedLatNS, lon, selectedLonEW];
    } else if (HomeOtherToggle.selectedSegmentIndex == 2) {
        
        lat = [userDefaults doubleForKey:kThreeLatitude];
        lon = [userDefaults doubleForKey:kThreeLongitude];
        
        if (lat > 0) {
            selectedLatNS = @"N";
        } else {
            selectedLatNS = @"S";
        }
        
        if (lon > 0) {
            selectedLonEW = @"E";
        } else {
            selectedLonEW = @"W";
        }
        displayPort.text = [NSString stringWithFormat:@"%.4f˚%@  %.4f˚%@", lat, selectedLatNS, lon, selectedLonEW];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [self LoadSelectedPort];
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
