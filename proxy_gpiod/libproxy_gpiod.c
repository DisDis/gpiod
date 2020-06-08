#include <errno.h>
#include <stdio.h>
#include <dlfcn.h>
#include <poll.h>
#include <pthread.h>
#include <sys/epoll.h>

#include <string.h>


#include "libproxy_gpiod.h"
#include </usr/lib/dart/include/dart_api.h>
#include "/usr/lib/dart/include/dart_native_api.h"
//#include <pluginregistry.h>
//#include <plugins/gpiod_plugin.h>

struct proxy_gpiod_chip_details_struct{
  char* name;
  char* label;
  int numLines;
};

struct proxy_gpiod_line_config_struct{
  unsigned int lineHandle;
  char*  consumer;
  unsigned int direction;
  unsigned int outputMode;
  unsigned int bias;
  unsigned int activeState;
  unsigned int triggers;
  unsigned int initialValue;
};

struct proxy_gpiod_line_details_struct{
  char* name;
  char* consumer;
  bool isUsed;
  bool isRequested;
  bool isFree;
  unsigned int direction;
  //int outputMode;
  unsigned int open_source;
  unsigned int open_drain;
  unsigned int bias;
  unsigned int activeState;
            /*},
            .values = (struct std_value[9]) {
                {.type = name? kStdString : kStdNull, .string_value = name},
                {.type = consumer? kStdString : kStdNull, .string_value = consumer},
                {.type = libgpiod.line_is_used(line) ? kStdTrue : kStdFalse},
                {.type = libgpiod.line_is_requested(line) ? kStdTrue : kStdFalse},
                {.type = libgpiod.line_is_free(line) ? kStdTrue : kStdFalse},
                {.type = kStdString, .string_value = direction_str},
                {
                    .type = output_mode_str? kStdString : kStdNull,
                    .string_value = output_mode_str
                },
                {
                    .type = bias_str? kStdString : kStdNull,
                    .string_value = bias_str
                },
                {.type = kStdString, .string_value = active_state_str}*/
};


struct {
    bool initialized;
    bool line_event_listener_should_run;

    struct gpiod_chip *chips[GPIO_PLUGIN_MAX_CHIPS];
    size_t n_chips;

    // complete list of GPIO lines
    struct gpiod_line **lines;
    size_t n_lines;

    // GPIO lines that flutter is currently listening to
    int epollfd;
    pthread_mutex_t listening_lines_mutex;
    struct gpiod_line_bulk listening_lines;
    pthread_t line_event_listener_thread;
    bool should_emit_events;
    Dart_Port send_port_;
} gpio_plugin;

struct {
    void *handle;

    // GPIO chips
    void (*chip_close)(struct gpiod_chip *chip);
    const char *(*chip_name)(struct gpiod_chip *chip);
    const char *(*chip_label)(struct gpiod_chip *chip);
    unsigned int (*chip_num_lines)(struct gpiod_chip *chip);

    // GPIO lines
    unsigned int (*line_offset)(struct gpiod_line *line);
    const char *(*line_name)(struct gpiod_line *line);
    const char *(*line_consumer)(struct gpiod_line *line);
    int (*line_direction)(struct gpiod_line *line);
    int (*line_active_state)(struct gpiod_line *line);
    int (*line_bias)(struct gpiod_line *line);
    bool (*line_is_used)(struct gpiod_line *line);
    bool (*line_is_open_drain)(struct gpiod_line *line);
    bool (*line_is_open_source)(struct gpiod_line *line);
    int (*line_update)(struct gpiod_line *line);
    int (*line_request)(struct gpiod_line *line, const struct gpiod_line_request_config *config, int default_val);
    int (*line_release)(struct gpiod_line *line);
    bool (*line_is_requested)(struct gpiod_line *line);
    bool (*line_is_free)(struct gpiod_line *line);
    int (*line_get_value)(struct gpiod_line *line);
    int (*line_set_value)(struct gpiod_line *line, int value);
    int (*line_set_config)(struct gpiod_line *line, int direction, int flags, int value);
    int (*line_event_wait_bulk)(struct gpiod_line_bulk *bulk, const struct timespec *timeout, struct gpiod_line_bulk *event_bulk);
    int (*line_event_read)(struct gpiod_line *line, struct gpiod_line_event *event);
    int (*line_event_get_fd)(struct gpiod_line *line);
    struct gpiod_chip *(*line_get_chip)(struct gpiod_line *line);

    // chip iteration
    struct gpiod_chip_iter *(*chip_iter_new)(void);
    void (*chip_iter_free_noclose)(struct gpiod_chip_iter *iter);
    struct gpiod_chip *(*chip_iter_next_noclose)(struct gpiod_chip_iter *iter);

    // line iteration
    struct gpiod_line_iter *(*line_iter_new)(struct gpiod_chip *chip);
    void (*line_iter_free)(struct gpiod_line_iter *iter);
    struct gpiod_line *(*line_iter_next)(struct gpiod_line_iter *iter);

