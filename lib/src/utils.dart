
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:gpiod/gpiod.dart';
import 'package:gpiod/pthread.dart';
import 'package:logging/logging.dart';

final gpio_plugin = new GPIO_plugin();
var gpiod = GPIOD();
var pthread = Pthread();

final Logger _log = new Logger('gpiod');

// https://github.com/ardera/flutter-pi/blob/master/src/plugins/gpiod.c
class GPIO_plugin {
  bool initialized = false;
  bool line_event_listener_should_run = false;

  List<Pointer<gpiod_chip>> chips = <Pointer<gpiod_chip>>[];
  int n_chips = 0;

  // complete list of GPIO lines
  List<Pointer<gpiod_line>> lines = <Pointer<gpiod_line>>[];
  int n_lines = 0;

  // GPIO lines that flutter is currently listening to
  int epollfd;
  pthread_mutex_t listening_lines_mutex = new pthread_mutex_t.allocate();
  gpiod_line_bulk listening_lines = new gpiod_line_bulk.allocate();
  pthread_t line_event_listener_thread = new pthread_t.allocate();
  bool should_emit_events = false;
}

class _LineConfig {
  Pointer<gpiod_line> line;
  LineDirection direction;
  LineRequestType request_type;
  int initial_value;
  int flags;
}

bool gpiodp_ensure_gpiod_initialized(){

  if (gpio_plugin.initialized) return true;
  // iterate through the GPIO chips
  var chipiter = gpiod.chip_iter_new();
  if (chipiter.address == 0) {
    _log.severe("[flutter_gpiod] could not create GPIO chip iterator. gpiod_chip_iter_new");
    return false;
  }

  gpio_plugin.n_chips = 0;
  gpio_plugin.n_lines = 0;
  for (var chip = gpiod.chip_iter_next_noclose(chipiter); chip.address != 0;
  gpio_plugin.n_chips++, chip = gpiod.chip_iter_next_noclose(chipiter))
  {
    gpio_plugin.chips.add(chip);//[gpio_plugin.n_chips] = chip;
    gpio_plugin.n_lines += gpiod.chip_num_lines(chip);
  }
  gpiod.chip_iter_free_noclose(chipiter);

  // prepare the GPIO line list
  //gpio_plugin.lines = calloc(gpio_plugin.n_lines, sizeof(struct gpiod_line*));
//  if (gpio_plugin.lines.isEmpty) {
//    _log.severe("could not allocate memory for GPIO line list");
//    return;
//  }

  // iterate through the chips and put all lines into the list
  for (var i = 0, j = 0; i < gpio_plugin.n_chips; i++) {
    var lineiter = gpiod.line_iter_new(gpio_plugin.chips[i]);
    if (lineiter.address == 0) {
      _log.severe("could not create new GPIO line iterator");
      return false;
    }

    for (var line = gpiod.line_iter_next(lineiter); line.address != 0; line = gpiod.line_iter_next(lineiter), j++) {
      gpio_plugin.lines.add(line);//[j] = line;
      _log.info('${j}: name: "${line.ref.name}", consumer: "${line.ref.consumer}" state: ${line.ref.state}');
    }

    gpiod.line_iter_free(lineiter);
  }


  /*fd = epoll_create1(0);
  if (fd == -1) {
    perror("[flutter_gpiod] Could not create line event listen epoll");
    return errno;
  }

  gpio_plugin.epollfd = fd;
  gpio_plugin.listening_lines = (struct gpiod_line_bulk) GPIOD_LINE_BULK_INITIALIZER;
  gpio_plugin.listening_lines_mutex = (pthread_mutex_t) PTHREAD_MUTEX_INITIALIZER;
  gpio_plugin.line_event_listener_should_run = true;

  ok = pthread_create(
  &gpio_plugin.line_event_listener_thread,
  NULL,
  gpiodp_io_loop,
  NULL
  );
  if (ok == -1) {
    perror("[flutter_gpiod] could not create line event listener thread");
    return errno;
  }*/

  gpio_plugin.initialized = true;
  return true;
}



