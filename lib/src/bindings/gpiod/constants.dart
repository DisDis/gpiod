/**
 * @brief Available types of requests.
 */
class LineRequestType{
  final int value;
  const LineRequestType._internal(this.value);

//GPIOD_LINE_REQUEST_DIRECTION_AS_IS = 1,
  /**< Request the line(s), but don't change current direction. */
  static const LineRequestType GPIOD_LINE_REQUEST_DIRECTION_AS_IS = const LineRequestType._internal(1);
//GPIOD_LINE_REQUEST_DIRECTION_INPUT,
  /**< Request the line(s) for reading the GPIO line state. */
  static const LineRequestType GPIOD_LINE_REQUEST_DIRECTION_INPUT = const LineRequestType._internal(2);
//GPIOD_LINE_REQUEST_DIRECTION_OUTPUT,
  /**< Request the line(s) for setting the GPIO line state. */
  static const LineRequestType GPIOD_LINE_REQUEST_DIRECTION_OUTPUT = const LineRequestType._internal(3);
//GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE,
  /**< Monitor both types of events. */
  static const LineRequestType GPIOD_LINE_REQUEST_EVENT_FALLING_EDGE = const LineRequestType._internal(4);
//GPIOD_LINE_REQUEST_EVENT_RISING_EDGE,
  /**< Only watch rising edge events. */
  static const LineRequestType GPIOD_LINE_REQUEST_EVENT_RISING_EDGE = const LineRequestType._internal(5);
//GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES,
  /**< Only watch falling edge events. */
  static const LineRequestType GPIOD_LINE_REQUEST_EVENT_BOTH_EDGES = const LineRequestType._internal(6);
}


/// The direction of a gpiod line.
class LineDirection {
  final int value;
  const LineDirection._internal(this.value);
  //GPIOD_LINE_DIRECTION_INPUT = 1,
  /**< Direction is input - we're reading the state of a GPIO line. */
  static const LineDirection GPIOD_LINE_DIRECTION_INPUT = const LineDirection._internal(1);
//  static const LineDirection input = const LineDirection._internal(1);
  //GPIOD_LINE_DIRECTION_OUTPUT,
  /**< Direction is output - we're driving the GPIO line. */
  static const LineDirection GPIOD_LINE_DIRECTION_OUTPUT = const LineDirection._internal(2);
//  static const LineDirection output = const LineDirection._internal(2);

  static List<LineDirection> get values => [GPIOD_LINE_DIRECTION_INPUT, GPIOD_LINE_DIRECTION_OUTPUT];
  static LineDirection parse(int value) => values.firstWhere((element) => element.value == value);
}

class LineRequestFlag {
  final int value;
  const LineRequestFlag._internal(this.value);
//	GPIOD_LINE_REQUEST_FLAG_OPEN_DRAIN	= GPIOD_BIT(0),
  /**< The line is an open-drain port. */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_OPEN_DRAIN = const LineRequestFlag._internal(0);

  //GPIOD_LINE_REQUEST_FLAG_OPEN_SOURCE	= GPIOD_BIT(1),
  /**< The line is an open-source port. */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_OPEN_SOURCE = const LineRequestFlag._internal(1);

//	GPIOD_LINE_REQUEST_FLAG_ACTIVE_LOW	= GPIOD_BIT(2),
  /**< The active state of the line is low (high is the default). */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_ACTIVE_LOW = const LineRequestFlag._internal(2);

//	GPIOD_LINE_REQUEST_FLAG_BIAS_DISABLE	= GPIOD_BIT(3),
  /**< The line has neither either pull-up nor pull-down resistor. */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_BIAS_DISABLE = const LineRequestFlag._internal(4);

//	GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_DOWN	= GPIOD_BIT(4),
  /**< The line has pull-down resistor enabled. */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_DOWN = const LineRequestFlag._internal(8);

//	GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP	= GPIOD_BIT(5),
  /**< The line has pull-up resistor enabled. */
  static const LineRequestFlag GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP = const LineRequestFlag._internal(16);
}