    // misc
    const char *(*version_string)(void);
} libgpiod;

struct line_config {
    struct gpiod_line *line;
    int direction;
    int request_type;
    int initial_value;
    uint8_t flags;
};

struct error_data
{
    char* msg;
    int code;
};



DART_EXPORT void proxy_gpiod_register_send_port(Dart_Port send_port) {
  gpio_plugin.send_port_ = send_port;
  gpio_plugin.should_emit_events = true;
}


////////////////////////////////////////////////////////////////////////////////
// Dynamic linking of dart_native_api.h for the next two samples.
typedef bool (*Dart_PostCObjectType)(Dart_Port port_id, Dart_CObject* message);
Dart_PostCObjectType Dart_PostCObject_ = NULL;

DART_EXPORT void proxy_gpiod_register_dart_postcobject(
    Dart_PostCObjectType function_pointer) {
  Dart_PostCObject_ = function_pointer;
}

typedef Dart_Port (*Dart_NewNativePortType)(const char* name,
                                            Dart_NativeMessageHandler handler,
                                            bool handle_concurrently);
Dart_NewNativePortType Dart_NewNativePort_ = NULL;

DART_EXPORT void proxy_gpiod_register_dart_newnativeport(
    Dart_NewNativePortType function_pointer) {
  Dart_NewNativePort_ = function_pointer;
}

typedef bool (*Dart_CloseNativePortType)(Dart_Port native_port_id);
Dart_CloseNativePortType Dart_CloseNativePort_ = NULL;

DART_EXPORT void proxy_gpiod_register_dart_closenativeport(
    Dart_CloseNativePortType function_pointer) {
  Dart_CloseNativePort_ = function_pointer;
}



void print_hello() {
    printf("Hello, World!\n");
      const char* methodname = "signal";
      int value = 100;

      Dart_CObject c_value;
      c_value.type = Dart_CObject_kInt32;
      c_value.value.as_int32 = value;

      Dart_CObject c_method_name;
      c_method_name.type = Dart_CObject_kString;
      c_method_name.value.as_string = (char*)(methodname);

      Dart_CObject* c_request_arr[] = {&c_method_name, &c_value};
      Dart_CObject c_request;
      c_request.type = Dart_CObject_kArray;
      c_request.value.as_array.values = c_request_arr;
      c_request.value.as_array.length =
          sizeof(c_request_arr) / sizeof(c_request_arr[0]);

      Dart_PostCObject_(gpio_plugin.send_port_, &c_request);
}


// because libgpiod doesn't provide it, but it's useful
static inline void gpiod_line_bulk_remove(struct gpiod_line_bulk *bulk, struct gpiod_line *line) {
    struct gpiod_line *linetemp, **cursor;
    struct gpiod_line_bulk new_bulk = GPIOD_LINE_BULK_INITIALIZER;

    gpiod_line_bulk_foreach_line(bulk, linetemp, cursor) {
        if (linetemp != line)
            gpiod_line_bulk_add(&new_bulk, linetemp);
    }

    memcpy(bulk, &new_bulk, sizeof(struct gpiod_line_bulk));
}

static void *gpiodp_io_loop(void *userdata);

