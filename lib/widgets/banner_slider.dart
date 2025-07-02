import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final List<Map<String, String>> banners = [
    {
      "title": "Farm Fresh Fridays",
      "subtitle": "Upto 30% Off on Traditional Rice",
      "color": "#588036", // Deep green
      "image": "https://cdn-icons-png.flaticon.com/512/679/679922.png",
      "farmer": "https://cdn-icons-png.flaticon.com/512/219/219983.png",
    },
    {
      "title": "New Kurakkan Harvest",
      "subtitle": "Support Local Farmers",
      "color": "#345630", // Lighter green
      "image": "https://cdn-icons-png.flaticon.com/512/3132/3132693.png",
      "farmer": "https://cdn-icons-png.flaticon.com/512/921/921089.png",
    },
    {
      "title": "Healthy Choice",
      "subtitle": "Low-GI Rice for Diabetics",
      "color": "#809C11", // Dark green
      "image": "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
      "farmer": "https://cdn-icons-png.flaticon.com/512/219/219970.png",
    },
  ];

  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage++;
        if (_currentPage >= banners.length) {
          _currentPage = 0;
        }
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _controller,
        itemCount: banners.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(
                  int.parse("0xFF${banner["color"]!.replaceAll("#", "")}"),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Farmer photo
                  CircleAvatar(
                    backgroundImage: banner['farmer'] != null
                        ? NetworkImage(banner['farmer']!)
                        : const AssetImage('images/default_farmer.png')
                              as ImageProvider,
                    radius: 28,
                    backgroundColor: Colors.white,
                  ),

                  const SizedBox(width: 12),
                  // Left text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner['subtitle']!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 247, 255, 98),
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "👨‍🌾 Direct from our trusted farmers",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      banner['image']!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
