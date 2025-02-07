import 'package:flutter/material.dart';
import 'package:notifye/components/ru_postdetail_videowidget.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:notifye/pages/share_components/share_map_section.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SharePage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String imageUrl;
  final double latitude;
  final double longitude;

  SharePage({
    super.key,
    required this.data,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final String caption = data['caption'] ?? '';
    final String videoUrl = data['videoUrl'] ?? '';

    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _buildMedia(videoUrl, imageUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                child: Text(
                                  caption,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: ShareMapSection(
                      data: data,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareButton(SocialPlatform.whatsapp, FontAwesomeIcons.whatsapp),
                    _buildShareButton(SocialPlatform.facebook, FontAwesomeIcons.facebook),
                  
                    _buildShareButton(SocialPlatform.twitter, FontAwesomeIcons.twitter),
                    _buildShareButton(SocialPlatform.telegram, FontAwesomeIcons.telegram),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(SocialPlatform platform, IconData icon) {
    return IconButton(
      icon: FaIcon(icon, size: 30),
      onPressed: () => _captureAndShare(platform),
    );
  }

  Widget _buildMedia(String videoUrl, String imageUrl) {
    if (videoUrl.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayerWidget(videoUrl: videoUrl),
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _captureAndShare(SocialPlatform platform) async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    
    String mediaPath = await _saveToFile(pngBytes);
    
    await SocialSharingPlus.shareToSocialMediaWithMultipleMedia(
      platform,
      media: [mediaPath],
      content: data['caption'] ?? '',
      isOpenBrowser: false,
      onAppNotInstalled: () async {
        String storeUrl = _getStoreUrl(platform);
        if (await canLaunch(storeUrl)) {
          await launch(storeUrl);
        }
      },
    );
  }

  String _getStoreUrl(SocialPlatform platform) {
    bool isIOS = Platform.isIOS;
    switch (platform) {
      case SocialPlatform.whatsapp:
        return isIOS ? 'https://apps.apple.com/app/whatsapp/id310633997' : 'https://play.google.com/store/apps/details?id=com.whatsapp';
      case SocialPlatform.facebook:
        return isIOS ? 'https://apps.apple.com/app/facebook/id284882215' : 'https://play.google.com/store/apps/details?id=com.facebook.katana';
    
       
      case SocialPlatform.twitter:
        return isIOS ? 'https://apps.apple.com/app/twitter/id333903271' : 'https://play.google.com/store/apps/details?id=com.twitter.android';
      case SocialPlatform.telegram:
        return isIOS ? 'https://apps.apple.com/app/telegram-messenger/id686449807' : 'https://play.google.com/store/apps/details?id=org.telegram.messenger';
      default:
        return isIOS ? 'https://apps.apple.com/' : 'https://play.google.com/store';
    }
  }

  Future<String> _saveToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/shared_image.png').create();
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