/// ensures the libgpiod binding and the `gpio_plugin` chips list and line map is initialized.
static int gpiodp_ensure_gpiod_initialized(void) {
    struct gpiod_chip_iter *chipiter;
    struct gpiod_line_iter *lineiter;
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int ok, i, j, fd;

    if (gpio_plugin.initialized) return 0;

    libgpiod.handle = dlopen("libgpiod.so", RTLD_LOCAL | RTLD_LAZY);
    if (!libgpiod.handle) {
        perror("[flutter_gpiod] could not load libgpiod.so. dlopen");
        return errno;
    }

    LOAD_GPIOD_PROC(chip_close);
    LOAD_GPIOD_PROC(chip_name);
    LOAD_GPIOD_PROC(chip_label);
    LOAD_GPIOD_PROC(chip_num_lines);

    LOAD_GPIOD_PROC(line_offset);
    LOAD_GPIOD_PROC(line_name);
    LOAD_GPIOD_PROC(line_consumer);
    LOAD_GPIOD_PROC(line_direction);
    LOAD_GPIOD_PROC(line_active_state);
    LOAD_GPIOD_PROC_OPTIONAL(line_bias);
    LOAD_GPIOD_PROC(line_is_used);
    LOAD_GPIOD_PROC(line_is_open_drain);
    LOAD_GPIOD_PROC(line_is_open_source);
    LOAD_GPIOD_PROC(line_update);
    LOAD_GPIOD_PROC(line_request);
    LOAD_GPIOD_PROC(line_release);
    LOAD_GPIOD_PROC(line_is_requested);
    LOAD_GPIOD_PROC(line_is_free);
    LOAD_GPIOD_PROC(line_get_value);
    LOAD_GPIOD_PROC(line_set_value);
    LOAD_GPIOD_PROC_OPTIONAL(line_set_config);
    LOAD_GPIOD_PROC(line_event_wait_bulk);
    LOAD_GPIOD_PROC(line_event_read);
    LOAD_GPIOD_PROC(line_event_get_fd);
    LOAD_GPIOD_PROC(line_get_chip);

    LOAD_GPIOD_PROC(chip_iter_new);
    LOAD_GPIOD_PROC(chip_iter_free_noclose);
    LOAD_GPIOD_PROC(chip_iter_next_noclose);

    LOAD_GPIOD_PROC(line_iter_new);
    LOAD_GPIOD_PROC(line_iter_free);
    LOAD_GPIOD_PROC(line_iter_next);

    LOAD_GPIOD_PROC(version_string);


    // iterate through the GPIO chips
    chipiter = libgpiod.chip_iter_new();
    if (!chipiter) {
        perror("[flutter_gpiod] could not create GPIO chip iterator. gpiod_chip_iter_new");
        return errno;
    }

    for (gpio_plugin.n_chips = 0, gpio_plugin.n_lines = 0, chip = libgpiod.chip_iter_next_noclose(chipiter);
        chip;
        gpio_plugin.n_chips++, chip = libgpiod.chip_iter_next_noclose(chipiter))
    {
        gpio_plugin.chips[gpio_plugin.n_chips] = chip;
        gpio_plugin.n_lines += libgpiod.chip_num_lines(chip);
    }
    libgpiod.chip_iter_free_noclose(chipiter);


    // prepare the GPIO line list
    gpio_plugin.lines = calloc(gpio_plugin.n_lines, sizeof(struct gpiod_line*));
    if (!gpio_plugin.lines) {
        perror("could not allocate memory for GPIO line list");
        return errno;
    }

    // iterate through the chips and put all lines into the list
    for (i = 0, j = 0; i < gpio_plugin.n_chips; i++) {
        lineiter = libgpiod.line_iter_new(gpio_plugin.chips[i]);
        if (!lineiter) {
            perror("could not create new GPIO line iterator");
            return errno;
        }

        for (line = libgpiod.line_iter_next(lineiter); line; line = libgpiod.line_iter_next(lineiter), j++)
            gpio_plugin.lines[j] = line;

        libgpiod.line_iter_free(lineiter);
    }

    fd = epoll_create1(0);
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
    }

    gpio_plugin.initialized = true;
    return 0;
}

/// Sends a platform message to `handle` saying that the libgpiod binding has failed to initialize.
/// Should be called when `gpiodp_ensure_gpiod_initialized()` has failed.
static int gpiodp_respond_init_failed(struct error_data* error_data) {
    error_data->msg = "proxy_gpiod failed to initialize libgpiod bindings. See flutter-pi log for details.";
    return -1;
}

/// Sends a platform message to `handle` with error code "illegalargument"
/// and error messsage "supplied line handle is not valid".
static int gpiodp_respond_illegal_line_handle(struct error_data* error_data) {
    error_data->msg = "supplied line handle is not valid";
    return -1;
}

static int gpiodp_respond_not_supported(char *msg, struct error_data* error_data) {
    error_data->msg = msg;
    return -1;
}

static int platch_respond_native_error_std( int error, struct error_data* error_data ){
  error_data->code = error;
  return -1;
}
static int platch_respond_illegal_arg_std( char* errorStr, struct error_data* error_data ){
  error_data->msg = errorStr;
  return -1;
}


