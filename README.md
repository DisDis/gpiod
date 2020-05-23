# gpiod

A library for GPIO access on linux using libgpiod.

You need to have `libgpiod.so` on your system for it to work.
You can install it using `sudo apt install gpiod`.

# proxy_gpiod

A proxy library for GPIO access on linux using libgpiod.

You need to have `libproxy_gpiod.so` and `libgpiod.so` on your system for it to work.
You can install 'libgpiod' using `sudo apt install gpiod`.

You can build 'libproxy_gpiod.so' using :
`
cd proxy_gpiod
./build.sh
`

## Getting Started

Then, you can retrieve the list of GPIO chips attached to
your system using [ProxyGpiod.chips]. Each chip has a name,
label and a number of GPIO lines associated with it.
```dart
final gpio = ProxyGpiod.getInstance();

final chips = gpio.chips;

for (final chip in chips) {
    print("chip name: ${chip.name}, chip label: ${chip.label}");

    for (final line in chip.lines) {
        print("  line: $line");
    }
}
```

Each line also has some information associated with it that can be
retrieved using [GpioLine.info].
The information can change at any time if the line is not owned/requested by you.
```dart
// Get the instance of the FlutterGpiod singleton.
final gpio = ProxyGpiod.getInstance();

// Get the chip with label 'pinctrl-bcm2835'.
// This is the main Raspberry Pi GPIO chip.
final chip = gpio.chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835');

// Get line 22 of the 'pinctrl-bcm2835' GPIO chip.
// This is the BCM 22 pin of the Raspberry Pi.
final line = chip.lines[22];

print("line info: ${await line.info}")
```

To control a line (to read or write values or to listen for edges),
you need to request it using [GpioLine.requestInput] or [GpioLine.requestOutput].
```dart
final gpio = ProxyGpiod.getInstance();
final chip = gpio.chips.singleWhere((chip) => chip.label == 'pinctrl-bcm2835');
final line = chip.lines[22];

// request it as input.
line.requestInput();
print("line value: ${line.getValue()}");
line.release();

// now we're requesting it as output.
line.requestOutput(initialValue: true);
line.setValue(false);
line.release();

// request it as input again, but this time we're also listening
// for edges; both in this case.
line.requestInput(triggers: {SignalEdge.falling, SignalEdge.rising});

print("line value: ${line.getValue()}");

// line.onEvent will not emit any events if no triggers
// are requested for the line.
// this will run forever
for (final event in line.onEvent) {
  print("got GPIO line signal event: $event");
}

line.release();
```
