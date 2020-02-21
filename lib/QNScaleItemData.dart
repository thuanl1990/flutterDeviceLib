/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:13:43 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:25:45
 */

part of qnsdk;

class QNScaleItemData {
  final int type;
  final double value;
  final int valueType;
  final String name;

  QNScaleItemData(this.type, this.value, this.valueType, this.name);

  QNScaleItemData.fromJson(Map params)
      : this(params[ArgumentName.type], params[ArgumentName.value],
            params[ArgumentName.valueType], params[ArgumentName.name]);
}
