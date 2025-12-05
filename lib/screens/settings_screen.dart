import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Consumer4<
        SettingsProvider,
        ThemeProvider,
        LanguageProvider,
        AuthProvider
      >(
        builder: (context, settings, theme, language, authProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // قسم المظهر
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.darkMode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // الوضع الليلي
                      SwitchListTile(
                        title: Text(l10n.darkMode),
                        value: theme.isDarkMode,
                        onChanged: (value) => theme.toggleTheme(),
                      ),
                      // اختيار اللون الرئيسي
                      Text(l10n.primaryColor),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            settings.availableColors.map((color) {
                              return InkWell(
                                onTap: () => settings.setPrimaryColor(color),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          settings.primaryColor == color
                                              ? Colors.white
                                              : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // قسم الخط
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.fontSize,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // حجم الخط
                      Row(
                        children: [
                          Text(l10n.fontSize),
                          Expanded(
                            child: Slider(
                              value: settings.fontSize,
                              min: 12,
                              max: 32,
                              divisions: 10,
                              label: settings.fontSize.toString(),
                              onChanged: (value) => settings.setFontSize(value),
                            ),
                          ),
                          Text(settings.fontSize.toStringAsFixed(0)),
                        ],
                      ),
                      // نوع الخط
                      Text(l10n.fontType),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            settings.availableFonts.map((font) {
                              return ChoiceChip(
                                label: Text(
                                  l10n.sampleText,
                                  style: TextStyle(fontFamily: font),
                                ),
                                selected: settings.fontFamily == font,
                                onSelected: (selected) {
                                  if (selected) {
                                    settings.setFontFamily(font);
                                  }
                                },
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // قسم المزامنة السحابية
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المزامنة السحابية',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (authProvider.isSignedIn) ...[
                        // معلومات المستخدم
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                authProvider.userPhotoUrl != null
                                    ? NetworkImage(authProvider.userPhotoUrl!)
                                    : null,
                            child:
                                authProvider.userPhotoUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                          ),
                          title: Text(authProvider.userName ?? 'مستخدم'),
                          subtitle: Text(authProvider.userEmail ?? ''),
                        ),

                        const Divider(),

                        // حالة المزامنة
                        if (authProvider.isSyncing)
                          const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('جاري المزامنة...'),
                          )
                        else if (authProvider.lastSyncTime != null)
                          ListTile(
                            leading: const Icon(
                              Icons.cloud_done,
                              color: Colors.green,
                            ),
                            title: const Text('آخر مزامنة'),
                            subtitle: Text(
                              _formatSyncTime(authProvider.lastSyncTime!),
                            ),
                          ),

                        // زر مزامنة يدوية
                        if (!authProvider.isSyncing)
                          ElevatedButton.icon(
                            onPressed: () => authProvider.syncData(),
                            icon: const Icon(Icons.sync),
                            label: const Text('مزامنة الآن'),
                          ),

                        const SizedBox(height: 8),

                        // زر تسجيل الخروج
                        TextButton.icon(
                          onPressed: () => authProvider.signOut(),
                          icon: const Icon(Icons.logout),
                          label: const Text('تسجيل الخروج'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ] else ...[
                        // زر تسجيل الدخول
                        const Text(
                          'سجّل الدخول لمزامنة بياناتك عبر جميع أجهزتك',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed:
                              () => Navigator.pushNamed(context, '/login'),
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('تسجيل الدخول'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // قسم اللغة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.selectLanguage),
                        subtitle: Text(language.currentLanguageName),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showLanguageDialog(context, language),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageProvider languageProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                l10n.arabic,
                'ar',
                languageProvider,
              ),
              _buildLanguageOption(
                context,
                l10n.english,
                'en',
                languageProvider,
              ),
              _buildLanguageOption(
                context,
                l10n.french,
                'fr',
                languageProvider,
              ),
              _buildLanguageOption(context, l10n.urdu, 'ur', languageProvider),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String code,
    LanguageProvider provider,
  ) {
    return RadioListTile<String>(
      title: Text(title),
      value: code,
      groupValue: provider.currentLanguageCode,
      onChanged: (value) {
        if (value != null) {
          provider.setLanguage(value);
          Navigator.of(context).pop();
        }
      },
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'منذ لحظات';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
