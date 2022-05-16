/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 15:59:22 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:18:28
 */

part of qnsdk;

class QNBleDevice {
  final String mac;
  final String name;
  final String modeId;
  final String bluetoothName;
  final int rssi;
  final bool isScreenOn;
  bool isConnect = false;

  QNBleDevice(this.mac, this.name, this.modeId, this.bluetoothName, this.rssi,
      this.isScreenOn, this.isConnect);

  QNBleDevice.fromJson(Map params)
      : this(
            params[ArgumentName.mac],
            params[ArgumentName.name],
            params[ArgumentName.modeId],
            params[ArgumentName.bluetoothName],
            params[ArgumentName.rssi],
            params[ArgumentName.isScreenOn],
            false);

  Map<String, dynamic> getParams() {
    var params = <String, dynamic>{};
    params[ArgumentName.mac] = this.mac;
    params[ArgumentName.name] = this.name;
    params[ArgumentName.modeId] = this.modeId;
    params[ArgumentName.bluetoothName] = this.bluetoothName;
    params[ArgumentName.rssi] = this.rssi;
    params[ArgumentName.isScreenOn] = this.isScreenOn;
    params[ArgumentName.isConnect] = false;
    return params;
  }
}
