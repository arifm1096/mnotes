import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../services/ad_helper.dart';

class IklanBanner extends StatefulWidget {
  const IklanBanner({super.key});

  @override
  State<IklanBanner> createState() => _IklanBannerState();
}

class _IklanBannerState extends State<IklanBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner Ad Loaded: ${ad.adUnitId}');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Banner Ad Failed to Load: ${ad.adUnitId}, Error: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 50, // Tinggi standar banner AdMob
      color: const Color.fromARGB(76, 238, 238, 238), // Warna abu-abu sementara
      alignment: Alignment.center,
      child: Text('Loading Iklan...', style: TextStyle(color: Colors.grey)),
    );// Tidak memakan ruang jika iklan gagal dimuat
  }
}
