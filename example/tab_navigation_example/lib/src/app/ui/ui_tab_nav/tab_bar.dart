part of 'ui_main_tab_holder.dart';

class AppTabBar extends StatefulWidget {
  const AppTabBar({Key? key, required this.navigationService}) : super(key: key);

  final TabNavigationService navigationService;

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  TabNavigationState get state => widget.navigationService.state;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: state.activeTabIndex,
      length: state.tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onIndexChanged(TabNavigationState state) {
    _controller.index = state.activeTabIndex;
  }

  void _selectTab(BuildContext context, TabType tab) {
    widget.navigationService.selectTabByUser(tab);
  }

  @override
  Widget build(BuildContext context) {
    final double tabWidth = MediaQuery.sizeOf(context).width / state.tabs.length;

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: NavigationListener<TabNavigationState>(
          navigationService: widget.navigationService,
          listener: (BuildContext context, TabNavigationState state, _) => _onIndexChanged(state),
          upon: (TabNavigationState state) => <Object>[state.activeTab],
          child: TabBar(
            onTap: (int index) => _selectTab(context, state.tabs[index]),
            controller: _controller,
            tabs: <Widget>[
              for (final TabType type in state.tabs)
                AppTabBarItem(
                  width: tabWidth,
                  label: type.getLocalizedLabel(context),
                  icon: type.getIcon(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTabBarItem extends StatelessWidget {
  const AppTabBarItem({Key? key, required this.width, required this.label, required this.icon}) : super(key: key);

  final double width;
  final String label;
  final Widget icon;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Tab(
        text: label,
        icon: SizedBox(height: _size, width: _size, child: icon),
        iconMargin: const EdgeInsets.only(bottom: 4),
      ),
    );
  }
}

extension on TabType {
  String getLocalizedLabel(BuildContext context) => switch (this) {
        CounterTabType() => name,
        NavMethodsTabType() => name,
        ScrollableContentTabType() => name,
        ProfileTabType() => name,
        (_) => throw UnimplementedError(),
      };

  Widget getIcon() => switch (this) {
        CounterTabType() => const Icon(Icons.calculate),
        NavMethodsTabType() => const Icon(Icons.map),
        ScrollableContentTabType() => const Icon(Icons.sledding),
        ProfileTabType() => const Icon(Icons.account_box),
        (_) => throw UnimplementedError(),
      };
}
