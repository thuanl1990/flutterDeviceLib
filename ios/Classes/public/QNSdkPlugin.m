#import "QNSdkPlugin.h"
#import "QNConstants.h"
#import "QNBleApi.h"

@interface QNSdkPlugin () <FlutterStreamHandler, QNBleStateListener, QNBleDeviceDiscoveryListener, QNBleConnectionChangeListener, QNScaleDataListener>
@property (nonatomic, copy) FlutterEventSink eventSink;
@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) NSMutableDictionary *scanDevices;
@end

@implementation QNSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel
                                           methodChannelWithName:Argument_channelName
                                           binaryMessenger:[registrar messenger]];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:Argument_eventName binaryMessenger:[registrar messenger]];
    QNSdkPlugin* instance = [[QNSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:methodChannel];
    [eventChannel setStreamHandler:instance];
    instance.bleApi = [QNBleApi sharedBleApi];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *methodName = call.method;
    NSDictionary *params = call.arguments;
    if ([methodName isEqualToString:MethodName_initSdk]) {
        [self initSdkWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_setBleStateListener]) {
        [self setBleStateListenerWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_setBleDeviceDiscoveryListener]){
        [self setBleDeviceDiscoveryListenerWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_startBleDeviceDiscovery]){
        [self startBleDeviceDiscoveryWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_stopBleDeviceDiscovery]){
        [self stopBleDeviceDiscoveryWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_connectDevice]){
        [self connectDeviceWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_disconnectDevice]){
        [self disconnectDeviceWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_setBleConnectionChangeListener]){
        [self setBleConnectionChangeListenerWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_setScaleDataListener]){
        [self setScaleDataListenerWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_getConfig]){
        [self getConfigWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_saveConfig]){
        [self saveConfigWithParams:params result:result];
    } else if ([methodName isEqualToString:MethodName_generateScaleData]){
        [self generateScaleDataWithParams:params result:result];
    }
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}


#pragma mark - QNBleStateListener
- (void)onBleSystemState:(QNBLEState)state {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onBleSystemState;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_state] = [NSNumber numberWithUnsignedInteger:state];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

#pragma mark - QNBleDeviceDiscoveryListener
- (void)onDeviceDiscover:(QNBleDevice *)device {
    if (device.deviceType != QNDeviceTypeScaleBleDefault) return;
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onDeviceDiscover;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    json[Argument_data] = dataJson;
    
    self.scanDevices[device.mac] = device;
    
    [self callFlutterWithParams:json];
}

- (void)onStartScan {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onStartScan;
    [self callFlutterWithParams:json];
}

- (void)onStopScan {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onStartScan;
    [self callFlutterWithParams:json];
}

#pragma mark - QNBleConnectionChangeListener
- (void)onConnecting:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onConnecting;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onConnected:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onConnected;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onServiceSearchComplete:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onServiceSearchComplete;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onDisconnecting:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onDisconnecting;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onConnectError;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    if (error) {
        dataJson[Argument_errorCode] = [NSNumber numberWithInteger:error.code];
    }
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

#pragma mark - QNScaleDataListener
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onGetUnsteadyWeight;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    dataJson[Argument_weight] = [NSNumber numberWithDouble:weight];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onGetScaleData;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    dataJson[Argument_scaleData] = [self jsonWithScaleData:scaleData];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onGetStoredScale;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    
    NSMutableArray *storedDataListJson = [NSMutableArray array];
    for (QNScaleStoreData *item in storedDataList) {
        NSMutableDictionary *itemJson = [NSMutableDictionary dictionary];
        itemJson[Argument_weight] = [NSNumber numberWithDouble:item.weight];
        itemJson[Argument_measureTime] = [NSNumber numberWithInteger:[self transformMilliSecondWithSecond:[item.measureTime timeIntervalSince1970]]];
        itemJson[Argument_mac] = item.mac;
        itemJson[Argument_hmac] = item.hmac;
        [storedDataListJson addObject:itemJson];
    }
    dataJson[Argument_storedDataList] = storedDataListJson;
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onGetElectric;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    dataJson[Argument_electric] = [NSNumber numberWithInteger:electric];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_methodName] = EventName_onScaleStateChange;
    
    NSMutableDictionary *dataJson = [NSMutableDictionary dictionary];
    dataJson[Argument_device] = [self jsonWithDevice:device];
    int stateIndex = 0;
    switch (state) {
        case QNScaleStateDisconnected: stateIndex = 0; break;
        case QNScaleStateLinkLoss: stateIndex = -1; break;
        case QNScaleStateConnected: stateIndex = 1; break;
        case QNScaleStateConnecting: stateIndex = 2; break;
        case QNScaleStateDisconnecting: stateIndex = 3; break;
        case QNScaleStateStartMeasure: stateIndex = 5; break;
        case QNScaleStateRealTime: stateIndex = 6; break;
        case QNScaleStateBodyFat: stateIndex = 7; break;
        case QNScaleStateHeartRate: stateIndex = 8; break;
        case QNScaleStateMeasureCompleted: stateIndex = 9; break;
        default:
            break;
    }
    dataJson[Argument_scaleState] = [NSNumber numberWithInteger:stateIndex];
    json[Argument_data] = dataJson;
    
    [self callFlutterWithParams:json];
}

