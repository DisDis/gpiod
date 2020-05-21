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

class gpiod_line_request_config extends Struct {

  /**< Name of the consumer. */
  Pointer<Utf8> consumer;

  @Int32()
  /**< Request type. */
  int request_type;

  @Int32()
  /**< Other configuration flags. */
  int flags;

  factory gpiod_line_request_config.allocate(Pointer<Utf8> consumer, int request_type, int flags) =>
      allocate<gpiod_line_request_config>().ref
        ..consumer = consumer
        ..request_type = request_type
        ..flags = flags;
}

class gpiod_line_bulk extends Struct{

  factory gpiod_line_bulk.allocate() =>
      allocate<gpiod_line_bulk>().ref..num_lines = 0;

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

  Pointer<gpiod_line> getLine(int index){
    switch (index){
      case 0: return line0; break;
      case 1: return line1; break;
      case 2: return line2; break;
      case 3: return line3; break;
      case 4: return line4; break;
      case 5: return line5; break;
      case 6: return line6; break;
      case 7: return line7; break;
      case 8: return line8; break;
      case 9: return line9; break;
      case 10: return line10; break;
      case 11: return line11; break;
      case 12: return line12; break;
      case 13: return line13; break;
      case 14: return line14; break;
      case 15: return line15; break;
      case 16: return line16; break;
      case 17: return line17; break;
      case 18: return line18; break;
      case 19: return line19; break;
      case 20: return line20; break;
      case 21: return line21; break;
      case 22: return line22; break;
      case 23: return line23; break;
      case 24: return line24; break;
      case 25: return line25; break;
      case 26: return line26; break;
      case 27: return line27; break;
      case 28: return line28; break;
      case 29: return line29; break;
      case 30: return line30; break;
      case 31: return line31; break;
      case 32: return line32; break;
      case 33: return line33; break;
      case 34: return line34; break;
      case 35: return line35; break;
      case 36: return line36; break;
      case 37: return line37; break;
      case 38: return line38; break;
      case 39: return line39; break;
      case 40: return line40; break;
      case 41: return line41; break;
      case 42: return line42; break;
      case 43: return line43; break;
      case 44: return line44; break;
      case 45: return line45; break;
      case 46: return line46; break;
      case 47: return line47; break;
      case 48: return line48; break;
      case 49: return line49; break;
      case 50: return line50; break;
      case 51: return line51; break;
      case 52: return line52; break;
      case 53: return line53; break;
      case 54: return line54; break;
      case 55: return line55; break;
      case 56: return line56; break;
      case 57: return line57; break;
      case 58: return line58; break;
      case 59: return line59; break;
      case 60: return line60; break;
      case 61: return line61; break;
      case 62: return line62; break;
      case 63: return line63; break;
      default:
        throw new Exception('index >= 0 and index < 64');
    }
  }
  void setLine(int index, Pointer<gpiod_line> line){
    switch(index){
      case 0: line0 = line; break;
      case 1: line1 = line; break;
      case 2: line2 = line; break;
      case 3: line3 = line; break;
      case 4: line4 = line; break;
      case 5: line5 = line; break;
      case 6: line6 = line; break;
      case 7: line7 = line; break;
      case 8: line8 = line; break;
      case 9: line9 = line; break;
      case 10: line10 = line; break;
      case 11: line11 = line; break;
      case 12: line12 = line; break;
      case 13: line13 = line; break;
      case 14: line14 = line; break;
      case 15: line15 = line; break;
      case 16: line16 = line; break;
      case 17: line17 = line; break;
      case 18: line18 = line; break;
      case 19: line19 = line; break;
      case 20: line20 = line; break;
      case 21: line21 = line; break;
      case 22: line22 = line; break;
      case 23: line23 = line; break;
      case 24: line24 = line; break;
      case 25: line25 = line; break;
      case 26: line26 = line; break;
      case 27: line27 = line; break;
      case 28: line28 = line; break;
      case 29: line29 = line; break;
      case 30: line30 = line; break;
      case 31: line31 = line; break;
      case 32: line32 = line; break;
      case 33: line33 = line; break;
      case 34: line34 = line; break;
      case 35: line35 = line; break;
      case 36: line36 = line; break;
      case 37: line37 = line; break;
      case 38: line38 = line; break;
      case 39: line39 = line; break;
      case 40: line40 = line; break;
      case 41: line41 = line; break;
      case 42: line42 = line; break;
      case 43: line43 = line; break;
      case 44: line44 = line; break;
      case 45: line45 = line; break;
      case 46: line46 = line; break;
      case 47: line47 = line; break;
      case 48: line48 = line; break;
      case 49: line49 = line; break;
      case 50: line50 = line; break;
      case 51: line51 = line; break;
      case 52: line52 = line; break;
      case 53: line53 = line; break;
      case 54: line54 = line; break;
      case 55: line55 = line; break;
      case 56: line56 = line; break;
      case 57: line57 = line; break;
      case 58: line58 = line; break;
      case 59: line59 = line; break;
      case 60: line60 = line; break;
      case 61: line61 = line; break;
      case 62: line62 = line; break;
      case 63: line63 = line; break;
      default:
        throw new Exception('index >= 0 and index < 64');
    }

  }


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
  factory gpiod_line_event.allocate() =>
      allocate<gpiod_line_event>().ref..tv_sec = 0..tv_nsec=0..event_type=0;
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


