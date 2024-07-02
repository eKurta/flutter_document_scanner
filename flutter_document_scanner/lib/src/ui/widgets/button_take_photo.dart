// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

/// Default button that takes the photo
class ButtonTakePhoto extends StatelessWidget {
  /// Create a widget
  const ButtonTakePhoto({
    super.key,
    required this.takePhotoDocumentStyle,
  });

  /// The style of the page
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  @override
  Widget build(BuildContext context) {
    if (takePhotoDocumentStyle.hideDefaultButtonTakePicture) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => context.read<DocumentScannerController>().takePhoto(),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
