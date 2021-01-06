//
//  ViewController+MapLoca.m
//  SceneKitDemo01
//
//  Created by 物格网络游戏 on 2020/12/22.
//  Copyright © 2020 wnkpzzz. All rights reserved.
//

#import "ViewController+MapLoca.h"

@interface ViewController ()



@end

@implementation ViewController (MapLoca)

- (void)initMap {
    
    [self initMapView];
    [self configLocationManager];
    [self startSerialLocation];
}

#pragma mark - Initialization
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = NO;
        //        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 关掉比例尺
        self.mapView.showsScale = NO;
        // 关掉指南针
        self.mapView.showsCompass = NO;
        // 关掉楼块
        self.mapView.showsBuildings = NO;
        //        // 最小缩放级别
        self.mapView.minZoomLevel = 13;
        
        // openGLES 绘制
        //        self.mapView.openGLESDisabled = YES;
        // 缩放级别（默认3-19，有室内地图时为3-20）
        self.mapView.zoomLevel = 17;
        // 最大缩放级别
        self.mapView.maxZoomLevel = 19;
        // 设置地图相机角度(范围为[0.f, 60.f]
        self.mapView.cameraDegree = 210.f;
        // 关掉旋转
        self.mapView.rotateEnabled = YES;
        // 纹理样式
        [self mapTextureStyle];
        // 显示视图上
        [self.view addSubview:self.mapView];
        
    }
}

/**
 加载地图新样式
 */
- (void)mapTextureStyle {
    
    // 读取本地文件
    NSString *extraPath = [NSString stringWithFormat:@"%@/style_extra.data", [NSBundle mainBundle].bundlePath];
    NSString *stylePath = [NSString stringWithFormat:@"%@/style.data", [NSBundle mainBundle].bundlePath];
    NSString *texturesPath = [NSString stringWithFormat:@"%@/textures.zip", [NSBundle mainBundle].bundlePath];
    
    // 文件转换二进制
    NSData *extraData = [NSData dataWithContentsOfFile:extraPath];
    NSData *styleData = [NSData dataWithContentsOfFile:stylePath];
    NSData *texturesData = [NSData dataWithContentsOfFile:texturesPath];
    
    // MAMapCustomStyleOptions样式
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    
    options.styleExtraData = extraData;
    options.styleData = styleData;
    options.styleTextureData = texturesData;
    
    [self.mapView setCustomMapStyleOptions:options];
    
}

// 定位配置信息
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
    [self.locationManager setDesiredAccuracy:10];
}

/**
 开始定位
 */
- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

/**
 停止定位
 */
- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

#pragma mark -- AMapLocationManagerDelegate 代理

/**
 定位Auth
 */
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager {
    
}

/**
 定位错误
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

/**
 *实现代理方法，判断定位服务状态
 */

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
                // 定位失败弹框提示跳转系统内打开定位
                
                
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

/**
 定位经纬度
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    
    //定位结果
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self reloaddataWith:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    //停止定位
    [self stopSerialLocation];
}

#pragma mark - mapviewDelegate

/**
 地图纹理样式显示
 */
- (void)mapInitComplete:(MAMapView *)mapView {
    
    self.mapView.customMapStyleEnabled = YES;
}

@end