#pragma mark - Flutter call iOS
- (void)initSdkWithParams:(NSDictionary *)params result:(FlutterResult)result {
    __weak __typeof(self)weakSelf = self;
    [self.bleApi initSdk:params[Argument_appid] dataFileContent:params[Argument_fileContent] callback:^(NSError *error) {
        result([weakSelf transformJsonFromErr:error]);
    }];
}

- (void)setBleStateListenerWithParams:(NSDictionary *)params result:(FlutterResult)result {
    self.bleApi.bleStateListener = self;
    result([self transformJsonFromErr:nil]);
}

- (void)setBleDeviceDiscoveryListenerWithParams:(NSDictionary *)params result:(FlutterResult)result {
    self.bleApi.discoveryListener = self;
    result([self transformJsonFromErr:nil]);
}

- (void)startBleDeviceDiscoveryWithParams:(NSDictionary *)params result:(FlutterResult)result {
    __weak __typeof(self)weakSelf = self;
    [self.bleApi startBleDeviceDiscovery:^(NSError *error) {
        result([weakSelf transformJsonFromErr:error]);
    }];
}

- (void)stopBleDeviceDiscoveryWithParams:(NSDictionary *)params result:(FlutterResult)result {
    __weak __typeof(self)weakSelf = self;
    [self.bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        result([weakSelf transformJsonFromErr:error]);
    }];
}

- (void)connectDeviceWithParams:(NSDictionary *)params result:(FlutterResult)result {
    NSDictionary *deviceJson = params[Argument_device];
    
    QNBleDevice *device = self.scanDevices[deviceJson[Argument_mac]];
    QNUser *user = [self transformUserWithJson:params[Argument_user]];
    
    __weak __typeof(self)weakSelf = self;
    [self.bleApi connectDevice:device user:user callback:^(NSError *error) {
        [weakSelf transformJsonFromErr:error];
    }];
}

- (void)disconnectDeviceWithParams:(NSDictionary *)params result:(FlutterResult)result {
    QNBleDevice *device = self.scanDevices[params[Argument_mac]];
    __weak __typeof(self)weakSelf = self;
    [self.bleApi disconnectDevice:device callback:^(NSError *error) {
        result([weakSelf transformJsonFromErr:error]);
    }];
}

- (void)setBleConnectionChangeListenerWithParams:(NSDictionary *)params result:(FlutterResult)result {
    self.bleApi.connectionChangeListener = self;
    result([self transformJsonFromErr:nil]);
}

- (void)setScaleDataListenerWithParams:(NSDictionary *)params result:(FlutterResult)result {
    self.bleApi.dataListener = self;
    result([self transformJsonFromErr:nil]);
}

