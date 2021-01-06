//
//  ViewController.h
//  SceneKitDemo01
//
//  Created by Hans3D on 2019/2/12.
//  Copyright © 2019年 wnkpzzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) MAMapView *mapView;
//重新加载经纬度
- (void)reloaddataWith:(CGFloat)latitude longitude:(CGFloat)longitude;


@end

