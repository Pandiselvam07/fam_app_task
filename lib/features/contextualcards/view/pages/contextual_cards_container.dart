import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/card_group_model.dart';
import '../widgets/card_group_widget.dart';

class ContextualCardsContainer extends StatefulWidget {
  const ContextualCardsContainer({Key? key}) : super(key: key);

  @override
  _ContextualCardsContainerState createState() =>
      _ContextualCardsContainerState();
}

class _ContextualCardsContainerState extends State<ContextualCardsContainer>
    with TickerProviderStateMixin {
  List<CardGroup> cardGroups = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Set<String> dismissedCards = {};
  Set<String> remindLaterCards = {};
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed && mounted) {
        _loadDismissedCards();
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadDismissedCards() async {
    if (_disposed) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!_disposed && mounted) {
        setState(() {
          dismissedCards =
              prefs.getStringList('dismissed_cards')?.toSet() ?? {};
          remindLaterCards =
              prefs.getStringList('remind_later_cards')?.toSet() ?? {};
        });
      }
    } catch (e) {
      print('Error loading dismissed cards: $e');
    }
  }

  Future<void> _saveDismissedCards() async {
    if (_disposed) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('dismissed_cards', dismissedCards.toList());
      await prefs.setStringList(
        'remind_later_cards',
        remindLaterCards.toList(),
      );
    } catch (e) {
      print('Error saving dismissed cards: $e');
    }
  }

  Future<void> _fetchData() async {
    if (_disposed) return;

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          hasError = false;
        });
      }

      final response = await http.get(
        Uri.parse(
          'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage',
        ),
      );

      if (_disposed) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final homeSection = data[0];
          final List<dynamic> hcGroups = homeSection['hc_groups'] ?? [];

          if (!_disposed && mounted) {
            setState(() {
              cardGroups = hcGroups
                  .map((group) => CardGroup.fromJson(group))
                  .toList();
              isLoading = false;
            });
          }
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (!_disposed && mounted) {
        setState(() {
          hasError = true;
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    if (_disposed) return;

    // Clear remind later cards on refresh (show them again)
    remindLaterCards.clear();
    await _saveDismissedCards();
    await _fetchData();
  }

  void _dismissCard(String cardName, bool permanently) async {
    if (_disposed) return;

    if (mounted) {
      setState(() {
        if (permanently) {
          dismissedCards.add(cardName);
        } else {
          remindLaterCards.add(cardName);
        }
        // Remove groups that contain dismissed cards
        cardGroups = cardGroups
            .where(
              (group) => !group.cards.any(
                (card) =>
                    dismissedCards.contains(card.name) ||
                    remindLaterCards.contains(card.name),
              ),
            )
            .toList();
      });
    }
    await _saveDismissedCards();
  }

  @override
  Widget build(BuildContext context) {
    if (_disposed) {
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Error loading data'),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchData, child: const Text('Retry')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        itemCount: cardGroups.length,
        itemBuilder: (context, index) {
          return CardGroupWidget(
            cardGroup: cardGroups[index],
            onDismissCard: _dismissCard,
          );
        },
      ),
    );
  }
}
