import 'dart:ffi';

import 'package:ffi/ffi.dart';

class ErrorData extends Struct{
  Pointer<Utf8>  error;
  @Int32()
  int code;
  factory ErrorData.allocate() =>
      allocate<ErrorData>().ref
        ..code = 0
        ..error = Pointer.fromAddress(0);
}

class LineConfig extends Struct{
//  Pointer<gpiod_line> line;
//  LineDirection direction;
//  LineRequestType request_type;
  @Uint32()
  int lineHandle;

  Pointer<Utf8>  consumer;
  @Uint32()
  int direction;
  @Uint32()
  int outputMode;
  @Uint32()
  int bias;
  @Uint32()
  int activeState;
  @Uint32()
  int triggers;
  @Uint32()
  int initialValue;

  factory LineConfig.allocate() =>
      allocate<LineConfig>().ref
        ..consumer = Pointer.fromAddress(0);
}


class ChipDetails extends Struct{
  Pointer<Utf8> name;

  Pointer<Utf8> label;

  @Int32()
  int numLines;
  factory ChipDetails.allocate() =>
      allocate<ChipDetails>().ref
        ..name = Pointer.fromAddress(0)
        ..label = Pointer.fromAddress(0)
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
        ..name = Pointer.fromAddress(0)
        ..consumer = Pointer.fromAddress(0);
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
