import 'dart:ffi';

import 'package:ffi/ffi.dart';

class ErrorData extends Struct{
  external Pointer<Utf8>  error;
  @Int32()
  external int code;
  ErrorData():super(){
    code = 0;
    error = Pointer.fromAddress(0);
  }

}

class LineConfig extends Struct{
//  Pointer<gpiod_line> line;
//  LineDirection direction;
//  LineRequestType request_type;
  @Uint32()
  external int lineHandle;

  external Pointer<Utf8>  consumer;
  @Uint32()
  external int direction;
  @Uint32()
  external int outputMode;
  @Uint32()
  external int bias;
  @Uint32()
  external int activeState;
  @Uint32()
  external int triggers;
  @Uint32()
  external int initialValue;

  LineConfig():super(){
    consumer = Pointer.fromAddress(0);
  }
}


class ChipDetails{
  final String name;
  final String label;
  final int numLines;

  ChipDetails(this.name, this.label, this.numLines);
  factory ChipDetails.from(ChipDetailsStruct value){
   return ChipDetails(value.name.toDartString(), value.label.toDartString(), value.numLines);
  }
}

class ChipDetailsStruct extends Struct{
  external Pointer<Utf8> name;

  external Pointer<Utf8> label;

  @Int32()
  external int numLines;

  ChipDetailsStruct():super(){
     name = Pointer.fromAddress(0);
     label = Pointer.fromAddress(0);
     numLines = 0;
   }

}

class LineDetails extends Struct{
  external Pointer<Utf8> name;
  external Pointer<Utf8> consumer;
  @Uint8()
  external int isUsed;
  @Uint8()
  external int isRequested;
  @Uint8()
  external int isFree;
  @Uint32()
  external int direction;
  //@Uint32()
  //int outputMode;
  @Uint32()
  external int open_source;
  @Uint32()
  external int open_drain;

  @Uint32()
  external int bias;
  @Uint32()
  external int activeState;
  LineDetails():super(){
    name = Pointer.fromAddress(0);
    consumer = Pointer.fromAddress(0);
  }
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
