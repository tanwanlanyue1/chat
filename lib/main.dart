import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/dismiss_keyboard.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'common/app_localization.dart';
import 'common/app_theme.dart';
import 'generated/l10n.dart';
import 'widgets/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
  // AppCatchError.run(() => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenAdapt(
      designSize: const Size(375, 812),
      builder: (_) {
        return FutureBuilder(
          future: Global.initialize(),
          builder: (_, snapshot) {
            if (snapshot.data != true) {
              return Container(
                alignment: Alignment.center,
                color: const Color(0xffF7EFE6),
                child: const LoadingIndicator(),
              );
            }
            return RefreshConfiguration(
              headerBuilder: () => ClassicHeader(
                refreshingIcon: LoadingIndicator(size: 24.rpx),
              ),
              child: DismissKeyboard(
                child: GetMaterialApp(
                  title: '境修',
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  debugShowCheckedModeBanner: false,
                  initialRoute: AppPages.initial,
                  builder: Loading.init(),
                  getPages: AppPages.routes,
                  localizationsDelegates: const [
                    S.delegate,
                    RefreshLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  locale: AppLocalization.instance.locale,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