static int gpiodp_get_config(struct proxy_gpiod_line_config_struct *value,
                      struct line_config *conf_out, struct error_data* error_data) {
    //struct std_value *temp;
    bool has_bias;
    int ok;

    conf_out->direction = 0;
    conf_out->request_type = 0;
    conf_out->flags = 0;

    /*if ((!value) || (value->type != kStdMap)) {
        ok = platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg` to be a `Map<String, dynamic>`"
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

    // get the line handle from the argument map
    /*temp = stdmap_get_str(value, "lineHandle");
    if (temp && STDVALUE_IS_INT(*temp)) {
        line_handle = STDVALUE_AS_INT(*temp);
    } else {
        ok = platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg['lineHandle']` to be an integer."
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

    // get the corresponding gpiod line
    if (value->lineHandle < gpio_plugin.n_lines) {
        conf_out->line = gpio_plugin.lines[value->lineHandle];
    } else {
        ok = gpiodp_respond_illegal_line_handle(error_data);
        if (ok != 0) return ok;

        return EINVAL;
    }

    // get the direction
    //temp = stdmap_get_str(value, "direction");
    if (value->direction) {
        if (value->direction == GPIOD_LINE_DIRECTION_INPUT) {
            conf_out->direction = GPIOD_LINE_DIRECTION_INPUT;
            conf_out->request_type = GPIOD_LINE_REQUEST_DIRECTION_INPUT;
        } else if (value->direction == GPIOD_LINE_DIRECTION_OUTPUT) {
            conf_out->direction = GPIOD_LINE_DIRECTION_OUTPUT;
            conf_out->request_type = GPIOD_LINE_REQUEST_DIRECTION_OUTPUT;
        } else {
            goto invalid_direction;
        }
    } else {
        invalid_direction:

        ok = platch_respond_illegal_arg_std(
            "Expected `arg['direction']` to be a string-ification of `LineDirection`."
        , error_data);
        if (ok != 0) return ok;

        return EINVAL;
    }

    // get the output mode
    //temp = stdmap_get_str(value, "outputMode");
    if (!(value->outputMode) /*(!temp) || STDVALUE_IS_NULL(*temp)*/) {
        if (conf_out->direction == GPIOD_LINE_DIRECTION_OUTPUT) {
            goto invalid_output_mode;
        }
    } else {
        if (conf_out->direction == GPIOD_LINE_DIRECTION_INPUT) {
            goto invalid_output_mode;
        }
        if (value->outputMode == GPIOD_LINE_OUPUT_MODE_PUSHPULL) {
            // do nothing
        } else if (value->outputMode == GPIOD_LINE_OUPUT_MODE_OPENDRAIN) {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_OPEN_DRAIN;
        } else if (value->outputMode == GPIOD_LINE_OUPUT_MODE_OPENSOURCE)  {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_OPEN_SOURCE;
        } else {
            invalid_output_mode:

            ok = platch_respond_illegal_arg_std(
                "Expected `arg['outputMode']` to be a string-ification "
                "of [OutputMode] when direction is output, "
                "null when direction is input.", /*, struct error_data* */error_data
            );
            if (ok != 0) return ok;
            return EINVAL;
        }
    }

    // get the bias
    has_bias = false;
   // temp = stdmap_get_str(value, "bias");
    if (!(value->bias)) {
        // don't need to set any flags
    } else {
        if (value->bias == GPIOD_LINE_REQUEST_FLAG_BIAS_DISABLE) {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_BIAS_DISABLE;
            has_bias = true;
        } else if (value->bias == GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP ) {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP;
            has_bias = true;
        } else if (value->bias == GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_DOWN ) {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_DOWN;
            has_bias = true;
        } else {
            //invalid_bias:

            ok = platch_respond_illegal_arg_std(
                "Expected `arg['bias']` to be a stringification of [Bias] or null."
                , /*, struct error_data* */error_data
            );
            if (ok != 0) return ok;

            return EINVAL;
        }
    }

    if (has_bias && !libgpiod.line_bias) {
        ok = gpiodp_respond_not_supported(
            "Setting line bias is not supported on this platform. "
            "Expected `arg['bias']` to be null."
            , /*, struct error_data* */error_data
        );

        if (ok != 0) return ok;
        return ENOTSUP;
    }

    // get the initial value
    conf_out->initial_value = 0;
    //temp = stdmap_get_str(value, "initialValue");
    /*if ((!temp) || STDVALUE_IS_NULL(*temp)) {
        if (conf_out->direction == GPIOD_LINE_DIRECTION_INPUT) {
            // do nothing.
        } else if (conf_out->direction == GPIOD_LINE_DIRECTION_OUTPUT) {
            goto invalid_initial_value;
        }
    } else if ( temp && STDVALUE_IS_BOOL(*temp)) {*/
        if (value->initialValue && conf_out->direction == GPIOD_LINE_DIRECTION_INPUT) {
            //goto invalid_initial_value;
            ok = platch_respond_illegal_arg_std(
                "Expected `arg['initialValue']` to be null if direction is input, "
                "a bool if direction is output."
                , /*, struct error_data* */error_data
            );
            if (ok != 0) return ok;

            return EINVAL;
        } else if (conf_out->direction == GPIOD_LINE_DIRECTION_OUTPUT) {
            conf_out->initial_value = conf_out->initial_value;// STDVALUE_AS_BOOL(*temp) ? 1 : 0;
        }
    /*} else {
        invalid_initial_value:

        ok = platch_respond_illegal_arg_std(
            "Expected `arg['initialValue']` to be null if direction is input, "
            "a bool if direction is output."
        );
        if (ok != 0) return ok;

        return EINVAL;
    }*/

    // get the active state
    //temp = stdmap_get_str(value, "activeState");
    //if (temp && (temp->type == kStdString)) {
        if (value->activeState == GPIOD_LINE_ACTIVE_STATE_LOW) {
            conf_out->flags |= GPIOD_LINE_REQUEST_FLAG_ACTIVE_LOW;
        } else if (value->activeState == GPIOD_LINE_ACTIVE_STATE_HIGH) /*STREQ("ActiveState.high", temp->string_value)*/ {
            // do nothing
        } else {
            ok = platch_respond_illegal_arg_std(
                "Expected `arg['activeState']` to be a stringification of [ActiveState]."
                , error_data
            );
            if (ok != 0) return ok;

            return EINVAL;
        }

    return 0;
}

