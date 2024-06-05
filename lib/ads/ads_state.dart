import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnit =>
      Platform.isAndroid ? "ca-app-pub-7773921726550098/1593286605" : '';

  String get nativeAdUnit =>
      Platform.isAndroid ? "ca-app-pub-3940256099942544/2247696110" : '';

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
      onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
      onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}'),
      onAdFailedToLoad: ((ad, error) =>
          print('Ad failed to load: ${ad.adUnitId}, $error')),
      onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}'),
      onAdClicked: (ad) => print('Ad was clicked ${ad.adUnitId}'));
}
//"ca-app-pub-3940256099942544/2247696110" native advanced
//"ca-app-pub-3940256099942544/6300978111" fixed sized banner
//"ca-app-pub-3940256099942544/9214589741" adaptive banner
//"ca-app-pub-3940256099942544/9214589741" test
//"ca-app-pub-7773921726550098/1593286605" id