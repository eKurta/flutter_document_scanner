// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

/// Default AppBar of the Crop Photo page
class AppBarCropPhoto extends StatelessWidget {
  /// Create a widget with style
  const AppBarCropPhoto({
    super.key,
    required this.cropPhotoDocumentStyle,
  });

  /// The style of the page
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  @override
  Widget build(BuildContext context) {
    if (cropPhotoDocumentStyle.hideAppBarDefault) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context
                  .read<DocumentScannerController>()
                  .changePage(AppPages.takePhoto),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Retake',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E8FDA),
                  ),
                ),
              ),
            ),

            // * Crop photo
            GestureDetector(
              onTap: () {
                context.read<DocumentScannerController>().cropPhoto();
                context
                    .read<DocumentScannerController>()
                    .changePage(AppPages.takePhoto);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  cropPhotoDocumentStyle.textButtonSave,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E8FDA),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
