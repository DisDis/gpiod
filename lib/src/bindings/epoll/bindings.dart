
import 'dart:ffi';

import 'package:gpiod/src/bindings/epoll/signatures.dart';
import 'package:gpiod/src/bindings/epoll/types.dart';

class Epoll {
  final String libraryName = 'libepoll.so';
  DynamicLibrary _dynamicLibrary;

  ///int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
  int Function(int epfd, int op, int fd, Pointer<epoll_event> event) epoll_ctl;

  ///int epoll_create(int size);
  int Function(int size) epoll_create;
  ///int epoll_create1(int flags);
  int Function(int flags) epoll_create1;

  ///int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
  int Function(int epfd, Pointer<epoll_event> events, int maxevents, int timeout) epoll_wait;
  //int epoll_pwait(int epfd, struct epoll_event *events,int maxevents, int timeout, const sigset_t *sigmask);


  static Epoll _instance;

  factory Epoll(){
    if (_instance == null) {
      _instance = new Epoll._internal();
    }
    return _instance;
  }

  Epoll._internal(){
    _dynamicLibrary = DynamicLibrary.open(libraryName);

    epoll_ctl = _dynamicLibrary.lookup<NativeFunction<epoll_ctl_native_t>>("epoll_ctl").asFunction();
    epoll_create = _dynamicLibrary.lookup<NativeFunction<epoll_create_native_t>>("epoll_create").asFunction();
    epoll_create1 = _dynamicLibrary.lookup<NativeFunction<epoll_create1_native_t>>("epoll_create1").asFunction();
    epoll_wait = _dynamicLibrary.lookup<NativeFunction<epoll_wait_native_t>>("epoll_wait").asFunction();
  }
}