import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'signatures.dart';
import 'types.dart';

class GPIOD{
  final String libraryName = 'libgpiod.so';
  DynamicLibrary _dynamicLibrary;

  // chip iteration
  Pointer<gpiod_chip_iter> Function() chip_iter_new;
  void Function(Pointer<gpiod_chip_iter>) chip_iter_free_noclose;
  Pointer<gpiod_chip> Function(Pointer<gpiod_chip_iter>) chip_iter_next_noclose;

  // GPIO lines
  ///unsigned int (*line_offset)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_offset;
  ///const char *(*line_name)(struct gpiod_line *line);
  Pointer<Utf8> Function(Pointer<gpiod_line> line) line_name;
  ///const char *(*line_consumer)(struct gpiod_line *line);
  Pointer<Utf8> Function(Pointer<gpiod_line> line) line_consumer;
  ///int (*line_direction)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_direction;
  ///int (*line_active_state)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_active_state;
  ///int (*line_bias)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_bias;
  //FIXME: FFI does'n support bool??? https://github.com/dart-lang/sdk/issues/36855
  ///bool (*line_is_used)(struct gpiod_line *line);
  int/*bool*/ Function(Pointer<gpiod_line> line) line_is_used;
  ///bool (*line_is_open_drain)(struct gpiod_line *line);
  int/*bool*/ Function(Pointer<gpiod_line> line) line_is_open_drain;
  ///bool (*line_is_open_source)(struct gpiod_line *line);
  int/*bool*/ Function(Pointer<gpiod_line> line) line_is_open_source;
  ///int (*line_update)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_update;
  ///int (*line_request)(struct gpiod_line *line, const struct gpiod_line_request_config *config, int default_val);
  int Function(Pointer<gpiod_line> line, Pointer<gpiod_line_request_config> config, int default_val) line_request;
  ///int (*line_release)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_release;
  ///bool (*line_is_requested)(struct gpiod_line *line);
  int/*bool*/ Function(Pointer<gpiod_line> line) line_is_requested;
  ///bool (*line_is_free)(struct gpiod_line *line);
  int/*bool*/ Function(Pointer<gpiod_line> line) line_is_free;
  ///int (*line_get_value)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_get_value;
  ///int (*line_set_value)(struct gpiod_line *line, int value);
  int Function(Pointer<gpiod_line> line, int value) line_set_value;
  ///int (*line_set_config)(struct gpiod_line *line, int direction, int flags, int value);
  int Function(Pointer<gpiod_line> line, int direction, int flags, int value) line_set_config;
  ///int (*line_event_wait_bulk)(struct gpiod_line_bulk *bulk, const struct timespec *timeout, struct gpiod_line_bulk *event_bulk);
  int Function(Pointer<gpiod_line_bulk> bulk, Pointer<timespec> timeout, Pointer<gpiod_line_bulk> event_bulk) line_event_wait_bulk;
  ///int (*line_event_read)(struct gpiod_line *line, struct gpiod_line_event *event);
  int Function(Pointer<gpiod_line> line, Pointer<gpiod_line_event> event) line_event_read;
  ///int (*line_event_get_fd)(struct gpiod_line *line);
  int Function(Pointer<gpiod_line> line) line_event_get_fd;
  ///struct gpiod_chip *(*line_get_chip)(struct gpiod_line *line);
  Pointer<gpiod_chip> Function(Pointer<gpiod_line> line) line_get_chip;

  // GPIO chips
  ///void (*chip_close)(struct gpiod_chip *chip);
  void Function(Pointer<gpiod_chip>chip) chip_close;
  ///const char *(*chip_name)(struct gpiod_chip *chip);
  Pointer<Utf8> Function(Pointer<gpiod_chip> chip) chip_name;
  ///const char *(*chip_label)(struct gpiod_chip *chip);
  Pointer<Utf8> Function(Pointer<gpiod_chip> chip) chip_label;
  ///unsigned int (*chip_num_lines)(struct gpiod_chip *chip);
  int Function(Pointer<gpiod_chip> chip) chip_num_lines;

  // line iteration
  ///struct gpiod_line_iter *(*line_iter_new)(struct gpiod_chip *chip);
  Pointer<gpiod_line_iter> Function(Pointer<gpiod_chip>chip) line_iter_new;
  ///void (*line_iter_free)(struct gpiod_line_iter *iter);
  void Function(Pointer<gpiod_line_iter> iter) line_iter_free;
  ///struct gpiod_line *(*line_iter_next)(struct gpiod_line_iter *iter);
  Pointer<gpiod_line> Function(Pointer<gpiod_line_iter> iter) line_iter_next;

  // misc
  ///const char *(*version_string)(void);
  Pointer<Utf8> Function() version_string;

