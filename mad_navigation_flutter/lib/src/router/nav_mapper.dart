import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A class-container for organizing route builders of a specific type [T].
///
/// This class groups related route builders together, making it easier to manage
/// different types of navigation routes (pages, dialogs, bottom sheets) separately.
class MadNavMapper<T extends AnyNavRoute> {
  /// Creates a [MadNavMapper] with the given list of route builders.
  const MadNavMapper({required this.routes});

  /// The list of route builders that define how to process the navigation routes.
  final List<MadRouteBuilder<T>> routes;
}

/// A mapper specifically for handling standard page navigation routes.
///
/// This class extends [MadNavMapper] to work with [NavPage] routes, which are used
/// to navigate the application across regular pages.
class PageMapper extends MadNavMapper<NavPage<dynamic>> {
  PageMapper({required super.routes});
}

/// A mapper specifically for handling tab-based holder navigation routes.
///
/// This class extends [MadNavMapper] to work with [NavTabHolder] routes, which are
/// used to navigate through pages in the application via tabs.
class TabHolderMapper extends MadNavMapper<NavTabHolder<dynamic>> {
  TabHolderMapper({required super.routes});
}

/// A mapper specifically for handling dialog navigation routes.
///
/// This class extends [MadNavMapper] to work with [NavDialog] routes, which are
/// used for showing dialog boxes in the application.
class DialogMapper extends MadNavMapper<NavDialog<dynamic>> {
  DialogMapper({required super.routes});
}

/// A mapper specifically for handling bottom sheet navigation routes.
///
/// This class extends [MadNavMapper] to work with [NavBottomSheet] routes, which
/// are used for showing bottom sheets in the application.
class BottomSheetMapper extends MadNavMapper<NavBottomSheet<dynamic>> {
  BottomSheetMapper({required super.routes});
}
