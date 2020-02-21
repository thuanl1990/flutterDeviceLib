/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:38:42 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:25:50
 */

part of qnsdk;

class QNScaleStoreData {
  final double weight;
  final DateTime measureTime;
  final String mac;
  final String hmac;

  QNScaleStoreData(this.weight, this.measureTime, this.mac, this.hmac);

  QNScaleStoreData.fromJson(Map params)
      : this(
            params[ArgumentName.weight],
            DateTime.fromMillisecondsSinceEpoch(
                params[ArgumentName.measureTime] ?? 0),
            params[ArgumentName.mac],
            params[ArgumentName.hmac]);
}
