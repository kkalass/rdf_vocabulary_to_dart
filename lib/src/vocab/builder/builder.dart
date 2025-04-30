// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'vocabulary_builder.dart';

// Export builder factory for build_runner
Builder vocabularyBuilder(BuilderOptions options) => const VocabularyBuilder();
