
import 'dart:ffi';

import 'package:gpiod/src/bindings/proxy_gpiod/signatures.dart';
import 'package:gpiod/src/bindings/proxy_gpiod/types.dart';

final DynamicLibrary _dynamicLibrary = DynamicLibrary.open(LibraryProxyGPIOD.libraryName);

class LibraryProxyGPIOD {
  static const String libraryName = './libproxy_gpiod.so';


  //int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
//  int Function(int epfd, int op, int fd, Pointer<epoll_event> event) epoll_ctl;

  final register_send_port = _dynamicLibrary.lookupFunction<Void Function(Int64 sendPort),
      void Function(int sendPort)>('proxy_gpiod_register_send_port');
  final _registerDart_PostCObject = _dynamicLibrary.lookupFunction<
      Void Function(
          Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
          functionPointer),
      void Function(
          Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
          functionPointer)>('proxy_gpiod_register_dart_postcobject');

  final _registerDart_NewNativePort = _dynamicLibrary.lookupFunction<
      Void Function(
          Pointer<
              NativeFunction<
                  Int64 Function(
                      Pointer<Uint8>,
                      Pointer<NativeFunction<Dart_NativeMessageHandler>>,
                      Int8)>>
          functionPointer),
      void Function(
          Pointer<
              NativeFunction<
                  Int64 Function(
                      Pointer<Uint8>,
                      Pointer<NativeFunction<Dart_NativeMessageHandler>>,
                      Int8)>>
          functionPointer)>('proxy_gpiod_register_dart_newnativeport');

  final _registerDart_CloseNativePort = _dynamicLibrary.lookupFunction<
      Void Function(
          Pointer<NativeFunction<Int8 Function(Int64)>> functionPointer),
      void Function(
          Pointer<NativeFunction<Int8 Function(Int64)>> functionPointer)>(
      'proxy_gpiod_register_dart_closenativeport');

  ///int gpiodp_get_num_chips(struct platch_obj *object, FlutterPlatformMessageResponseHandle *responsehandle)
  final int Function(Pointer<Int32> result, Pointer<ErrorData> error) get_num_chips = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_get_num_chips')
      .asFunction();

  final int Function(int chipIndex, Pointer<ChipDetails> result, Pointer<ErrorData> error) get_chip_details = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_chip_details_native_t>>('gpiodp_get_chip_details').asFunction();
  final int Function(int chipIndex,int lineIndex,Pointer<Int32> result, Pointer<ErrorData> error) get_line_handle = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_handle_native_t>>('gpiodp_get_line_handle').asFunction();
  final int Function(int lineHandle, Pointer<LineDetails> result, Pointer<ErrorData> error) get_line_details = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_details_native_t>>('gpiodp_get_line_details').asFunction();
  final int Function(Pointer<LineConfig> lineConfig, Pointer<ErrorData> error) request_line = _dynamicLibrary.lookup<NativeFunction<gpiodp_request_line_native_t>>('gpiodp_request_line').asFunction();
  final int Function(int lineHandle, Pointer<ErrorData> error) release_line = _dynamicLibrary.lookup<NativeFunction<gpiodp_release_line_native_t>>('gpiodp_release_line').asFunction();
  final int Function(Pointer<LineConfig> lineConfig, Pointer<ErrorData> error) reconfigure_line = _dynamicLibrary.lookup<NativeFunction<gpiodp_reconfigure_line_native_t>>('gpiodp_reconfigure_line').asFunction();
  final int Function(int line_handle,Pointer<Int32> result, Pointer<ErrorData> error) get_line_value = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_line_value_native_t>>('gpiodp_get_line_value').asFunction();
  final int Function(int line_handle, int value, Pointer<ErrorData> error) set_line_value = _dynamicLibrary.lookup<NativeFunction<gpiodp_set_line_value_native_t>>('gpiodp_set_line_value').asFunction();
  final int Function(Pointer<Int32> result, Pointer<ErrorData> error) supports_bias = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_supports_bias')
      .asFunction();
  final int Function(Pointer<Int32> result, Pointer<ErrorData> error) supports_reconfiguration = _dynamicLibrary.lookup<NativeFunction<gpiodp_get_num_chips_native_t>>('gpiodp_supports_reconfiguration')
      .asFunction();

  static LibraryProxyGPIOD _instance;

  factory LibraryProxyGPIOD(){
    if (_instance == null) {
      _instance = new LibraryProxyGPIOD._internal();
      _instance._registerDart_PostCObject(NativeApi.postCObject);
      _instance._registerDart_NewNativePort(NativeApi.newNativePort);
      _instance._registerDart_CloseNativePort(NativeApi.closeNativePort);
    }
    return _instance;
  }

  LibraryProxyGPIOD._internal();
}