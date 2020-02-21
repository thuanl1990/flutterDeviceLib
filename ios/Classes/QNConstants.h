//
//  QNConstants.h
//  Pods
//
//  Created by Yolanda on 2020/2/13.
//

#ifndef QNConstants_h
#define QNConstants_h


#define MethodName_initSdk @"flutter_initSdk"
#define MethodName_setBleStateListener @"flutter_setBleStateListener"
#define MethodName_setBleDeviceDiscoveryListener @"flutter_setBleDeviceDiscoveryListener"
#define MethodName_startBleDeviceDiscovery @"flutter_startBleDeviceDiscovery"
#define MethodName_stopBleDeviceDiscovery @"flutter_stopBleDeviceDiscovery"
#define MethodName_connectDevice @"flutter_connectDevice"
#define MethodName_disconnectDevice @"flutter_disconnectDevice"
#define MethodName_setBleConnectionChangeListener @"flutter_setBleConnectionChangeListener"
#define MethodName_setScaleDataListener @"flutter_setScaleDataListener"
#define MethodName_getConfig @"flutter_getConfig"
#define MethodName_saveConfig @"flutter_saveConfig"
#define MethodName_generateScaleData @"flutter_generateScaleData"


#define EventName_onBleSystemState @"flutter_onBleSystemState"
#define EventName_onGetUnsteadyWeight @"flutter_onGetUnsteadyWeight"
#define EventName_onGetScaleData @"flutter_onGetScaleData"
#define EventName_onGetStoredScale @"flutter_onGetStoredScale"
#define EventName_onGetElectric @"flutter_onGetElectric"
#define EventName_onScaleStateChange @"flutter_onScaleStateChange"
#define EventName_onDeviceDiscover @"flutter_onDeviceDiscover"
#define EventName_onStartScan @"flutter_onStartScan"
#define EventName_onStopScan @"flutter_onStopScan"
#define EventName_onScanFail @"flutter_onScanFail"
#define EventName_onConnecting @"flutter_onConnecting"
#define EventName_onConnected @"flutter_onConnected"
#define EventName_onServiceSearchComplete @"flutter_onServiceSearchComplete"
#define EventName_onDisconnecting @"flutter_onDisconnecting"
#define EventName_onDisconnected @"flutter_onDisconnected"
#define EventName_onConnectError @"flutter_onConnectError"


#define Argument_channelName @"yolanda.flutter.io/channe"
#define Argument_eventName @"yolanda.flutter.io/event"
#define Argument_methodName @"method"

#define Argument_errorCode @"errorCode"
#define Argument_errorMsg @"errorMsg"

#define Argument_device @"device"
#define Argument_mac @"mac"
#define Argument_name @"name"
#define Argument_modeId @"modeId"
#define Argument_bluetoothName @"bluetoothName"
#define Argument_rssi @"rssi"
#define Argument_isScreenOn @"isScreenOn"

#define Argument_onlyScreenOn @"onlyScreenOn"
#define Argument_allowDuplicates @"allowDuplicates"
#define Argument_duration @"duration"
#define Argument_unit @"unit"
#define Argument_iOSShowPowerAlertKey @"iOSShowPowerAlertKey"
#define Argument_androidConnectOutTime @"androidConnectOutTime"
#define Argument_androidSetNotCheckGPS @"androidSetNotCheckGPS"

#define Argument_scaleData @"scaleData"
#define Argument_user @"user"
#define Argument_measureTime @"measureTime"
#define Argument_hmac @"hmac"
#define Argument_allItemData @"allItemData"

#define Argument_type @"type"
#define Argument_value @"value"
#define Argument_valueType @"valueType"

#define Argument_weight @"weight"

#define Argument_userId @"userId"
#define Argument_height @"height"
#define Argument_gender @"gender"
#define Argument_birthday @"birthday"
#define Argument_athleteType @"athleteType"
#define Argument_clothesWeight @"clothesWeight"

#define Argument_appid @"appid"
#define Argument_fileContent @"fileContent"

#define Argument_state @"state"
#define Argument_data @"data"
#define Argument_storedDataList @"storedDataList"
#define Argument_electric @"electric"
#define Argument_scaleState @"scaleState"

#endif /* QNConstants_h */