static const char* signal_methodname = "signal";

/// Runs on it's own thread. Waits for events
/// on any of the lines in `gpio_plugin.listening_lines`
/// and sends them on to the event channel, if someone
/// is listening on it.
static void *gpiodp_io_loop(void *userdata) {
    struct gpiod_line_event event;
    struct gpiod_line *line, **cursor;
    struct gpiod_chip *chip;
    struct epoll_event fdevents[10];
    unsigned int line_handle;
    bool is_ready;
    int ok, n_fdevents;

    while (gpio_plugin.line_event_listener_should_run) {
        // epoll luckily is concurrent. Other threads can add and remove fd's from this
        // epollfd while we're waiting on it.

        ok = epoll_wait(gpio_plugin.epollfd, fdevents, 10, -1);
        if ((ok == -1) && (errno != EINTR)) {
            perror("[flutter_gpiod] error while waiting for line events, epoll");
            continue;
        } else {
            n_fdevents = ok;
        }

        pthread_mutex_lock(&gpio_plugin.listening_lines_mutex);

        // Go through all the lines were listening to right now and find out,
        // check for each line whether an event ocurred on the line's fd.
        // If that's the case, read the events and send them to flutter.
        gpiod_line_bulk_foreach_line(&gpio_plugin.listening_lines, line, cursor) {
            is_ready = false;
            for (int i = 0; i < n_fdevents; i++) {
                if (fdevents[i].data.fd == libgpiod.line_event_get_fd(line)) {
                    is_ready = true;
                    break;
                }
            }
            if (!is_ready) continue;

            // read the line events
            ok = libgpiod.line_event_read(line, &event);
            if (ok == -1) {
                perror("[flutter_gpiod] Could not read events from GPIO line. gpiod_line_event_read");
                continue;
            }

            // if currently noone's listening to the
            // flutter_gpiod event channel, we don't send anything
            // to flutter and discard the events.
            if (!gpio_plugin.should_emit_events) continue;

            // convert the gpiod_line to a flutter_gpiod line handle.
            chip = libgpiod.line_get_chip(line);

            line_handle = libgpiod.line_offset(line);
            for (int i = 0; gpio_plugin.chips[i] != chip; i++)
                line_handle += libgpiod.chip_num_lines(chip);

            // finally send the event to the event channel.

          Dart_CObject c_method_name;
          c_method_name.type = Dart_CObject_kString;
          c_method_name.value.as_string = (char*)(signal_methodname);

          Dart_CObject c_line_handle;
          c_line_handle.type = Dart_CObject_kInt32;
          c_line_handle.value.as_int32 = line_handle;

          Dart_CObject c_signal_edge;
          c_signal_edge.type = Dart_CObject_kInt32;
          c_signal_edge.value.as_int32 = event.event_type == GPIOD_LINE_EVENT_FALLING_EDGE? GPIOD_LINE_SIGNAL_EDGE_FALLING : GPIOD_LINE_SIGNAL_EDGE_RISING;

          Dart_CObject c_signal_time_sec;
          c_signal_time_sec.type = Dart_CObject_kInt64;
          c_signal_time_sec.value.as_int64 = (int64_t)event.ts.tv_sec;

          Dart_CObject c_signal_time_nsec;
          c_signal_time_nsec.type = Dart_CObject_kInt64;
          c_signal_time_nsec.value.as_int64 = (int64_t)event.ts.tv_nsec;


          Dart_CObject* c_request_arr[] = {&c_method_name, &c_line_handle, &c_signal_edge, &c_signal_time_sec, &c_signal_time_nsec};
          Dart_CObject c_request;
          c_request.type = Dart_CObject_kArray;
          c_request.value.as_array.values = c_request_arr;
          c_request.value.as_array.length =
              sizeof(c_request_arr) / sizeof(c_request_arr[0]);

          Dart_PostCObject_(gpio_plugin.send_port_, &c_request);
        }

        pthread_mutex_unlock(&gpio_plugin.listening_lines_mutex);
    }

    return NULL;
}


DART_EXPORT int gpiodp_get_num_chips(int* result, struct error_data* error_data) {
    int ok;

    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }

    *result = gpio_plugin.n_chips;
    return 0;
}

