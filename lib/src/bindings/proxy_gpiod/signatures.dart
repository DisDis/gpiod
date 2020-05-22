import 'dart:ffi';
import 'types.dart';

///void print_hello();
typedef print_hello_native_t = Void Function();

///int gpiodp_get_num_chips(struct platch_obj *object, FlutterPlatformMessageResponseHandle *responsehandle)
///int gpiodp_get_chip_details(struct platch_obj *object, FlutterPlatformMessageResponseHandle *responsehandle) {
/*
         gpiodp_get_line_handle(object, responsehandle);
         gpiodp_get_line_details(object, responsehandle);
         gpiodp_request_line(object, responsehandle);
         gpiodp_release_line(object, responsehandle);
         gpiodp_reconfigure_line(object, responsehandle);
         gpiodp_get_line_value(object, responsehandle);
         gpiodp_set_line_value(object, responsehandle);
         gpiodp_supports_bias(object, responsehandle);
         gpiodp_supports_reconfiguration(object, responsehandle);
  * */

//int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
//typedef epoll_wait_native_t = Int32 Function(Int32 epfd, Pointer<epoll_event> events, Int32 maxevents, Int32 timeout);
