import 'dart:convert';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:gpiod/proxy_gpiod.dart';
import 'package:logging/logging.dart';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';


final Logger _log = new Logger('main');


class CppRequest {
  final SendPort replyPort;
  final int pendingCall;
  final String method;
  final Uint8List data;

  factory CppRequest.fromCppMessage(List message) {
    return CppRequest._(message[0], message[1], message[2], message[3]);
  }

  CppRequest._(this.replyPort, this.pendingCall, this.method, this.data);

  String toString() => 'CppRequest(method: $method, ${data.length} bytes)';
}

void handleCppRequests(dynamic message) {
  final cppRequest = CppRequest.fromCppMessage(message);
  print('Dart:   Got message: $cppRequest');

//  if (cppRequest.method == 'myCallback1') {
//    // Use the data in any way you like. Here we just take the first byte as
//    // the argument to the function.
//    final int argument = cppRequest.data[0];
//    final int result = myCallback1(argument);
//    final cppResponse =
//    CppResponse(cppRequest.pendingCall, Uint8List.fromList([result]));
//    print('Dart:   Responding: $cppResponse');
//    cppRequest.replyPort.send(cppResponse.toCppMessage());
//  } else if (cppRequest.method == 'myCallback2') {
//    final int argument = cppRequest.data[0];
//    myCallback2(argument);
//  }
}

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

//var gpiod = GPIOD();
//var pthread = Pthread();

    var proxyGPIOD = new ProxyGPIOD();
    proxyGPIOD.print_hello();

    final interactiveCppRequests = ReceivePort()..listen(handleCppRequests);
    final int nativePort = interactiveCppRequests.sendPort.nativePort;
    proxyGPIOD.register_send_port(nativePort);
    final gpio = await FlutterGpiod.getInstance();
    _status(gpio.chips);
    _led(gpio.chips);
    _pirTest(gpio.chips);
    _button(gpio.chips);

  } catch(e, st){
    _log.severe("Error",e, st);
  }
}


Future _pirTest(List<GpioChip> chips) async {
  print('PIR');
  final lineLED =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[14];
  final linePIR =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[17];

  /// Request BCM 14 as output.
  await lineLED.requestOutput(
      consumer: "flutter_gpiod test", initialValue: true);

  for (var i = 0; i<2 ;i++) {
    /// Pulse the line.
    /// Set it to inactive. (so low voltage = GND)
    await lineLED.setValue(false);
    await Future.delayed(Duration(milliseconds: 500));
    await lineLED.setValue(true);
    await Future.delayed(Duration(milliseconds: 500));
  }
  await lineLED.setValue(false);

  await linePIR.requestInput(
      consumer: "PIR",
      //        activeState: ActiveState.low,
      triggers: {SignalEdge.falling, SignalEdge.rising});

  /// Log line events for eternity.
  linePIR.onEvent.listen((event) async{
    print("PIR: $event");
    await lineLED.setValue(event.edge == SignalEdge.falling);
  });

//    await lineLED.release();
//    await linePIR.release();
}


Future _led(List<GpioChip> chips) async {
  print('LED');
  /// Retrieve the line with index 23 of the first chip.
  /// This is BCM pin 23 for the Raspberry Pi.
  ///
  /// I recommend finding the chip you want
  /// based on the chip label, as is done here.
  ///
  /// In this example, we search for the main Raspberry Pi GPIO chip,
  /// which has the label `pinctrl-bcm2835`, and then retrieve the line
  /// with index 14 of it. So [line] is GPIO pin BCM 14.
  final line14 =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[14];

  /// Request BCM 14 as output.
  await line14.requestOutput(
      consumer: "flutter_gpiod test", initialValue: true);

  for (var i = 0; i<5 ;i++) {
    /// Pulse the line.
    /// Set it to inactive. (so low voltage = GND)
    await line14.setValue(false);
    await Future.delayed(Duration(milliseconds: 500));
    await line14.setValue(true);
    await Future.delayed(Duration(milliseconds: 500));
  }
  await line14.release();
}

Future _button(List<GpioChip> chips) async {
  print('BUTTON');
  final line15 =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[15];

  await line15.requestInput(
      consumer: "BUTTON",
      activeState: ActiveState.high,
      triggers: {SignalEdge.falling, SignalEdge.rising});

  /// Log line events for eternity.
  line15.onEvent.listen((event) {
    print("Button: $event");
  });

//   /// Release the line, though we'll never reach this point.
//    await line15.release();
}

Future _status(List<GpioChip> chips) async {
  /// Print out all GPIO chips and all lines
  /// for all GPIO chips.
  for (var chip in chips) {
    print("$chip");

    var index = 0;
    for (var line in chip.lines) {
      final info = await line.info;
      if (info.consumer!=null) {
        print("$index:  ${await line.info}");
      }

      index++;
    }
  }
}

