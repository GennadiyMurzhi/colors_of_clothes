part of 'camera_cubit.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    required final bool controllerIsInitialized,
    required final bool isEnabledPhotoButton,
    required final bool isEnabledFlashButton,
    required final bool isEnabledSwitchButton,
    required final bool isCameraNotSwitched,
    required final bool isSwitchButtonRotated,
    required final List<IconData> flashIconList,
    required final Uint8List? capturePreview,
  }) = _CameraState;

  factory CameraState.initial() => const CameraState(
        controllerIsInitialized: false,
        isEnabledPhotoButton: true,
        isEnabledFlashButton: true,
        isEnabledSwitchButton: true,
        isCameraNotSwitched: true,
        isSwitchButtonRotated: false,
        flashIconList: <IconData>[],
        capturePreview: null,
      );
}
