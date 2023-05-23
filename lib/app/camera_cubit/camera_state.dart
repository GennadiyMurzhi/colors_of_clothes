part of 'camera_cubit.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    required final bool isInit,
    required final bool isCameraNotSwitched,
    required final bool isSwitchButtonRotated,
    required final List<IconData> flashIconList,
    required final Size previewSize,
    required final Uint8List? imageToRotate,
    required final bool isDisplayPreview,
    required final bool isDisplayImageToRotate,
    required final bool isEnabledButtons,
    required final bool needBlur,
  }) = _CameraState;

  factory CameraState.initial() => const CameraState(
        isInit: false,
        isCameraNotSwitched: true,
        isSwitchButtonRotated: false,
        flashIconList: <IconData>[],
        previewSize: Size.zero,
        imageToRotate: null,
        isDisplayPreview: false,
        isDisplayImageToRotate: false,
        needBlur: false,
        isEnabledButtons: true,
      );
}