_LineConfig gpiodp_get_config({Bias bias, int line_handle = 0,
  LineDirection direction = LineDirection.input,
  OutputMode outputMode, bool initialValue,
  ActiveState activeState}
    /*struct std_value *value,
                      struct line_config *conf_out,
                      FlutterPlatformMessageResponseHandle *responsehandle*/) {
//    struct std_value *temp;
//    unsigned int line_handle;
//    bool has_bias;
//    int ok;

  var conf_out = new _LineConfig();

  conf_out.direction = null;
  conf_out.request_type = null;
  conf_out.flags = 0;

//    if ((!value) || (value->type != kStdMap)) {
//        ok = platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg` to be a `Map<String, dynamic>`"
//        );
//        if (ok != 0) return ok;
//
//        return EINVAL;
//    }

  // get the line handle from the argument map
//    temp = stdmap_get_str(value, "lineHandle");
//    if (temp && STDVALUE_IS_INT(*temp)) {
//        line_handle = STDVALUE_AS_INT(*temp);
//    } else {
//        ok = platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg['lineHandle']` to be an integer."
//        );
//        if (ok != 0) return ok;
//
//        return EINVAL;
//    }

  // get the corresponding gpiod line
//    if (line_handle < gpio_plugin.n_lines) {
  conf_out.line = gpio_plugin.lines[line_handle];
//    } else {
//        ok = gpiodp_respond_illegal_line_handle(responsehandle);
//        if (ok != 0) return ok;
//
//        return EINVAL;
//    }

  // get the direction
//    temp = stdmap_get_str(value, "direction");
//    if (temp && (temp->type == kStdString)) {
  if (direction == LineDirection.input) {
    conf_out.direction = direction;
    conf_out.request_type = LineRequestType.GPIOD_LINE_REQUEST_DIRECTION_INPUT;
  } else if (direction == LineDirection.output){
    conf_out.direction = direction;
    conf_out.request_type = LineRequestType.GPIOD_LINE_REQUEST_DIRECTION_OUTPUT;
  }
//        else {
//            goto invalid_direction;
//        }
//    } else {
//        invalid_direction:
//
//        ok = platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg['direction']` to be a string-ification of `LineDirection`."
//        );
//        if (ok != 0) return ok;
//
//        return EINVAL;
//    }

  // get the output mode
//    temp = stdmap_get_str(value, "outputMode");
  if (outputMode == null) {
    if (conf_out.direction == /*GPIOD_LINE_DIRECTION_OUTPUT*/ LineDirection.output) {
      //goto invalid_output_mode;
      throw new Exception('invalid_output_mode');
    }
  } else /*if (temp && temp->type == kStdString)*/ {
    if (conf_out.direction == LineDirection.input /*GPIOD_LINE_DIRECTION_INPUT*/) {
//            goto invalid_output_mode;
      throw new Exception('invalid_output_mode');
    }

    if (outputMode == OutputMode.pushPull) /*STREQ("OutputMode.pushPull", temp->string_value) */{
      // do nothing
    } else if (outputMode == OutputMode.openDrain)/*if STREQ("OutputMode.openDrain", temp->string_value)*/ {
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_OPEN_DRAIN.value;
    } else if (outputMode == OutputMode.openSource)/*if STREQ("OutputMode.openSource", temp->string_value)*/ {
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_OPEN_SOURCE.value;
    } else {
      //goto invalid_output_mode;
      throw new Exception('invalid_output_mode');
    }
  } /*else {
        invalid_output_mode:

        ok = platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg['outputMode']` to be a string-ification "
            "of [OutputMode] when direction is output, "
            "null when direction is input."
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

  // get the bias
  var has_bias = false;
//    temp = stdmap_get_str(value, "bias");
  if (bias == null)/*((!temp) || STDVALUE_IS_NULL(*temp))*/ {
    // don't need to set any flags
  } else
    /*if (temp && temp->type == kStdString) */{
    if (bias == Bias.disable)/*STREQ("Bias.disable", temp->string_value)*/ {
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_BIAS_DISABLE.value;
      has_bias = true;
    } else if (bias == Bias.pullUp)/*STREQ("Bias.pullUp", temp->string_value) */{
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP.value;
      has_bias = true;
    } else if (bias == Bias.pullDown)/*STREQ("Bias.pullDown", temp->string_value) */{
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_DOWN.value;
      has_bias = true;
    } else {
      throw new Exception('invalid_bias');
//            goto invalid_bias;
    }
  }/* else {
        invalid_bias:

        ok = platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg['bias']` to be a stringification of [Bias] or null."
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

  if (has_bias && gpiod.line_bias==null) {
    throw new Exception('Setting line bias is not supported on this platform.');
    // ok = gpiodp_respond_not_supported(
    /*      responsehandle,
            "Setting line bias is not supported on this platform. "
            "Expected `arg['bias']` to be null."
        );

        if (ok != 0) return ok;
        return ENOTSUP;*/
  }

  // get the initial value
  conf_out.initial_value = 0;