DART_EXPORT int gpiodp_get_chip_details(unsigned int chip_index, struct proxy_gpiod_chip_details_struct* result, struct error_data* error_data) {
    struct gpiod_chip *chip;
    int ok;
/*
    // check the argument
    if (STDVALUE_IS_INT(object->std_arg)) {
        chip_index = STDVALUE_AS_INT(object->std_arg);
    } else {
        return platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg` to be an integer."
        );
    }
*/
    // init GPIO
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }

    // get the chip index
    if (chip_index < gpio_plugin.n_chips) {
        chip = gpio_plugin.chips[chip_index];
    } else  {
        return platch_respond_illegal_arg_std("Expected `arg` to be valid chip index."
         ,error_data
        );
    }

    // return chip details
    result->name = (char*) libgpiod.chip_name(chip);
    result->label = (char*) libgpiod.chip_label(chip);
    result->numLines = libgpiod.chip_num_lines(chip);
    return 0;
}

DART_EXPORT int gpiodp_get_line_handle(unsigned int chip_index, unsigned int line_index, int* result, struct error_data* error_data) {
    struct gpiod_chip *chip;
    int ok;

    // check arg
    //TODO: FIX IT
   /* if (STDVALUE_IS_LIST(object->std_arg)) {
        if (STDVALUE_IS_INT(object->std_arg.list[0])) {
            chip_index = STDVALUE_AS_INT(object->std_arg.list[0]);
        } else {
            return platch_respond_illegal_arg_std(
                responsehandle,
                "Expected `arg[0]` to be an integer."
            );
        }

        if (STDVALUE_IS_INT(object->std_arg.list[1])) {
            line_index = STDVALUE_AS_INT(object->std_arg.list[1]);
        } else {
            return platch_respond_illegal_arg_std(
                responsehandle,
                "Expected `arg[1]` to be an integer."
            );
        }
    } else {
        return platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg` to be a list with length 2."
        );
    }*/

    // try to init GPIO
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }

    // try to get the chip correspondig to the chip index
    if (chip_index < gpio_plugin.n_chips) {
        chip = gpio_plugin.chips[chip_index];
    } else {
        return platch_respond_illegal_arg_std(
            "Expected `arg[0]` to be a valid chip index."
            ,error_data
        );
    }

    // check if the line index is in range
    if (line_index >= libgpiod.chip_num_lines(chip)) {
        return platch_respond_illegal_arg_std(
            "Expected `arg[1]` to be a valid line index."
            ,error_data
        );
    }

    // transform the line index into a line handle
    for (int i = 0; i < chip_index; i++){
        line_index += libgpiod.chip_num_lines(gpio_plugin.chips[i]);
    }

    *result = line_index;
    return 0;
}

DART_EXPORT int gpiodp_get_line_details(unsigned int line_handle, struct proxy_gpiod_line_details_struct* result, struct error_data* error_data) {
    struct gpiod_line *line;
    //unsigned int line_handle;
    //char *name, *consumer;
    //char *direction_str, *bias_str, *output_mode_str, *active_state_str;
    bool open_source = 0;
    bool open_drain = 0;
    int direction, bias;
    int ok;

    // check arg
    /*if (STDVALUE_IS_INT(object->std_arg)) {
        line_handle = STDVALUE_AS_INT(object->std_arg);
    } else {
        return platch_respond_illegal_arg_std(
            "Expected `arg` to be an integer."
        );
    }*/

    // init GPIO
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }

    // try to get the gpiod line corresponding to the line handle
    if (line_handle < gpio_plugin.n_lines) {
        line = gpio_plugin.lines[line_handle];
    } else {
        return gpiodp_respond_illegal_line_handle(error_data);
    }

    // if we don't own the line, update it
    if (!libgpiod.line_is_requested(line)) {
        libgpiod.line_update(line);
    }

    direction = libgpiod.line_direction(line);
    /*direction_str = direction == GPIOD_LINE_DIRECTION_INPUT ?
                            "LineDirection.input" : "LineDirection.output";*/

  /*  active_state_str = libgpiod.line_active_state(line) == GPIOD_LINE_ACTIVE_STATE_HIGH ?
                        "ActiveState.high" : "ActiveState.low";*/

    //bias_str = NULL;
    if (libgpiod.line_bias) {
        bias = libgpiod.line_bias(line);
        /*if (bias == GPIOD_LINE_BIAS_DISABLE) {
            bias_str = "Bias.disable";
        } else if (bias == GPIOD_LINE_BIAS_PULL_UP) {
            bias_str = "Bias.pullUp";
        } else {
            bias_str = "Bias.pullDown";
        }*/
    }

    //output_mode_str = NULL;
    if (direction == GPIOD_LINE_DIRECTION_OUTPUT) {
        open_source = libgpiod.line_is_open_source(line);
        open_drain = libgpiod.line_is_open_drain(line);
    }

    result->name = (char*) libgpiod.line_name(line);
    result->consumer = (char*) libgpiod.line_consumer(line);
    result->isUsed = libgpiod.line_is_used(line);
    result->isRequested = libgpiod.line_is_requested(line);
    result->isFree = libgpiod.line_is_free(line);
    result->direction = direction;
    result->open_source = open_source;
    result->open_drain = open_drain;
    result->bias = bias;
    result->activeState = libgpiod.line_active_state(line);
    return 0;
}

