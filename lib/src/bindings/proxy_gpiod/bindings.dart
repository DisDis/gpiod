
import 'dart:ffi';

import 'package:gpiod/src/bindings/proxy_gpiod/signatures.dart';
import 'package:gpiod/src/bindings/proxy_gpiod/types.dart';

final DynamicLibrary _dynamicLibrary = DynamicLibrary.open(ProxyGPIOD.libraryName);

class ProxyGPIOD {
  static const String libraryName = './libproxy_gpiod.so';


  //int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
//  int Function(int epfd, int op, int fd, Pointer<epoll_event> event) epoll_ctl;

  ///void print_hello();
  final void Function() print_hello = _dynamicLibrary.lookup<NativeFunction<print_hello_native_t>>("print_hello")
      .asFunction();

  final register_send_port = _dynamicLibrary.lookupFunction<Void Function(Int64 sendPort),
      void Function(int sendPort)>('proxy_gpiod_register_send_port');

  ///int gpiodp_get_num_chips(struct platch_obj *object, FlutterPlatformMessageResponseHandle *responsehandle)
  final int Function() get_num_chips = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_get_num_chips')
      .asFunction();

  final int Function(int chipIndex, Pointer<ChipDetails> result) get_chip_details = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_chip_details_native_t>>('gpiodp_get_chip_details').asFunction();
  final int Function(int chipIndex,int lineIndex) get_line_handle = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_handle_native_t>>('gpiodp_get_line_handle').asFunction();
  final int Function(int lineHandle, Pointer<LineDetails> result) get_line_details = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_details_native_t>>('gpiodp_get_line_details').asFunction();
  final int Function() request_line = _dynamicLibrary.lookup<NativeFunction<gpiodp_request_line_native_t>>('gpiodp_request_line').asFunction();
  final int Function(int lineHandle) release_line = null;//_dynamicLibrary.lookup<NativeFunction<gpiodp_release_line_native_t>>('gpiodp_release_line').asFunction();
  final int Function() reconfigure_line = null;//_dynamicLibrary.lookup<NativeFunction<gpiodp_reconfigure_line_native_t>>('gpiodp_reconfigure_line').asFunction();
  final int Function() get_line_value = null;//_dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_value_native_t>>('gpiodp_get_line_value').asFunction();
  final int Function() set_line_value = null;//_dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_set_line_value').asFunction();
  final int Function() supports_bias = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_supports_bias')
      .asFunction();
  final int Function() supports_reconfiguration = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_supports_reconfiguration')
      .asFunction();

  static ProxyGPIOD _instance;

  factory ProxyGPIOD(){
    if (_instance == null) {
      _instance = new ProxyGPIOD._internal();
    }
    return _instance;
  }

  ProxyGPIOD._internal();
}