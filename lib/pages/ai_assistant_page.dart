import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../data/mock_data.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({Key? key}) : super(key: key);

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'Ciao! I am your Urbino AI Assistant. How can I help you find your perfect home today?',
      'isUser': false
    },
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Mock AI Response with typing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      String response = MockData.aiResponses['default']!;
      final lowerText = text.toLowerCase();

      if (lowerText.contains('budget') ||
          lowerText.contains('price') ||
          lowerText.contains('cheap')) {
        response = MockData.aiResponses['budget']!;
      } else if (lowerText.contains('uni') ||
          lowerText.contains('department') ||
          lowerText.contains('distance') ||
          lowerText.contains('faculty')) {
        response = MockData.aiResponses['department']!;
      } else if (lowerText.contains('amenities') ||
          lowerText.contains('wifi') ||
          lowerText.contains('kitchen') ||
          lowerText.contains('internet')) {
        response = MockData.aiResponses['amenities']!;
      } else if (lowerText.contains('hello') || lowerText.contains('hi')) {
        response =
            "Salve! I am here to assist you with your housing search in Urbino. Are you looking for a room, a studio, or perhaps something near the city center?";
      } else if (lowerText.contains('thank')) {
        response =
            "Prego! It is my pleasure to help. Feel free to ask anything else about student life or apartments.";
      }

      setState(() {
        _isTyping = false;
        _messages.add({'text': response, 'isUser': false});
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 Urbino AI Assistant'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: UrbinoGradients.primaryButton(context),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isUser']);
              },
            ),
          ),
          _buildQuickActions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? UrbinoColors.darkSurface
              : UrbinoColors.offWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: const [UrbinoShadows.soft],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("AI is thinking", style: UrbinoTextStyles.smallText(context)),
            const SizedBox(width: 8),
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    UrbinoColors.gold.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? UrbinoColors.darkBlue
              : (Theme.of(context).brightness == Brightness.dark
                  ? UrbinoColors.darkSurface
                  : UrbinoColors.offWhite),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: const [UrbinoShadows.soft],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : UrbinoColors.darkGray),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _quickAction('💰 Budget tips'),
          _quickAction('📍 Near my faculty'),
          _quickAction('📶 Best WiFi'),
          _quickAction('🏠 Private Studios'),
        ],
      ),
    );
  }

  Widget _quickAction(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: () => _sendMessage(label),
        backgroundColor: UrbinoColors.gold.withOpacity(0.1),
        labelStyle: const TextStyle(
            color: UrbinoColors.darkBlue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your question...',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : UrbinoColors.paleBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: UrbinoColors.darkBlue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