DART_EXPORT int gpiodp_request_line(struct proxy_gpiod_line_config_struct *value, struct error_data* error_data) {
    struct line_config config;
    //struct std_value *temp;
    bool is_event_line = false;
    char *consumer;
    int ok, fd;

    // check that the arg is a map
/*    if (object->std_arg.type != kStdMap) {
        return platch_respond_illegal_arg_std(
            "Expected `arg` to be a `Map<String, dynamic>`"
        );
    }*/

    // ensure GPIO is initialized
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }


    if ( !(value->consumer)) {
        consumer = NULL;
    } else {
        consumer = value->consumer;
    }

    // get the line config
    ok = gpiodp_get_config(value, &config);
    if (ok != 0) return ok;

    // get the triggers
    //temp = stdmap_get_str(&object->std_arg, "triggers");
    if (!(value->triggers)) {
        if (config.direction == GPIOD_LINE_DIRECTION_INPUT) {
            goto invalid_triggers;
        }
    } else {
        if (config.direction == GPIOD_LINE_DIRECTION_OUTPUT) {
            //goto invalid_triggers;
            invalid_triggers:
            return platch_respond_illegal_arg_std(
                "Expected `arg['triggers']` to be a `List<String>` of "
                "string-ifications of [SignalEdge] when direction is input "
                "(no null values in the list), null when direction is output."
            );
        }

        // iterate through elements in the trigger list.
        //for (int i = 0; i < temp->size; i++) {
/*            if (temp->list[i].type != kStdString) {
                goto invalid_triggers;
            }*/

            // now update config.request_type accordingly.
            if (value->triggers & GPIOD_LINE_SIGNAL_EDGE_FALLING == GPIOD_LINE_SIGNAL_EDGE_FALLING) /*STREQ("SignalEdge.falling", temp->list[i].string_value)*/ {
                is_event_line = true;
                switch (config.request_type) {
                    case GPIOD_LINE_REQUEST_DIRECTION_INPUT:
                        config.request_type = GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE;
                        break;
                    case GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE:
                        break;
                    case GPIOD_LINE_REQUEST_EVENT_RISING_EDGE:
                    case GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES:
                        config.request_type = GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES;
                        break;
                    default: break;
                }
            }
            if (value->triggers & GPIOD_LINE_SIGNAL_EDGE_RISING == GPIOD_LINE_SIGNAL_EDGE_RISING)  {
                is_event_line = true;
                switch (config.request_type) {
                    case GPIOD_LINE_REQUEST_DIRECTION_INPUT:
                        config.request_type = GPIOD_LINE_REQUEST_EVENT_RISING_EDGE;
                        break;
                    case GPIOD_LINE_REQUEST_EVENT_RISING_EDGE:
                        break;
                    case GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE:
                    case GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES:
                        config.request_type = GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES;
                        break;
                    default: break;
                }
            }
            //TODO: Error?
    } /*else {
        invalid_triggers:
        return platch_respond_illegal_arg_std(
            "Expected `arg['triggers']` to be a `List<String>` of "
            "string-ifications of [SignalEdge] when direction is input "
            "(no null values in the list), null when direction is output."
        );
    }*/

    // finally request the line
    ok = libgpiod.line_request(
        config.line,
        &(struct gpiod_line_request_config) {
            .consumer = consumer,
            .request_type = config.request_type,
            .flags = config.flags
        },
        config.initial_value
    );
    if (ok == -1) {
        return platch_respond_native_error_std(errno, error_data);
    }

    if (is_event_line) {
        pthread_mutex_lock(&gpio_plugin.listening_lines_mutex);

        fd = libgpiod.line_event_get_fd(config.line);
        ok = epoll_ctl(gpio_plugin.epollfd,
                       EPOLL_CTL_ADD,
                       fd,
                       &(struct epoll_event) {.events = EPOLLPRI | EPOLLIN, .data.fd = fd}
        );
        if (ok == -1) {
            perror("[flutter_gpiod] Could not add GPIO line to epollfd. epoll_ctl");
            libgpiod.line_release(config.line);
            return platch_respond_native_error_std(errno, error_data);
        }

        gpiod_line_bulk_add(&gpio_plugin.listening_lines, config.line);

        pthread_mutex_unlock(&gpio_plugin.listening_lines_mutex);
    }

    return 0;
}

