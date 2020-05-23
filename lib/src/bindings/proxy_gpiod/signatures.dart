import 'dart:ffi';
import 'types.dart';

///void print_hello();
typedef print_hello_native_t = Void Function();

///int gpiodp_get_num_chips(struct platch_obj *object, FlutterPlatformMessageResponseHandle *responsehandle)
typedef gpiodp_get_num_chips_native_t = Int32 Function();
typedef gpiodp_get_chip_details_native_t = Int32 Function(Uint32 chipIndex, Pointer<ChipDetails> chipDetails);
typedef gpiodp_get_line_handle_native_t = Int32 Function(Uint32 chipIndex,Uint32 lineIndex);
typedef gpiodp_get_line_details_native_t = Int32 Function(Uint32 lineHandle, Pointer<LineDetails> result);
typedef gpiodp_request_line_native_t = Int32 Function(Pointer<LineConfig> lineConfig);
typedef gpiodp_release_line_native_t = Int32 Function(Uint32 lineHandle);
typedef gpiodp_reconfigure_line_native_t = Int32 Function();
typedef gpiodp_get_line_value_native_t = Int32 Function();
typedef gpiodp_set_line_value_native_t = Int32 Function();
typedef gpiodp_supports_bias_native_t = Int32 Function();
typedef gpiodp_supports_reconfiguration_native_t = Int32 Function();

//int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
//typedef epoll_wait_native_t = Int32 Function(Int32 epfd, Pointer<epoll_event> events, Int32 maxevents, Int32 timeout);
