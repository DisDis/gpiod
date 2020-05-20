import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

//https://github.com/brgl/libgpiod/blob/master/lib/core.c

const LINE_FREE = 0;
const LINE_REQUESTED_VALUES = 1;
const LINE_REQUESTED_EVENTS = 2;

class line_fd_handle extends Struct {
  @Int32()
  int fd;
  @Int32()
  int refcount;
}

class gpiod_line extends Struct{

  //unsigned int offset;
  @Uint32()
  int offset;

  /* The direction of the GPIO line. */
  //int direction;
  @Int32()
  int direction;


  /* The active-state configuration. */
  @Int32()
  int active_state;

  /* The logical value last written to the line. */
  @Int32()
  int output_value;

  /* The GPIOLINE_FLAGs returned by GPIO_GET_LINEINFO_IOCTL. */
  @Uint32()
  int info_flags;

  /* The GPIOD_LINE_REQUEST_FLAGs provided to request the line. */
  @Uint32()
  int req_flags;

  /*
	 * Indicator of LINE_FREE, LINE_REQUESTED_VALUES or
	 * LINE_REQUESTED_EVENTS.
	 */
  @Int32()
  int state;

  Pointer<gpiod_chip> chip;
  Pointer<line_fd_handle> fd_handle;

  //TODO: https://github.com/dart-lang/sdk/issues/35763
  //@InlineArray(32)
  String get name =>utf8.decode([name0,name1,name2,name3,name4,name5,name6,name7,name8,name9,name10,name11,name12,
    name13,name14,name15,name16,name17,name18,name19,name20,name21,name22,name23,name24,name25,name26,name27,name28,
    name29,name30,name31],allowMalformed: true);
  @Int8()
  int name0;
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

  //TODO: https://github.com/dart-lang/sdk/issues/35763
  //@InlineArray(32)
  String get consumer =>utf8.decode([consumer0,consumer1,consumer2,consumer3,consumer4,consumer5,consumer6,consumer7,
    consumer8,consumer9,consumer10,consumer11,consumer12,consumer13,consumer14,consumer15,consumer16,consumer17,
    consumer18,consumer19,consumer20,consumer21,consumer22,consumer23,consumer24,consumer25,consumer26,consumer27,
    consumer28,consumer29,consumer30,consumer31],allowMalformed: true);
  //@InlineArray(32)
  @Int8() int consumer0;
  @Int8() int consumer1;
  @Int8() int consumer2;
  @Int8() int consumer3;
  @Int8() int consumer4;
  @Int8() int consumer5;
  @Int8() int consumer6;
  @Int8() int consumer7;
  @Int8() int consumer8;
  @Int8() int consumer9;
  @Int8() int consumer10;
  @Int8() int consumer11;
  @Int8() int consumer12;
  @Int8() int consumer13;
  @Int8() int consumer14;
  @Int8() int consumer15;
  @Int8() int consumer16;
  @Int8() int consumer17;
  @Int8() int consumer18;
  @Int8() int consumer19;
  @Int8() int consumer20;
  @Int8() int consumer21;
  @Int8() int consumer22;
  @Int8() int consumer23;
  @Int8() int consumer24;
  @Int8() int consumer25;
  @Int8() int consumer26;
  @Int8() int consumer27;
  @Int8() int consumer28;
  @Int8() int consumer29;
  @Int8() int consumer30;
  @Int8() int consumer31;
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
  String get name =>utf8.decode([name0,name1,name2,name3,name4,name5,name6,name7,name8,name9,name10,name11,name12,
    name13,name14,name15,name16,name17,name18,name19,name20,name21,name22,name23,name24,name25,name26,name27,name28,
    name29,name30,name31],allowMalformed: true);
  @Int8()
  int name0;
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

  String get label =>utf8.decode([label0,label1,label2,label3,label4,label5,label6,label7,label8,label9,label10,label11,
    label12,label13,label14,label15,label16,label17,label18,label19,label20,label21,label22,label23,label24,
    label25,label26,label27,label28,label29,label30,label31],allowMalformed: true);
  //@InlineArray(32)
  @Int8() int label0;
  @Int8() int label1;
  @Int8() int label2;
  @Int8() int label3;
  @Int8() int label4;
  @Int8() int label5;
  @Int8() int label6;
  @Int8() int label7;
  @Int8() int label8;
  @Int8() int label9;
  @Int8() int label10;
  @Int8() int label11;
  @Int8() int label12;
  @Int8() int label13;
  @Int8() int label14;
  @Int8() int label15;
  @Int8() int label16;
  @Int8() int label17;
  @Int8() int label18;
  @Int8() int label19;
  @Int8() int label20;
  @Int8() int label21;
  @Int8() int label22;
  @Int8() int label23;
  @Int8() int label24;
  @Int8() int label25;
  @Int8() int label26;
  @Int8() int label27;
  @Int8() int label28;
  @Int8() int label29;
  @Int8() int label30;
  @Int8() int label31;
}

