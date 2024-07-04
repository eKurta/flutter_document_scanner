// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_bloc.dart';
import 'package:flutter_document_scanner/src/ui/widgets/button_take_photo.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_document_scanner/src/utils/model_utils.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

/// Page to take a photo
class TakePhotoDocumentPage extends StatelessWidget {
  /// Create a page with style
  const TakePhotoDocumentPage({
    super.key,
    required this.takePhotoDocumentStyle,
    required this.initialCameraLensDirection,
    required this.resolutionCamera,
    required this.onScannerClose,
    required this.onSave,
  });

  /// Style of the page
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  /// Camera library [CameraLensDirection]
  final CameraLensDirection initialCameraLensDirection;

  /// Camera library [ResolutionPreset]
  final ResolutionPreset resolutionCamera;

  final VoidCallback onScannerClose;

  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    context.read<AppBloc>().add(
          AppCameraInitialized(
            cameraLensDirection: initialCameraLensDirection,
            resolutionCamera: resolutionCamera,
          ),
        );

    return BlocProvider(
        create: (context) => EditBloc(
              imageUtils: ImageUtils(),
            ),
        child: BlocSelector<AppBloc, AppState, AppStatus>(
          selector: (state) => state.statusCamera,
          builder: (context, state) {
            switch (state) {
              case AppStatus.initial:
                return Container();

              case AppStatus.loading:
                return takePhotoDocumentStyle.onLoading;

              case AppStatus.success:
                return _CameraPreview(
                  takePhotoDocumentStyle: takePhotoDocumentStyle,
                  onScannerClose: onScannerClose,
                  onSave: onSave,
                );

              case AppStatus.failure:
                return Container();
            }
          },
        ));
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({
    required this.takePhotoDocumentStyle,
    required this.onScannerClose,
    required this.onSave,
  });

  final TakePhotoDocumentStyle takePhotoDocumentStyle;
  final VoidCallback onScannerClose;

  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, CameraController?>(
      selector: (state) => state.cameraController,
      builder: (context, state) {
        if (state == null) {
          return const Center(
            child: Text(
              'No Camera',
            ),
          );
        }

        return ColoredBox(
          color: const Color(0xFF000F1A),
          child: SafeArea(
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // * Camera
                Positioned(
                  top: takePhotoDocumentStyle.top,
                  bottom: takePhotoDocumentStyle.bottom,
                  left: takePhotoDocumentStyle.left,
                  right: takePhotoDocumentStyle.right,
                  child: CameraPreview(state),
                ),

                // * children
                if (takePhotoDocumentStyle.children != null)
                  ...takePhotoDocumentStyle.children!,

                /// Default
                ButtonTakePhoto(
                  takePhotoDocumentStyle: takePhotoDocumentStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
