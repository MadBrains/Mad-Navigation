part of 'navigation_state.dart';

typedef TabType = MadTabType;

final class CounterTabType extends MadTabType {
  const CounterTabType();

  @override
  String get name => 'Counter';
}

final class NavMethodsTabType extends TabType {
  const NavMethodsTabType();

  @override
  String get name => 'Nav methods';
}

final class ScrollableContentTabType extends TabType {
  const ScrollableContentTabType();

  @override
  String get name => 'Scrollable';
}

final class ProfileTabType extends TabType {
  const ProfileTabType();

  @override
  String get name => 'Profile';
}