- (void)getConfigWithParams:(NSDictionary *)params result:(FlutterResult)result {
    QNConfig *config = [self.bleApi getConfig];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSNumber numberWithBool:config.onlyScreenOn] forKey:Argument_onlyScreenOn];
    [dic setValue:[NSNumber numberWithBool:config.allowDuplicates] forKey:Argument_allowDuplicates];
    [dic setValue:[NSNumber numberWithInt:config.duration] forKey:Argument_duration];
    [dic setValue:[NSNumber numberWithInteger:config.unit] forKey:Argument_unit];
    [dic setValue:[NSNumber numberWithBool:config.showPowerAlertKey] forKey:Argument_iOSShowPowerAlertKey];
    [dic setValue:[NSNumber numberWithInt:10000] forKey:Argument_androidConnectOutTime];
    [dic setValue:[NSNumber numberWithBool:false] forKey:Argument_androidSetNotCheckGPS];
    
    result(dic);
}

- (void)saveConfigWithParams:(NSDictionary *)params result:(FlutterResult)result {
    QNConfig *config = [self.bleApi getConfig];
    if ([params[Argument_onlyScreenOn] isKindOfClass:[NSNumber class]]) {
        config.onlyScreenOn = [params[Argument_onlyScreenOn] boolValue];
    }
    if ([params[Argument_allowDuplicates] isKindOfClass:[NSNumber class]]) {
        config.allowDuplicates = [params[Argument_allowDuplicates] boolValue];
    }
    if ([params[Argument_duration] isKindOfClass:[NSNumber class]]) {
        config.duration = [params[Argument_duration] intValue];
    }
    if ([params[Argument_unit] isKindOfClass:[NSNumber class]]) {
        QNUnit unit = QNUnitKG;
        switch ([params[Argument_unit] intValue]) {
            case 1: unit = QNUnitLB; break;
            case 2: unit = QNUnitJIN; break;
            case 3: unit = QNUnitST; break;
            default:
                break;
        }
        config.unit = unit;
    }
    
    if ([params[Argument_iOSShowPowerAlertKey] isKindOfClass:[NSNumber class]]) {
        config.showPowerAlertKey = [params[Argument_iOSShowPowerAlertKey] boolValue];
    }
    
    [config save];
    result([self transformJsonFromErr:nil]);
}

- (void)generateScaleDataWithParams:(NSDictionary *)params result:(FlutterResult)result {
    NSDate *measureDate = [NSDate date];
    if ([params[Argument_measureTime] isKindOfClass:[NSNumber class]]) {
        measureDate = [NSDate dateWithTimeIntervalSince1970:[self transformSecondWithMilliSecond:[params[Argument_measureTime] integerValue]]];
    }
    NSInteger milliMeasureTime = [self transformMilliSecondWithSecond:[measureDate timeIntervalSince1970]];
    
    NSString *mac = params[Argument_mac];
    NSString *hmac = params[Argument_hmac];
    
    double weight = 0;
    NSNumber *weightNum = params[Argument_weight];
    if ([weightNum isKindOfClass:[NSNumber class]]) {
        weight = [weightNum doubleValue];
    }
    
    QNUser *user = [self transformUserWithJson:params[Argument_user]];
    
    QNScaleStoreData *scaleStoreData = [QNScaleStoreData buildStoreDataWithWeight:weight measureTime:measureDate mac:mac hmac:hmac callBlock:^(NSError *error) {

    }];
    
    NSMutableDictionary *storeDataJson = [NSMutableDictionary dictionary];
    if (scaleStoreData) {
        [scaleStoreData setUser:user];
        QNScaleData *scaleData = [scaleStoreData generateScaleData];
        storeDataJson[Argument_user] = params[Argument_user];
        storeDataJson[Argument_measureTime] = [NSNumber numberWithInteger:[self transformSecondWithMilliSecond:milliMeasureTime]];
        storeDataJson[Argument_hmac] = hmac;
        
        NSMutableArray *allItemDataArr = [NSMutableArray array];
        for (QNScaleItemData *item in [scaleData getAllItem]) {
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
            itemDic[Argument_type] = [NSNumber numberWithInteger:item.type];
            itemDic[Argument_value] = [NSNumber numberWithDouble:item.value];
            itemDic[Argument_valueType] = [NSNumber numberWithInteger:item.valueType];
            itemDic[Argument_name] = item.name;
            [allItemDataArr addObject:itemDic];
        }
        storeDataJson[Argument_allItemData] = allItemDataArr;
    }
    result(storeDataJson);
}

