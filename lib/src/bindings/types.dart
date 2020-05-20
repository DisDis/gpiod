
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class gpiod_line extends Struct{

}

class gpiod_chip extends Struct{
  ///struct gpiod_line **lines;
  Pointer<Pointer<gpiod_line>> lines;
  @Int32()
  int num_lines;

  @Int32()
  int fd;

  //TODO: https://github.com/dart-lang/sdk/issues/35763
  //@InlineArray(32)
  @Int8()
  int name;
  @Int8()
  int name1;
  @Int8()
  int name2;
  @Int8()
  int name3;
  @Int8()
  int name4;
  @Int8()
  int name5;
  @Int8()
  int name6;
  @Int8()
  int name7;
  @Int8()
  int name8;
  @Int8()
  int name9;
  @Int8()
  int name10;
  @Int8()
  int name11;
  @Int8()
  int name12;
  @Int8()
  int name13;
  @Int8()
  int name14;
  @Int8()
  int name15;
  @Int8()
  int name16;
  @Int8()
  int name17;
  @Int8()
  int name18;
  @Int8()
  int name19;
  @Int8()
  int name20;
  @Int8()
  int name21;
  @Int8()
  int name22;
  @Int8()
  int name23;
  @Int8()
  int name24;
  @Int8()
  int name25;
  @Int8()
  int name26;
  @Int8()
  int name27;
  @Int8()
  int name28;
  @Int8()
  int name29;
  @Int8()
  int name30;
  @Int8()
  int name31;

  //@InlineArray(32)
  Pointer<Utf8> label;
}

class gpiod_chip_iter extends Struct{

}

class gpiod_line_request_config extends Struct{

}

class gpiod_line_bulk extends Struct{

}


class gpiod_line_event extends Struct{

}

class timespec extends Struct{
  @Int32()
  ///seconds
  /*time_t*/ int tv_sec;
  @Int32()
  ///nanoseconds
  int    tv_nsec;
}

class gpiod_line_iter extends Struct{

}


