import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A widget that listens for scroll-to-top events and animates the scroll position.
///
/// This widget wraps a scrollable content area and provides automatic scrolling
/// to the top when the associated tab becomes active and a scroll-to-top event
/// is triggered through the navigation service.
///
/// Example usage:
/// ```dart
/// ScrollToTopListener(
///   navigationService: navigationService,
///   tab: navigationService.state.activeTab,
///   builder: (context, scrollController) {
///     return ListView.builder(
///       controller: scrollController,
///       itemCount: 100,
///       itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
///     );
///   },
/// )
/// ```
class ScrollToTopListener extends StatefulWidget {
  /// Creates a new [ScrollToTopListener].
  const ScrollToTopListener({
    super.key,
    required this.navigationService,
    required this.tab,
    required this.builder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.onScrollToTop,
  });

  /// The tab navigation service that manages scroll-to-top events.
  final MadTabNavigationService navigationService;

  /// The tab type this listener is associated with.
  final MadTabType tab;

  /// A builder that creates the scrollable content.
  final Widget Function(BuildContext, ScrollController) builder;

  /// The duration of the scroll animation.
  final Duration animationDuration;

  /// The curve to use for the scroll animation.
  final Curve curve;

  /// An optional callback that will be called instead of the default scroll behavior.
  final VoidCallback? onScrollToTop;

  @override
  State<ScrollToTopListener> createState() => _ScrollToTopListenerState();
}

class _ScrollToTopListenerState extends State<ScrollToTopListener> {
  late final ScrollController scrollController;

  MadTabNavigationService get navigationService => widget.navigationService;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Scrolls to the top of the content with animation.
  ///
  /// If [onScrollToTop] is provided, it will be called instead of the default
  /// scroll behavior.
  void scrollToTop() {
    final void Function()? onScrollToTop = widget.onScrollToTop;
    if (onScrollToTop == null) {
      scrollController.animateTo(
        0,
        duration: widget.animationDuration,
        curve: widget.curve,
      );
    } else {
      onScrollToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationListener<MadTabNavigationState>(
      navigationService: navigationService,
      upon: (MadTabNavigationState state) => <Object?>[
        state.isJumpToTopOnRootPage,
        state.activeTab,
      ],
      listener: (BuildContext context, MadTabNavigationState state, MadTabNavigationState prevState) {
        if (state.activeTab == widget.tab && state.isJumpToTopOnRootPage) {
          scrollToTop();
          navigationService.resetJumpToTopOnRootPage();
        }
      },
      child: widget.builder(context, scrollController),
    );
  }
}