#pragma mark - iOS Call Flutter
- (void)callFlutterWithParams:(NSDictionary *)params {
    self.eventSink(params);
}


#pragma mark - transform
- (NSDictionary *)transformJsonFromErr:(NSError *)err {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    if (err == nil) {
        json[Argument_errorCode] = @0;
    } else {
        json[Argument_errorCode] = [NSNumber numberWithInteger:err.code];
        json[Argument_errorMsg] = err.userInfo[NSLocalizedFailureReasonErrorKey];
    }
    return json;
}

- (NSInteger)transformMilliSecondWithSecond:(NSInteger)second {
    return second * 1000;
}

- (NSInteger)transformSecondWithMilliSecond:(NSInteger)second {
    return second / 1000;
}

- (QNUser *)transformUserWithJson:(NSDictionary *)json {
    QNUser *user = [[QNUser alloc] init];
    user.userId = json[Argument_userId];
    
    NSNumber *heightNum = json[Argument_height];
    if ([heightNum isKindOfClass:[NSNumber class]]) {
        user.height = [heightNum intValue];
    }
    
    user.gender = json[Argument_gender];
    
    NSNumber *milliTimeNum = json[Argument_birthday];
    if ([milliTimeNum isKindOfClass:[NSNumber class]]) {
        user.birthday = [NSDate dateWithTimeIntervalSince1970:[self transformSecondWithMilliSecond:[milliTimeNum integerValue]]];
    }
    
    NSNumber *athleteTypeNum = json[Argument_athleteType];
    if ([athleteTypeNum isKindOfClass:[NSNumber class]]) {
        user.athleteType = [athleteTypeNum intValue];
    }
    
    NSNumber *clothesNum = json[Argument_clothesWeight];
    if ([clothesNum isKindOfClass:[NSNumber class]]) {
        user.clothesWeight = [clothesNum doubleValue];
    }
    return user;
}

- (NSDictionary *)jsonWithScaleData:(QNScaleData *)scaleData {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *userJson = [NSMutableDictionary dictionary];
    userJson[Argument_userId] = scaleData.user.userId;
    userJson[Argument_height] = [NSNumber numberWithInt:scaleData.user.height];
    userJson[Argument_gender] = scaleData.user.gender;
    userJson[Argument_birthday] = [NSNumber numberWithInteger:[self transformMilliSecondWithSecond:[scaleData.user.birthday timeIntervalSince1970]]];
    userJson[Argument_athleteType] = [NSNumber numberWithInteger:scaleData.user.athleteType];
    userJson[Argument_clothesWeight] = [NSNumber numberWithDouble:scaleData.user.clothesWeight];
    json[Argument_user] = userJson;
    
    json[Argument_measureTime] = [NSNumber numberWithInteger:[self transformMilliSecondWithSecond:[scaleData.measureTime timeIntervalSince1970]]];
    json[Argument_hmac] = scaleData.hmac;
    
    NSMutableArray *allItemDataJson = [NSMutableArray array];
    for (QNScaleItemData *item in [scaleData getAllItem]) {
        NSMutableDictionary *itemJson = [NSMutableDictionary dictionary];
        itemJson[Argument_type] = [NSNumber numberWithInteger:item.type];
        itemJson[Argument_value] = [NSNumber numberWithDouble:item.value];
        itemJson[Argument_valueType] = [NSNumber numberWithInteger:item.valueType];
        itemJson[Argument_name] = item.name;
        [allItemDataJson addObject:itemJson];
    }
    json[Argument_allItemData] = allItemDataJson;
    
    return json;
}

- (NSDictionary *)jsonWithDevice:(QNBleDevice *)device {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[Argument_mac] = device.mac;
    json[Argument_name] = device.name;
    json[Argument_modeId] = device.modeId;
    json[Argument_bluetoothName] = device.bluetoothName;
    json[Argument_rssi] = device.RSSI;
    json[Argument_isScreenOn] = [NSNumber numberWithBool:device.isScreenOn];
    return json;
}

#pragma mark - Getter
- (NSMutableDictionary *)scanDevices {
    if (_scanDevices == nil) {
        _scanDevices = [NSMutableDictionary dictionary];
    }
    return _scanDevices;
}

@end
