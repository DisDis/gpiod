import 'dart:convert';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:gpiod/gpiod.dart';
import 'package:gpiod/pthread.dart';
import 'package:gpiod/src/utils.dart';
import 'package:logging/logging.dart';

final Logger _log = new Logger('main');

var gpiod = GPIOD();
var pthread = Pthread();

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    StringBuffer message = new StringBuffer();
    message.write('${rec.level.name}:${rec.loggerName} ${rec.time}: ${rec.message}');
    if (rec.error != null) {
      message.write(' ${rec.error}');
    }
    print(message);
  });

  try {


    _log.info('GPIOD version: ${Utf8.fromUtf8(gpiod.version_string())}');

    // iterate through the GPIO chips
    var chipiter = gpiod.chip_iter_new();
    if (chipiter.address == 0) {
      _log.severe("[gpiod] could not create GPIO chip iterator. gpiod_chip_iter_new");
      return;//errno;
    }

    Map<String,Pointer<gpiod_chip>> chips = <String,Pointer<gpiod_chip>>{};
    _log.info('get chips');
    for (var n_chips = 0, n_lines = 0, chip =  gpiod.chip_iter_next_noclose(chipiter);     chip.address != 0;
    n_chips++, chip = gpiod.chip_iter_next_noclose(chipiter))
    {
      _log.info('${n_chips} ${chip.ref.name} ${chip.ref.label}');
      _log.info('chip.ref.num_lines ${chip.ref.num_lines}');
      chips[chip.ref.label] = chip;
    }
    gpiod.chip_iter_free_noclose(chipiter);

    gpiodp_ensure_gpiod_initialized();

//    var chip = chips['pinctrl-bcm2835'];
//    var line14 = chip.ref.lines[14];
//    line14.ref.
    /// Request BCM 14 as output.
    gpiodp_request_line(
      14,
      consumer: 'LED',
        initialValue: true,
      direction: LineDirection.output,
        outputMode :OutputMode.pushPull,
        activeState : ActiveState.high
    );

  } catch(e, st){
    _log.severe("Error",e, st);
  }
}

