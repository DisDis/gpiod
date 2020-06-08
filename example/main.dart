import 'package:gpiod/proxy_gpiod.dart';


void main() async {
  try {
    final gpio = ProxyGpiod.getInstance();
    _status(gpio.chips);
    await _led(gpio.chips);
    await _pirTest(gpio.chips);
    await _button(gpio.chips);
    _status(gpio.chips);
  } catch(e, st){
    print('Error $e $st');
  }
}


Future _pirTest(List<GpioChip> chips) async{
  print('PIR');
  final lineLED =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[14];
  final linePIR =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[15];

  /// Request BCM 14 as output.
  lineLED.requestOutput(
      consumer: "flutter_gpiod test", initialValue: true);

  for (var i = 0; i<2 ;i++) {
    /// Pulse the line.
    /// Set it to inactive. (so low voltage = GND)
    lineLED.setValue(false);
    await Future.delayed(Duration(milliseconds: 500));
    lineLED.setValue(true);
    await Future.delayed(Duration(milliseconds: 500));
  }
  lineLED.setValue(false);

  linePIR.requestInput(
      consumer: "PIR",
      //        activeState: ActiveState.low,
      triggers: {SignalEdge.falling, SignalEdge.rising});

  /// Log line events for eternity.
  linePIR.onEvent.listen((event){
    print("PIR: $event");
    lineLED.setValue(event.edge == SignalEdge.falling);
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
  line14.requestOutput(
      consumer: "flutter_gpiod test", initialValue: true);

  for (var i = 0; i<5 ;i++) {
    /// Pulse the line.
    /// Set it to inactive. (so low voltage = GND)
    line14.setValue(false);
    await Future.delayed(Duration(milliseconds: 500));
    line14.setValue(true);
    await Future.delayed(Duration(milliseconds: 500));
  }
  line14.release();
}

Future _button(List<GpioChip> chips) {
  print('BUTTON');
  final line =
  chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835').lines[17];

  line.requestInput(
      consumer: "BUTTON",
      activeState: ActiveState.high,
      triggers: {SignalEdge.falling, SignalEdge.rising});

  /// Log line events for eternity.
  line.onEvent.listen((event) {
    print("Button: $event");
  });

//   /// Release the line, though we'll never reach this point.
//    await line15.release();
}

Future _status(List<GpioChip> chips) {
  /// Print out all GPIO chips and all lines
  /// for all GPIO chips.
  for (var chip in chips) {
    print("$chip");

    var index = 0;
    for (var line in chip.lines) {
      final info = line.info;
      if (info.consumer!=null) {
        print("$index:  ${line.info}");
      }

      index++;
    }
  }
}

