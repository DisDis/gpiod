import 'dart:ffi';

import 'package:ffi/ffi.dart';


class ChipDetails extends Struct{
  Pointer<Utf8> name;

  Pointer<Utf8> label;

  @Int32()
  int numLines;
  factory ChipDetails.allocate() =>
      allocate<ChipDetails>().ref
        ..name = null
        ..label = null
        ..numLines = 0;
}

class LineDetails extends Struct{
  Pointer<Utf8> name;
  Pointer<Utf8> consumer;
  @Uint8()
  int isUsed;
  @Uint8()
  int isRequested;
  @Uint8()
  int isFree;
  @Uint32()
  int direction;
  //@Uint32()
  //int outputMode;
  @Uint32()
  int open_source;
  @Uint32()
  int open_drain;

  @Uint32()
  int bias;
  @Uint32()
  int activeState;
  factory LineDetails.allocate() =>
      allocate<LineDetails>().ref
        ..name = null
        ..consumer = null;
}


//class epoll_event extends Struct{
//  @Int32()
//  /*unsigned long int*/ int events;
//
//  //epoll_data_t data;
//  Pointer<Void> ptr;
//  @Int32()
//  int fd;
//  @Int32()
//  int u32;
//  @Int64()
//  int u64;
//
//  factory epoll_event.allocate() =>
//      allocate<epoll_event>().ref;
//}