  static GPIOD _instance;
  factory GPIOD(){
    if (_instance ==null ){
      _instance = new GPIOD._internal();
    }
    return _instance;
  }
  GPIOD._internal(){
    _dynamicLibrary = DynamicLibrary.open(libraryName);

    chip_close = _dynamicLibrary.lookup<NativeFunction<chip_close_native_t>>("gpiod_chip_close").asFunction();
    chip_name = _dynamicLibrary.lookup<NativeFunction<chip_name_native_t>>("gpiod_chip_name").asFunction();
    chip_label = _dynamicLibrary.lookup<NativeFunction<chip_label_native_t>>("gpiod_chip_label").asFunction();
    chip_num_lines = _dynamicLibrary.lookup<NativeFunction<chip_num_lines_native_t>>("gpiod_chip_num_lines").asFunction();

    chip_iter_new = _dynamicLibrary.lookup<NativeFunction<chip_iter_new_native_t>>("gpiod_chip_iter_new").asFunction();
    chip_iter_free_noclose = _dynamicLibrary.lookup<NativeFunction<chip_iter_free_noclose_native_t>>('gpiod_chip_iter_free_noclose').asFunction();
    chip_iter_next_noclose = _dynamicLibrary.lookup<NativeFunction<chip_iter_next_noclose_native_t>>('gpiod_chip_iter_next_noclose').asFunction();

    line_offset = _dynamicLibrary.lookup<NativeFunction<line_offset_native_t>>("gpiod_line_offset").asFunction();
    line_name = _dynamicLibrary.lookup<NativeFunction<line_name_native_t>>("gpiod_line_name").asFunction();
    line_consumer = _dynamicLibrary.lookup<NativeFunction<line_consumer_native_t>>("gpiod_line_consumer").asFunction();
    line_direction = _dynamicLibrary.lookup<NativeFunction<line_direction_native_t>>("gpiod_line_direction").asFunction();
    line_active_state = _dynamicLibrary.lookup<NativeFunction<line_active_state_native_t>>("gpiod_line_active_state").asFunction();
    try {
      line_bias = _dynamicLibrary.lookup<NativeFunction<line_bias_native_t>>("gpiod_line_bias").asFunction();
    } catch (e, st){
      print('gpiod: bias is not supported, not found "gpiod_line_bias"');
    }
    line_is_used = _dynamicLibrary.lookup<NativeFunction<line_is_used_native_t>>("gpiod_line_is_used").asFunction();
    line_is_open_drain = _dynamicLibrary.lookup<NativeFunction<line_is_open_drain_native_t>>("gpiod_line_is_open_drain").asFunction();
    line_is_open_source = _dynamicLibrary.lookup<NativeFunction<line_is_open_source_native_t>>("gpiod_line_is_open_source").asFunction();
    line_update = _dynamicLibrary.lookup<NativeFunction<line_update_native_t>>("gpiod_line_update").asFunction();
    line_request = _dynamicLibrary.lookup<NativeFunction<line_request_native_t>>("gpiod_line_request").asFunction();
    line_release = _dynamicLibrary.lookup<NativeFunction<line_release_native_t>>("gpiod_line_release").asFunction();
    line_is_requested = _dynamicLibrary.lookup<NativeFunction<line_is_requested_native_t>>("gpiod_line_is_requested").asFunction();
    line_is_free = _dynamicLibrary.lookup<NativeFunction<line_is_free_native_t>>("gpiod_line_is_free").asFunction();
    line_get_value = _dynamicLibrary.lookup<NativeFunction<line_get_value_native_t>>("gpiod_line_get_value").asFunction();
    line_set_value = _dynamicLibrary.lookup<NativeFunction<line_set_value_native_t>>("gpiod_line_set_value").asFunction();
    try {
      line_set_config =
          _dynamicLibrary.lookup<NativeFunction<line_set_config_native_t>>("gpiod_line_set_config").asFunction();
    } catch (e, st){
      print('gpiod: not found "gpiod_line_set_config"');
    }
    line_event_wait_bulk = _dynamicLibrary.lookup<NativeFunction<line_event_wait_bulk_native_t>>("gpiod_line_event_wait_bulk").asFunction();
    line_event_read = _dynamicLibrary.lookup<NativeFunction<line_event_read_native_t>>("gpiod_line_event_read").asFunction();
    line_event_get_fd = _dynamicLibrary.lookup<NativeFunction<line_event_get_fd_native_t>>("gpiod_line_event_get_fd").asFunction();
    line_get_chip = _dynamicLibrary.lookup<NativeFunction<line_get_chip_native_t>>("gpiod_line_get_chip").asFunction();


    // line iteration
    line_iter_new = _dynamicLibrary.lookup<NativeFunction<line_iter_new_native_t>>("gpiod_line_iter_new").asFunction();
    line_iter_free = _dynamicLibrary.lookup<NativeFunction<line_iter_free_native_t>>("gpiod_line_iter_free").asFunction();
    line_iter_next = _dynamicLibrary.lookup<NativeFunction<line_iter_next_native_t>>("gpiod_line_iter_next").asFunction();

    // misc
    version_string = _dynamicLibrary.lookup<NativeFunction<version_string_native_t>>("gpiod_version_string").asFunction();
  }
}