//    temp = stdmap_get_str(value, "initialValue");
  if (initialValue == null/*(!temp) || STDVALUE_IS_NULL(*temp)*/) {
    if (conf_out.direction == LineDirection.input /*GPIOD_LINE_DIRECTION_INPUT*/) {
      // do nothing.
    } else if (conf_out.direction == LineDirection.output /*GPIOD_LINE_DIRECTION_OUTPUT*/) {
      //goto invalid_initial_value;
      throw new Exception('invalid_initial_value');
    }
  } else /*if (temp && STDVALUE_IS_BOOL(*temp))*/ {
    if (conf_out.direction == LineDirection.input) {
      throw new Exception('invalid_initial_value');//goto invalid_initial_value;
    } else if (conf_out.direction == LineDirection.output) {
      conf_out.initial_value = initialValue ? 1 : 0;
    }
  } /*else {
        invalid_initial_value:

        ok = platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg['initialValue']` to be null if direction is input, "
            "a bool if direction is output."
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

  // get the active state
//    temp = stdmap_get_str(value, "activeState");
  if (activeState != null) {
    if (activeState == ActiveState.low) /*STREQ("ActiveState.low", temp->string_value)*/ {
      conf_out.flags |= LineRequestFlag.GPIOD_LINE_REQUEST_FLAG_ACTIVE_LOW.value;
    } else if (activeState == ActiveState.high)/*STREQ("ActiveState.high", temp->string_value)*/ {
      // do nothing
    } else {
      throw new Exception('invalid_active_state');//goto invalid_active_state;
    }
  } else {
    throw new Exception('invalid_active_state');
//        invalid_active_state:
//
//        ok = platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg['activeState']` to be a stringification of [ActiveState]."
//        );
//        if (ok != 0) return ok;
//
//        return EINVAL;
  }

  return conf_out;
}

