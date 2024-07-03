// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

/// Value to be able to assign null in the copyWith of the models
const valueNull = 'valueNull';

/// Define how the saving function is to be used
typedef OnSave = void Function(Uint8List imageBytes);

/// Define how the keep scan function is to be used
typedef OnKeepScan = void Function(Uint8List imageBytes);

/// Define how the add more function is to be used
typedef OnAddMore = void Function(Uint8List imageBytes);
