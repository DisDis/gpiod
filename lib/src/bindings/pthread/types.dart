
import 'dart:ffi';

import 'package:ffi/ffi.dart';


class pthread_mutex_t extends Struct {

  @Int8()
  int oneByte;

  //occupies 24 bytes on 32-bit machines and 40 bytes on 64-bit machines.
  factory pthread_mutex_t.allocate() =>
      allocate<pthread_mutex_t>(count: 40).ref;
}

class pthread_t extends Struct{
  @Int64()
  /*unsigned long int*/ int pthreadId;

  factory pthread_t.allocate() =>
      allocate<pthread_t>().ref;
}

class pthread_attr_t extends Struct{

}