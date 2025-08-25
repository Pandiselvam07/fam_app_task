import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/card_group_model.dart';
import '../widgets/card_group_widget.dart';

class ContextualCardsContainer extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadDismissedCards();
      _fetchData();
    });
  }

  Future<void> _loadDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dismissedCards = prefs.getStringList('dismissed_cards')?.toSet() ?? {};
      remindLaterCards =
          prefs.getStringList('remind_later_cards')?.toSet() ?? {};
    });
  }

  Future<void> _saveDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dismissed_cards', dismissedCards.toList());
    await prefs.setStringList('remind_later_cards', remindLaterCards.toList());
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final response = await http.get(
        Uri.parse(
          'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final homeSection = data[0];
          final List<dynamic> hcGroups = homeSection['hc_groups'] ?? [];

          setState(() {
            cardGroups = hcGroups
                .map((group) => CardGroup.fromJson(group))
                .toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  bool _shouldFilterGroup(CardGroup group) {
    return group.cards.any((card) => dismissedCards.contains(card.name));
  }

  Future<void> _handleRefresh() async {
    // Clear remind later cards on refresh (show them again)
    remindLaterCards.clear();
    await _saveDismissedCards();
    await _fetchData();
  }

  void _dismissCard(String cardName, bool permanently) async {
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
    await _saveDismissedCards();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Error loading data'),
            SizedBox(height: 8),
            ElevatedButton(onPressed: _fetchData, child: Text('Retry')),
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