DART_EXPORT int gpiodp_release_line(unsigned int line_handle, struct error_data* error_data) {
    struct gpiod_line *line;
    //unsigned int line_handle;
    int ok, fd;

    // get the line handle
    /*if (STDVALUE_IS_INT(object->std_arg)) {
        line_handle = STDVALUE_AS_INT(object->std_arg);
    } else {
        return platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg` to be an integer."
        );
    }*/

    // get the corresponding gpiod line
    if (line_handle < gpio_plugin.n_lines) {
        line = gpio_plugin.lines[line_handle];
    } else {
        return gpiodp_respond_illegal_line_handle(error_data);
    }

    // Try to get the line associated fd and remove
    // it from the listening thread
    fd = libgpiod.line_event_get_fd(line);
    if (fd != -1) {
        pthread_mutex_lock(&gpio_plugin.listening_lines_mutex);

        gpiod_line_bulk_remove(&gpio_plugin.listening_lines, line);

        ok = epoll_ctl(gpio_plugin.epollfd, EPOLL_CTL_DEL, fd, NULL);
        if (ok == -1) {
            perror("[flutter_gpiod] Could not remove GPIO line from epollfd. epoll_ctl");
            return platch_respond_native_error_std(errno, error_data);
        }

        pthread_mutex_unlock(&gpio_plugin.listening_lines_mutex);
    }

    ok = libgpiod.line_release(line);
    if (ok == -1) {
        perror("[flutter_gpiod] Could not release line. gpiod_line_release");
        return platch_respond_native_error_std(errno, error_data);
    }

    return 0;//platch_respond_success_std(NULL);
}

DART_EXPORT int gpiodp_reconfigure_line(struct proxy_gpiod_line_config_struct *value, struct error_data* error_data) {
    struct line_config config;
    int ok;

    // ensure GPIO is initialized
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
        return gpiodp_respond_init_failed(error_data);
    }

    ok = gpiodp_get_config(value, &config, error_data);
    if (ok != 0) return ok;

    if (!libgpiod.line_set_config) {
        return gpiodp_respond_not_supported(
            "Line reconfiguration is not supported on this platform."
            ,error_data
        );
    }

    // finally temp the line
    ok = libgpiod.line_set_config(
        config.line,
        config.direction,
        config.flags,
        config.initial_value
    );
    if (ok == -1) {
        return platch_respond_native_error_std(errno, error_data);
    }

    return 0;
}

DART_EXPORT int gpiodp_get_line_value(unsigned int line_handle, int* result, struct error_data* error_data) {
    struct gpiod_line *line;
    //unsigned int line_handle;
    int ok;

    // get the line handle
    /*if (STDVALUE_IS_INT(object->std_arg)) {
        line_handle = STDVALUE_AS_INT(object->std_arg);
    } else {
        return platch_respond_illegal_arg_std(
            "Expected `arg` to be an integer."
        );
    }*/

    // get the corresponding gpiod line
    if (line_handle < gpio_plugin.n_lines) {
        line = gpio_plugin.lines[line_handle];
    } else {
        return gpiodp_respond_illegal_line_handle(error_data);
    }

    // get the line value
    ok = libgpiod.line_get_value(line);
    if (ok == -1) {
        return platch_respond_native_error_std(errno, error_data);
    }

    *result = ok;
    return 0;//platch_respond_success_std(&STDBOOL(ok));
}

DART_EXPORT int gpiodp_set_line_value(unsigned int line_handle, bool value, struct error_data* error_data) {
    //struct std_value *temp;
    struct gpiod_line *line;
    //bool value;
    int ok;

    /*if (STDVALUE_IS_SIZED_LIST(object->std_arg, 2)) {
        if (STDVALUE_IS_INT(object->std_arg.list[0])) {
            line_handle = STDVALUE_AS_INT(object->std_arg.list[0]);
        } else {
            return platch_respond_illegal_arg_std(
                responsehandle,
                "Expected `arg[0]` to be an integer."
            );
        }

        if (STDVALUE_IS_BOOL(object->std_arg.list[1])) {
            value = STDVALUE_AS_BOOL(object->std_arg.list[1]);
        } else {
            return platch_respond_illegal_arg_std(
                responsehandle,
                "Expected `arg[1]` to be a bool."
            );
        }
    } else {
        return platch_respond_illegal_arg_std(
            responsehandle,
            "Expected `arg` to be a list."
        );
    }*/

    // get the corresponding gpiod line
    if (line_handle < gpio_plugin.n_lines) {
        line = gpio_plugin.lines[line_handle];
    } else {
        return gpiodp_respond_illegal_line_handle(error_data);
    }

    // get the line value
    ok = libgpiod.line_set_value(line, value ? 1 : 0);
    if (ok == -1) {
        return platch_respond_native_error_std(errno, error_data);
    }

    return 0;
}

DART_EXPORT int gpiodp_supports_bias(int* result, struct error_data* error_data) {
    int ok;

    // ensure GPIO is initialized
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
       return gpiodp_respond_init_failed(error_data);
    }

    *result = libgpiod.line_bias;
    return 0;
}

DART_EXPORT int gpiodp_supports_reconfiguration(int* result, struct error_data* error_data) {
    int ok;

    // ensure GPIO is initialized
    ok = gpiodp_ensure_gpiod_initialized();
    if (ok != 0) {
       return gpiodp_respond_init_failed(error_data);
    }

    *result = libgpiod.line_set_config;
    return 0;
}