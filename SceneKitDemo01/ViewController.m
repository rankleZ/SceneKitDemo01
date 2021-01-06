//
//  ViewController.m
//  SceneKitDemo
//
//  Created by Hans3D on 2019/2/12.
//  Copyright © 2019年 wnkpzzz. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

#include "ViewController+MapLoca.h"

#define APP_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define APP_HEIGHT                   [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property(strong,nonatomic) SCNView *scnView;
@property(strong,nonatomic) SCNScene *scene;

@property(nonatomic, strong)CLLocationManager *manager;

@end

@implementation ViewController

- (void)reloaddataWith:(CGFloat)latitude longitude:(CGFloat)longitude {
    
    [self getDataWithlatitude:latitude longitude:longitude];
}

//设置状态栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不加这个，第一次进入app，不弹出地理位置使用权限选择
    self.manager = [[CLLocationManager alloc] init];
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self initMap];
    
    [self get3DModel];
}

/**
 获取经纬度
 */
- (void)getDataWithlatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    
    NSLog(@"latitude = %f,longitude = %f",latitude,longitude);
}

#pragma mark -- mapViewRequireLocationAuth
//实现mapViewRequireLocationAuth方法
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager
{
    [self.manager requestAlwaysAuthorization];
}

#pragma mark -- didAddAnnotationViews(去掉高德地图淡蓝色精度圈)
//去掉高德地图淡蓝色精度圈
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = false;///精度圈是否显示，默认YES
        [self.mapView updateUserLocationRepresentation:r];
    }
}


/**
 *  加载模型
 */

- (void)get3DModel {
    
    // 1.添加SCNView视图
    self.scnView = [[SCNView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    self.scnView.allowsCameraControl = YES; // 允许操纵，这样用户就可以改变视角的位置和方向
    self.scnView.backgroundColor = [UIColor blackColor];
    [self.mapView addSubview:self.scnView];
    
    // 2.加载obj模型
    SCNSceneSource *sceneSource = [SCNSceneSource  sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"9" withExtension:@".obj"] options:nil];
    self.scene  = [sceneSource sceneWithOptions:nil error:nil];
    self.scnView.scene = self.scene;
    
    // 3.加载模型贴图
    SCNNode *node = self.scnView.scene.rootNode.childNodes.firstObject;
    node.geometry.firstMaterial.lightingModelName = SCNLightingModelPhong;
    node.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"9.jpg"];
    [self.scene.rootNode addChildNode:node];
    [self.scnView.scene.rootNode addChildNode:node];
    
    [self.scnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentsView)]];
}

// 模型点击事件
- (void)clickContentsView {
    
    NSLog(@"点击了模型");
    
}

@end
