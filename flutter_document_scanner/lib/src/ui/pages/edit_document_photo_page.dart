// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_event.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_event.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_state.dart';
import 'package:flutter_document_scanner/src/ui/widgets/app_bar_edit_photo.dart';
import 'package:flutter_document_scanner/src/ui/widgets/bottom_bar_edit_photo.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_document_scanner/src/utils/model_utils.dart';

/// Page to edit a photo
class EditDocumentPhotoPage extends StatelessWidget {
  /// Create a page with style
  const EditDocumentPhotoPage({
    super.key,
    required this.editPhotoDocumentStyle,
    required this.onSave,
    required this.onAddMore,
  });

  /// Style of the page
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  /// Callback to save the photo
  final OnSave onSave;

  /// Calback to add more photos
  final OnAddMore onAddMore;

  ///Photos that user wants to add before the currently scanned photo

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: BlocSelector<AppBloc, AppState, Uint8List?>(
        selector: (state) => state.pictureCropped,
        builder: (context, state) {
          if (state == null) {
            return const Center(
              child: Text('NO IMAGE'),
            );
          }

          return BlocProvider(
            create: (context) => EditBloc(
              imageUtils: ImageUtils(),
            )..add(EditStarted(state)),
            child: _EditView(
              editPhotoDocumentStyle: editPhotoDocumentStyle,
              onSave: onSave,
              onAddMore: onAddMore,
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    await context
        .read<DocumentScannerController>()
        .changePage(AppPages.cropPhoto);
    return false;
  }
}

class _EditView extends StatefulWidget {
  _EditView({
    required this.editPhotoDocumentStyle,
    required this.onSave,
    required this.onAddMore,
  });

  final EditPhotoDocumentStyle editPhotoDocumentStyle;
  final OnSave onSave;

  /// Calback to add more photos
  final OnAddMore onAddMore;

  @override
  State<_EditView> createState() => _EditViewState();
}

class _EditViewState extends State<_EditView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              current.currentFilterType != previous.currentFilterType,
          listener: (context, state) {
            context
                .read<EditBloc>()
                .add(EditFilterChanged(state.currentFilterType));
          },
        ),
        BlocListener<EditBloc, EditState>(
          listenWhen: (previous, current) =>
              current.image != previous.image && previous.image != null,
          listener: (context, state) {
            if (state.image != null) {
              context.read<AppBloc>().add(
                    AppNewEditedImageLoaded(
                      isSuccess: true,
                    ),
                  );
            }
          },
        ),
      ],
      child: Column(
        children: [
          BlocSelector<EditBloc, EditState, Uint8List?>(
            selector: (state) => state.image,
            builder: (context, image) {
              return AppBarEditPhoto(
                editPhotoDocumentStyle: widget.editPhotoDocumentStyle,
                onAddMore: widget.onAddMore,
                image: image,
                onSave: () {
                  widget.onSave(image!);
                },
              );
            },
          ),
          Expanded(
            child: BlocSelector<EditBloc, EditState, Uint8List?>(
              selector: (state) => state.image,
              builder: (context, image) {
                if (image == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Image.memory(image);
              },
            ),
          ),

          // * Default App Bar

          // * Default Bottom Bar
          BottomBarEditPhoto(
            editPhotoDocumentStyle: widget.editPhotoDocumentStyle,
          ),

          // * children
          if (widget.editPhotoDocumentStyle.children != null)
            ...widget.editPhotoDocumentStyle.children!,
        ],
      ),
    );
  }
}
