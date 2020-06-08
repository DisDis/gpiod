import 'dart:ffi';
import 'types.dart';

typedef gpiodp_get_num_chips_native_t = Int32 Function(Pointer<Int32> result, Pointer<ErrorData> error);
typedef gpiodp_get_chip_details_native_t = Int32 Function(Uint32 chipIndex, Pointer<ChipDetails> chipDetails, Pointer<ErrorData> error);
typedef gpiodp_get_line_handle_native_t = Int32 Function(Uint32 chipIndex,Uint32 lineIndex,Pointer<Int32> result, Pointer<ErrorData> error);
typedef gpiodp_get_line_details_native_t = Int32 Function(Uint32 lineHandle, Pointer<LineDetails> result, Pointer<ErrorData> error);
typedef gpiodp_request_line_native_t = Int32 Function(Pointer<LineConfig> lineConfig, Pointer<ErrorData> error);
typedef gpiodp_release_line_native_t = Int32 Function(Uint32 lineHandle, Pointer<ErrorData> error);
typedef gpiodp_reconfigure_line_native_t = Int32 Function(Pointer<LineConfig> lineConfig, Pointer<ErrorData> error);
typedef gpiodp_get_line_value_native_t = Int32 Function(Uint32 line_handle,Pointer<Int32> result, Pointer<ErrorData> error);
typedef gpiodp_set_line_value_native_t = Int32 Function(Uint32 line_handle, Uint8 value, Pointer<ErrorData> error);
typedef gpiodp_supports_bias_native_t = Int32 Function(Pointer<Int32> result, Pointer<ErrorData> error);
typedef gpiodp_supports_reconfiguration_native_t = Int32 Function(Pointer<Int32> result, Pointer<ErrorData> error);