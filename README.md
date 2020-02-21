# qnsdk

qnsdk is yolanda Company smart device communication plug-in.

## Usage

To use this plugin, add `qnsdk` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Getting Started

##### Xcode configuration

- iOS10.0 and above must have Bluetooth instructions in Info.plist, otherwise the system's Bluetooth function cannot be used
- iOS13.0 and above must be configured with the authorization instructions for Bluetooth in Info.plist, otherwise it will be found to crash.
- There is a pair in the Info.plist [Privacy - Bluetooth Peripheral Usage Description][privacy - bluetooth always usage description] button.

##### Android

## Sample Usage

### Initialising

```dart
 String configFileContent = await rootBundle.loadString('data/123456789.qn');
 qnApi.initSDK('123456789', configFileContent).then((result) => print('initSDK ${result.errorCode}'));
```

### Set up listening

```dart
 qnApi.setBleStateListener(this);
 qnApi.setBleDeviceDiscoveryListener(this);
 qnApi.setBleConnectionChangeListener(this);
 qnApi.setScaleDataListener(this);
```

### Start scanning

```dart
 qnApi.startBleDeviceDiscovery();
```

### Connection

```dart
 qnApi.connectDevice(device,user);
```

### Receive data

```dart
 @override
  void onGetUnsteadyWeight(QNBleDevice device, double weight) {
    unsteadyWeightStream.add(weight);
  }

  @override
  void onGetScaleData(QNBleDevice device, QNScaleData data) {
    scaleDataStream.add(data);
  }

  @override
  void onGetStoredScale(
      QNBleDevice device, List<QNScaleStoreData> storedDataList) {
    for (var item in storedDataList) {
      storedDataStream.add(item);
    }
  }

  @override
  void onScaleStateChange(QNBleDevice device, int scaleState) {
    deviceStateStream.add(scaleState);
  }
```
