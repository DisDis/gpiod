import 'dart:convert';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:gpiod/gpiod.dart';
import 'package:logging/logging.dart';

final Logger _log = new Logger('main');

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
    var gpiod = GPIOD();

    _log.info('GPIOD version: ${Utf8.fromUtf8(gpiod.version_string())}');

    // iterate through the GPIO chips
    var chipiter = gpiod.chip_iter_new();
    if (chipiter.address == 0) {
      _log.severe("[gpiod] could not create GPIO chip iterator. gpiod_chip_iter_new");
      return;//errno;
    }

    _log.info('get chips');
    for (var n_chips = 0, n_lines = 0, chip =  gpiod.chip_iter_next_noclose(chipiter);     chip.address != 0;
    n_chips++, chip = gpiod.chip_iter_next_noclose(chipiter))
    {
      _log.info('${n_chips} ${utf8.decode(chip.ref.name)} ${utf8.decode(chip.ref.label)}');
      _log.info('chip.ref.num_lines ${chip.ref.num_lines}');
    }
    gpiod.chip_iter_free_noclose(chipiter);

  } catch(e, st){
    _log.severe("Error",e, st);
  }

}
