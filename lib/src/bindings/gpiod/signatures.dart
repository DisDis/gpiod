import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'types.dart';

// GPIO chips
///void (*chip_close)(struct gpiod_chip *chip);
typedef chip_close_native_t = Void Function(Pointer<gpiod_chip> chip);

///const char *(*chip_name)(struct gpiod_chip *chip);
typedef chip_name_native_t = Pointer<Utf8> Function(Pointer<gpiod_chip> chip);

///const char *(*chip_label)(struct gpiod_chip *chip);
typedef chip_label_native_t = Pointer<Utf8> Function(Pointer<gpiod_chip> chip);

///unsigned int (*chip_num_lines)(struct gpiod_chip *chip);
typedef chip_num_lines_native_t = Uint32 Function(Pointer<gpiod_chip> chip);

// GPIO lines
///unsigned int (*line_offset)(struct gpiod_line *line);
typedef line_offset_native_t = Uint32 Function(Pointer<gpiod_line> line);

///const char *(*line_name)(struct gpiod_line *line);
typedef line_name_native_t = Pointer<Utf8> Function(Pointer<gpiod_line> line);

///const char *(*line_consumer)(struct gpiod_line *line);
typedef line_consumer_native_t = Pointer<Utf8> Function(Pointer<gpiod_line> line);

///int (*line_direction)(struct gpiod_line *line);
typedef line_direction_native_t = Int32 Function(Pointer<gpiod_line> line);

///int (*line_active_state)(struct gpiod_line *line);
typedef line_active_state_native_t = Int32 Function(Pointer<gpiod_line> line);

///int (*line_bias)(struct gpiod_line *line);
typedef line_bias_native_t = Int32 Function(Pointer<gpiod_line> line);

///bool (*line_is_used)(struct gpiod_line *line);
typedef line_is_used_native_t = Uint8 /*bool*/ Function(Pointer<gpiod_line> line);

///bool (*line_is_open_drain)(struct gpiod_line *line);
typedef line_is_open_drain_native_t = Uint8 /*bool*/ Function(Pointer<gpiod_line> line);

///bool (*line_is_open_source)(struct gpiod_line *line);
typedef line_is_open_source_native_t = Uint8 /*bool*/ Function(Pointer<gpiod_line> line);

///int (*line_update)(struct gpiod_line *line);
typedef line_update_native_t = Int32 Function(Pointer<gpiod_line> line);

///int (*line_request)(struct gpiod_line *line, const struct gpiod_line_request_config *config, int default_val);
typedef line_request_native_t = Int32 Function(
    Pointer<gpiod_line> line, Pointer<gpiod_line_request_config> config, Int32 default_val);

///int (*line_release)(struct gpiod_line *line);
typedef line_release_native_t = Int32 Function(Pointer<gpiod_line> line);

///bool (*line_is_requested)(struct gpiod_line *line);
typedef line_is_requested_native_t = Uint8 /*bool*/ Function(Pointer<gpiod_line> line);

///bool (*line_is_free)(struct gpiod_line *line);
typedef line_is_free_native_t = Uint8 /*bool*/ Function(Pointer<gpiod_line> line);

///int (*line_get_value)(struct gpiod_line *line);
typedef line_get_value_native_t = Int32 Function(Pointer<gpiod_line> line);

///int (*line_set_value)(struct gpiod_line *line, int value);
typedef line_set_value_native_t = Int32 Function(Pointer<gpiod_line> line, Int32 value);

///int (*line_set_config)(struct gpiod_line *line, int direction, int flags, int value);
typedef line_set_config_native_t = Int32 Function(Pointer<gpiod_line> line, Int32 direction, Int32 flags, Int32 value);

///int (*line_event_wait_bulk)(struct gpiod_line_bulk *bulk, const struct timespec *timeout, struct gpiod_line_bulk *event_bulk);
typedef line_event_wait_bulk_native_t = Int32 Function(
    Pointer<gpiod_line_bulk> bulk, Pointer<timespec> timeout, Pointer<gpiod_line_bulk> event_bulk);

///int (*line_event_read)(struct gpiod_line *line, struct gpiod_line_event *event);
typedef line_event_read_native_t = Int32 Function(Pointer<gpiod_line> line, Pointer<gpiod_line_event> event);

///int (*line_event_get_fd)(struct gpiod_line *line);
typedef line_event_get_fd_native_t = Int32 Function(Pointer<gpiod_line> line);

///struct gpiod_chip *(*line_get_chip)(struct gpiod_line *line);
typedef line_get_chip_native_t = Pointer<gpiod_chip> Function(Pointer<gpiod_line> line);

// chip iteration
/// struct gpiod_chip_iter *(*chip_iter_new)(void);
typedef chip_iter_new_native_t = Pointer<void> Function();

/// void (*chip_iter_free_noclose)(struct gpiod_chip_iter *iter);
typedef chip_iter_free_noclose_native_t = Void Function(Pointer<gpiod_chip_iter>);

/// struct gpiod_chip *(*chip_iter_next_noclose)(struct gpiod_chip_iter *iter);
typedef chip_iter_next_noclose_native_t = Pointer<gpiod_chip> Function(Pointer<gpiod_chip_iter>);

// line iteration
///struct gpiod_line_iter *(*line_iter_new)(struct gpiod_chip *chip);
typedef line_iter_new_native_t = Pointer<gpiod_line_iter> Function(Pointer<gpiod_chip> chip);

///void (*line_iter_free)(struct gpiod_line_iter *iter);
typedef line_iter_free_native_t = Void Function(Pointer<gpiod_line_iter> iter);

///struct gpiod_line *(*line_iter_next)(struct gpiod_line_iter *iter);
typedef line_iter_next_native_t = Pointer<gpiod_line> Function(Pointer<gpiod_line_iter> iter);

// misc
///const char *(*version_string)(void);
typedef version_string_native_t = Pointer<Utf8> Function();
