/// The direction of a gpiod line.
class LineDirection {
  final int value;
  const LineDirection._internal(this.value);
  //GPIOD_LINE_DIRECTION_INPUT = 1,
  /**< Direction is input - we're reading the state of a GPIO line. */
  static const LineDirection input = const LineDirection._internal(1);
  //GPIOD_LINE_DIRECTION_OUTPUT,
  /**< Direction is output - we're driving the GPIO line. */
  static const LineDirection output = const LineDirection._internal(2);

  static List<LineDirection> get values => [input, output];
  static LineDirection parse(int value) => values.firstWhere((element) => element.value == value);
}

/// Whether the line should be high voltage when
/// it's active or low voltage.

/// The direction of a gpiod line.
class ActiveState {
  final int value;
  const ActiveState._internal(this.value);

  //GPIOD_LINE_ACTIVE_STATE_HIGH = 1,
  /**< The active state of a GPIO is active-high. */
  static const ActiveState high = const ActiveState._internal(1);
  //GPIOD_LINE_ACTIVE_STATE_LOW,
  /**< The active state of a GPIO is active-low. */
  static const ActiveState low = const ActiveState._internal(2);

  static List<ActiveState> get values => [high, low];
  static ActiveState parse(int value) => values.firstWhere((element) => element.value == value);
}

/// Whether there should be pull-up or -down
/// resistors connected to the line.
class Bias {
  final int value;
  const Bias._internal(this.value);

  //GPIOD_LINE_BIAS_AS_IS= 1
  /**< The internal bias state is unknown. */
  static const Bias asIs = const Bias._internal(1);
  //  GPIOD_LINE_BIAS_DISABLE,
  /**< The internal bias is disabled. */
  static const Bias disable = const Bias._internal(2);
  //GPIOD_LINE_BIAS_PULL_UP,
  /**< The internal pull-up bias is enabled. */
  static const Bias pullUp = const Bias._internal(3);
  //  GPIOD_LINE_BIAS_PULL_DOWN,
  /**< The internal pull-down bias is enabled. */
  static const Bias pullDown = const Bias._internal(4);

  static List<Bias> get values => [asIs, disable, pullUp, pullDown];
  static Bias parse(int value, [Bias defaultValue]) => values.firstWhere((element) => element.value == value,orElse: ()=>defaultValue);
}

/// The way high voltage / low voltage should be written
/// to the line.
class OutputMode {
  final int value;
  const OutputMode._internal(this.value);

  static const OutputMode pushPull = const OutputMode._internal(1);
  static const OutputMode openDrain = const OutputMode._internal(2);
  static const OutputMode openSource = const OutputMode._internal(3);

  static List<OutputMode> get values => [pushPull, openDrain, openSource];
  static OutputMode parse(int value, [OutputMode defaultValue]) => values.firstWhere((element) => element.value == value,orElse: ()=>defaultValue);
}


/// It's a rising edge when the voltage goes from low to high,
/// falling from high to low.
class SignalEdge {
  final int value;
  const SignalEdge._internal(this.value);

  static const SignalEdge rising = const SignalEdge._internal(1);
  static const SignalEdge falling = const SignalEdge._internal(2);

  static List<SignalEdge> get values => [rising, falling];
  static SignalEdge parse(int value, [SignalEdge defaultValue]) => values.firstWhere((element) => element.value == value,orElse: ()=>defaultValue);
}