int gpiodp_request_line(
    int lineHandle,
    {    String consumer,
      LineDirection direction,
      OutputMode outputMode,
      Bias bias,
      ActiveState activeState,
      bool initialValue,
      Set<SignalEdge> triggers}) {
//    struct line_config config;
//    struct std_value *temp;
  bool is_event_line = false;
//    String consumer;

//    bool ok;
//    int fd;

  // check that the arg is a map
//    if (object->std_arg.type != kStdMap) {
//        return platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg` to be a `Map<String, dynamic>`"
//        );
//    }

  // ensure GPIO is initialized

  if (!gpiodp_ensure_gpiod_initialized()) {
    new Exception('gpiodp_respond_init_failed');
//        return gpiodp_respond_init_failed(responsehandle);
  }

//    temp = stdmap_get_str(&object->std_arg, "consumer");
//    if (!temp || STDVALUE_IS_NULL(*temp)) {
//        consumer = NULL;
//    } else if (temp && (temp->type == kStdString)) {
//        consumer = temp->string_value;
//    } else {
//        return platch_respond_illegal_arg_std(
//            responsehandle,
//            "Expected `arg['consumer']` to be a string or null."
//        );
//    }

  // get the line config
  var config = gpiodp_get_config(
    line_handle:lineHandle,direction:direction,
//        consumer:consumer,
    outputMode:outputMode,
    bias:bias,
    activeState:activeState,
    initialValue:initialValue,
//        triggers:triggers
  );
//    if (ok != 0) return ok;

  // get the triggers
//    temp = stdmap_get_str(&object->std_arg, "triggers");
  if (triggers == null/*(!temp) || STDVALUE_IS_NULL(*temp)*/) {
    if (config.direction == LineDirection.input /*GPIOD_LINE_DIRECTION_INPUT*/) {
//            goto invalid_triggers;
      throw new Exception('invalid_triggers');
    }
  } else /*if (temp && STDVALUE_IS_LIST(*temp))*/ {
    if (config.direction == LineDirection.output/*GPIOD_LINE_DIRECTION_OUTPUT*/) {
      throw new Exception('invalid_triggers');
    }

    // iterate through elements in the trigger list.
    triggers.forEach((trigger) { //for (int i = 0; i < triggers.length; i++) {
      // now update config.request_type accordingly.
      if (trigger == SignalEdge.falling) {
        is_event_line = true;
        switch (config.request_type) {
          case LineRequestType.GPIOD_LINE_REQUEST_DIRECTION_INPUT:
            config.request_type = LineRequestType.GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE;
            break;
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE:
            break;
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_RISING_EDGE:
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES:
            config.request_type = LineRequestType.GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES;
            break;
          default: break;
        }
      } else if (trigger == SignalEdge.rising) /*{if STREQ("SignalEdge.rising", temp->list[i].string_value)*/ {
        is_event_line = true;
        switch (config.request_type) {
          case LineRequestType.GPIOD_LINE_REQUEST_DIRECTION_INPUT:
            config.request_type = LineRequestType.GPIOD_LINE_REQUEST_EVENT_RISING_EDGE;
            break;
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_RISING_EDGE:
            break;
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE:
          case LineRequestType.GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES:
            config.request_type = LineRequestType.GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES;
            break;
          default: break;
        }
      } else {
        throw new Exception('invalid_triggers');
      }
    });
  };
  /*else {
        invalid_triggers:
        return platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg['triggers']` to be a `List<String>` of "
            "string-ifications of [SignalEdge] when direction is input "
            "(no null values in the list), null when direction is output."
        );
    }*/

  // finally request the line
  var ok = gpiod.line_request(
      config.line,
      new gpiod_line_request_config.allocate(Utf8.toUtf8(consumer), config.request_type.value, config.flags).addressOf/* &(struct gpiod_line_request_config) {
            .consumer = consumer,
            .request_type = config.request_type,
            .flags = config.flags
        }*/,
      config.initial_value
  );
  if (ok == -1) {
    throw new Exception('line_request');
//        return platch_respond_native_error_std(responsehandle, errno);
  }


  if (is_event_line) {
    pthread.mutex_lock(gpio_plugin.listening_lines_mutex.addressOf);
//
    var fd = gpiod.line_event_get_fd(config.line);
//        ok = epoll_ctl(gpio_plugin.epollfd,
//                       EPOLL_CTL_ADD,
//                       fd,
//                       &(struct epoll_event) {.events = EPOLLPRI | EPOLLIN, .data.fd = fd}
//        );
    if (ok == -1) {
      gpiod.line_release(config.line);
      throw new Exception('[flutter_gpiod] Could not add GPIO line to epollfd. epoll_ctl');
    }

    gpiod.line_bulk_add(gpio_plugin.listening_lines, config.line.ref);

    pthread.mutex_unlock(gpio_plugin.listening_lines_mutex.addressOf);
  }

//    return platch_respond_success_std(responsehandle, NULL);
}