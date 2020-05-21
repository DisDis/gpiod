
import 'dart:ffi';

import 'package:ffi/ffi.dart';


class epoll_event extends Struct{
  @Int32()
  /*unsigned long int*/ int events;

  //epoll_data_t data;
  Pointer<Void> ptr;
  @Int32()
  int fd;
  @Int32()
  int u32;
  @Int64()
  int u64;

  factory epoll_event.allocate() =>
      allocate<epoll_event>().ref;
}

class epoll_data_t extends Struct{
    Pointer<Void> ptr;
    @Int32()
    int fd;
    @Int32()
    int u32;
    @Int64()
    int u64;
    factory epoll_data_t.allocate() =>
        allocate<epoll_data_t>().ref;
}

/*
typedef union epoll_data {
                void *ptr;
                int fd;
                __uint32_t u32;
                __uint64_t u64;
        } epoll_data_t;

struct epoll_event {
        __uint32_t events;      /* events epoll */
        epoll_data_t data;      /* user data */
};
*/