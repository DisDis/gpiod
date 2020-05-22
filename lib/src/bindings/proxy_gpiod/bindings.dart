
import 'dart:ffi';

import 'package:gpiod/src/bindings/proxy_gpiod/signatures.dart';
import 'package:gpiod/src/bindings/proxy_gpiod/types.dart';

class ProxyGPIOD {
  final String libraryName = './libproxy_gpiod.so';
  DynamicLibrary _dynamicLibrary;

  //int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
//  int Function(int epfd, int op, int fd, Pointer<epoll_event> event) epoll_ctl;

  ///void print_hello();
  void Function() print_hello;




  static ProxyGPIOD _instance;

  factory ProxyGPIOD(){
    if (_instance == null) {
      _instance = new ProxyGPIOD._internal();
    }
    return _instance;
  }

  ProxyGPIOD._internal(){
    _dynamicLibrary = DynamicLibrary.open(libraryName);

    print_hello = _dynamicLibrary.lookup<NativeFunction<print_hello_native_t>>("print_hello").asFunction();
  }
}