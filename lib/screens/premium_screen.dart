import 'package:flutter/material.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';

class PremiumScreen extends StatelessWidget {
  final HavenTheme theme;

  const PremiumScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final s = S.current;
    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: t.headerBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          s.premiumBadge,
          style: TextStyle(
            color: t.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current status card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.surface,
              border: Border.all(color: t.headerBorder),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Text(
                  s.premiumCurrentStatus,
                  style: TextStyle(
                    letterSpacing: 1.5,
                    color: t.textSubtle,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.premiumFreeLabel,
                  style: TextStyle(
                    color: t.urgent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Features
          _featureRow(t, s.premiumFeatureUnlimited),
          _featureRow(t, s.premiumFeatureAllTopics),
          _featureRow(t, s.premiumFeatureDarkMode),
          _featureRow(t, s.premiumFeatureLifetime),
          const SizedBox(height: 20),

          // Tier buttons
          _buildTierButton(context, t, '\$5', s.premiumTier1),
          const SizedBox(height: 8),
          _buildTierButton(context, t, '\$10', s.premiumTier2),
          const SizedBox(height: 8),
          _buildTierButton(context, t, '\$20', s.premiumTier3),
          const SizedBox(height: 16),

          Text(
            s.premiumTierNote,
            style: TextStyle(
              fontSize: 11,
              color: t.textSubtle,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Restore purchase
          Center(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.comingSoon)),
                );
              },
              child: Text(
                s.restorePurchase,
                style: TextStyle(
                  color: t.textMuted,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(HavenTheme t, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('✓ ', style: TextStyle(color: t.primary, fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: t.textPrimary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierButton(
      BuildContext context, HavenTheme t, String price, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.comingSoon)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: t.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
