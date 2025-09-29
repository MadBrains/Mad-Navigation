import 'package:root_navigation_example/src/app/app.dart';

part 'pages.dart';

part 'page_factory_builder.dart';

class RouteMapper extends MadRouteMapper {
  RouteMapper({MadPageFactoryBuilder pageBuilder = const PageFactoryBuilder()}) : super(pageBuilder: pageBuilder);

  @override
  List<MadNavMapper<AnyNavRoute>> get routers => <MadNavMapper<AnyNavRoute>>[
        PageMapper(
          routes: <MadRouteBuilder<NavPage<dynamic>>>[
            MadRouteBuilder<PageLoginTest>((_) => const UiPageLoginTest()),
            MadRouteBuilder<PageItemListTest>((_) => const UiPageItemListTest()),
            MadRouteBuilder<PageProfileTest>((_) => const UiPageProfileTest()),
            MadRouteBuilder<PageCounterTest>((PageCounterTest page) => UiPageCounterTest.fromArgs(page.args)),
            MadRouteBuilder<PageNavMethodsTest<Object?>>(
              (PageNavMethodsTest<Object?> page) => UiPageNavMethodsTest(id: page.id),
            ),
            MadRouteBuilder<PageObjectResultTest>((_) => const UiPageObjectResultTest()),
            MadRouteBuilder<PageUnknown>((_) => const UiPageUnknown()),
          ],
        ),
        DialogMapper(
          routes: <MadRouteBuilder<NavDialog<dynamic>>>[
            MadRouteBuilder<DialogTest>((_) => const UiDialogTest()),
            MadRouteBuilder<DialogUnknown>((_) => const UiDialogUnknown()),
          ],
        ),
        BottomSheetMapper(
          routes: <MadRouteBuilder<NavBottomSheet<dynamic>>>[
            MadRouteBuilder<BottomSheetTest>((_) => const UiBottomSheetTest()),
            MadRouteBuilder<BottomSheetUnknown>((_) => const UiBottomSheetUnknown()),
          ],
        ),
      ];
}