class gpiod_chip_iter extends Struct{

}

class gpiod_line_request_config extends Struct{

  /**< Name of the consumer. */
  Pointer<Utf8> consumer;

  @Int32()
  /**< Request type. */
  int request_type;

  @Int32()
  /**< Other configuration flags. */
  int flags;
}

class gpiod_line_bulk extends Struct{

  //#define GPIOD_LINE_BULK_MAX_LINES	64
  //struct gpiod_line *lines[GPIOD_LINE_BULK_MAX_LINES];
  /**< Buffer for line pointers. */
  List<Pointer<gpiod_line>> get lines=>[line0,line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11,
    line12,line13,line14,line15,line16,line17,line18,line19,line20,line21,line22,line23,line24,line25,line26,line27,
    line28,line29,line30,line31,line32,line33,line34,line35,line36,line37,line38,line39,line40,line41,line42,line43,
    line44,line45,line46,line47,line48,line49,line50,line51,line52,line53,line54,line55,line56,line57,line58,line59,
    line60,line61,line62,line63];
  Pointer<gpiod_line> line0;
  Pointer<gpiod_line> line1;
  Pointer<gpiod_line> line2;
  Pointer<gpiod_line> line3;
  Pointer<gpiod_line> line4;
  Pointer<gpiod_line> line5;
  Pointer<gpiod_line> line6;
  Pointer<gpiod_line> line7;
  Pointer<gpiod_line> line8;
  Pointer<gpiod_line> line9;
  Pointer<gpiod_line> line10;
  Pointer<gpiod_line> line11;
  Pointer<gpiod_line> line12;
  Pointer<gpiod_line> line13;
  Pointer<gpiod_line> line14;
  Pointer<gpiod_line> line15;
  Pointer<gpiod_line> line16;
  Pointer<gpiod_line> line17;
  Pointer<gpiod_line> line18;
  Pointer<gpiod_line> line19;
  Pointer<gpiod_line> line20;
  Pointer<gpiod_line> line21;
  Pointer<gpiod_line> line22;
  Pointer<gpiod_line> line23;
  Pointer<gpiod_line> line24;
  Pointer<gpiod_line> line25;
  Pointer<gpiod_line> line26;
  Pointer<gpiod_line> line27;
  Pointer<gpiod_line> line28;
  Pointer<gpiod_line> line29;
  Pointer<gpiod_line> line30;
  Pointer<gpiod_line> line31;
  Pointer<gpiod_line> line32;
  Pointer<gpiod_line> line33;
  Pointer<gpiod_line> line34;
  Pointer<gpiod_line> line35;
  Pointer<gpiod_line> line36;
  Pointer<gpiod_line> line37;
  Pointer<gpiod_line> line38;
  Pointer<gpiod_line> line39;
  Pointer<gpiod_line> line40;
  Pointer<gpiod_line> line41;
  Pointer<gpiod_line> line42;
  Pointer<gpiod_line> line43;
  Pointer<gpiod_line> line44;
  Pointer<gpiod_line> line45;
  Pointer<gpiod_line> line46;
  Pointer<gpiod_line> line47;
  Pointer<gpiod_line> line48;
  Pointer<gpiod_line> line49;
  Pointer<gpiod_line> line50;
  Pointer<gpiod_line> line51;
  Pointer<gpiod_line> line52;
  Pointer<gpiod_line> line53;
  Pointer<gpiod_line> line54;
  Pointer<gpiod_line> line55;
  Pointer<gpiod_line> line56;
  Pointer<gpiod_line> line57;
  Pointer<gpiod_line> line58;
  Pointer<gpiod_line> line59;
  Pointer<gpiod_line> line60;
  Pointer<gpiod_line> line61;
  Pointer<gpiod_line> line62;
  Pointer<gpiod_line> line63;


  @Uint32()
  /**< Number of lines currently held in this structure. */
  /*unsigned int*/ int num_lines;

}


class gpiod_line_event extends Struct{
  /**< Best estimate of time of event occurrence. */
  //timespec ts;
  @Int32()
  ///seconds
  /*time_t*/ int tv_sec;
  @Int32()
  ///nanoseconds
  int    tv_nsec;

  @Int32()
  /**< Type of the event that occurred. */
  int event_type;
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


