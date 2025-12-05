import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../widgets/smart_image.dart';
import '../widgets/error_handler_widget.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الراديو',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<RadioProvider>(
        builder: (context, provider, child) {
          final currentStation = provider.currentStation;

          return Column(
            children: [
              // معالجة الأخطاء
              if (provider.errorMessage != null)
                ErrorHandlerWidget(
                  errorMessage: provider.errorMessage,
                  onRetry: () => provider.play(),
                  onDismiss: () => provider.clearError(),
                ),

              // بطاقة المحطة الحالية
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(76),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SmartImage(
                      imagePath: currentStation.image,
                      width: 100,
                      height: 100,
                      fallbackIcon: Icons.radio,
                      iconSize: 60,
                      iconColor: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentStation.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // مؤشر التحميل أو أزرار التحكم
                    if (provider.isLoading)
                      const BufferingIndicator(
                        isBuffering: true,
                        message: 'جاري الاتصال بالمحطة...',
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, size: 40),
                            onPressed: provider.previousStation,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              provider.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              size: 60,
                            ),
                            onPressed: () {
                              if (provider.isPlaying) {
                                provider.pause();
                              } else {
                                provider.play();
                              }
                            },
                            color: Colors.green,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.skip_next, size: 40),
                            onPressed: provider.nextStation,
                            color: Colors.green,
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // قائمة المحطات
              Expanded(
                child: ListView.builder(
                  itemCount: provider.stations.length,
                  itemBuilder: (context, index) {
                    final station = provider.stations[index];
                    final isSelected = index == provider.currentStationIndex;

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.green
                                  : Colors.green.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.radio,
                            color: isSelected ? Colors.white : Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        station.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing:
                          isSelected && provider.isPlaying
                              ? const Icon(Icons.equalizer, color: Colors.green)
                              : null,
                      onTap: () => provider.playStation(index),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
