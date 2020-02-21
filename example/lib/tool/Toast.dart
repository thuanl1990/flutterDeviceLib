/*
 * @Author: Yolanda 
 * @Date: 2020-02-20 15:40:12 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 15:41:19
 */

import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void showCenterToast(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }
}
