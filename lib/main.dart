import 'package:flutter/material.dart';
import 'ai_service.dart';

void main() {
  runApp(const SurvivalSentinelApp());
}

class SurvivalSentinelApp extends StatelessWidget {
  const SurvivalSentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survival Sentinel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Courier',
        scaffoldBackgroundColor: const Color(0xFFD6D9D0),
      ),
      home: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const ChatScreen(),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  
  bool _isSOSActive = false;
  bool _isLoading = false;
  bool _isModelLoaded = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  Future<void> _initializeAI() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _aiService.initialize();
      setState(() {
        _isModelLoaded = true;
        _isLoading = false;
      });
      
      // Hoş geldin mesajı
      _addMessage(ChatMessage(
        text: 'Survival Sentinel online. I\'m here to help in emergencies. What do you need?',
        isUser: false,
      ));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to load AI model: $e');
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_isModelLoaded) return;

    _messageController.clear();
    
    // Kullanıcı mesajını ekle
    _addMessage(ChatMessage(text: text, isUser: true));

    setState(() {
      _isLoading = true;
    });

    try {
      // AI cevabını al
      final response = await _aiService.generateResponse(text);
      
      setState(() {
        _isLoading = false;
      });
      
      // AI cevabını ekle
      _addMessage(ChatMessage(text: response, isUser: false));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDivider(),
            Expanded(
              child: _isModelLoaded
                  ? _buildChatArea()
                  : _buildLoadingScreen(),
            ),
            if (_isModelLoaded) _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF2E402F),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading AI model...\nThis may take a minute.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator();
        }
        
        final message = _messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: message.isUser
              ? _buildUserMessage(message.text)
              : _buildAIResponse(message.text),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            'Thinking...',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLighthouseIcon(),
              const SizedBox(width: 12),
              const Text(
                'Survival Sentinel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E402F),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.settings,
                color: Colors.grey[700],
                size: 22,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSOSActive = !_isSOSActive;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD67B37),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'OFFLINE AI',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF2E402F),
              fontFamily: 'Courier',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLighthouseIcon() {
    return CustomPaint(
      size: const Size(40, 40),
      painter: LighthousePainter(),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF2E402F),
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E402F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Courier',
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildAIResponse(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF2E402F),
            fontFamily: 'Courier',
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDD3),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(
                    color: Color(0xFF8B7D6B),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2E402F),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class LighthousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Sarı ışık çizgileri - sol
    paint.color = const Color(0xFFF8E58A);
    canvas.drawRect(Rect.fromLTWH(0, size.height / 2 - 1, 8, 2), paint);
    canvas.drawRect(Rect.fromLTWH(2, size.height / 2 - 8, 6, 2), paint);
    canvas.drawRect(Rect.fromLTWH(2, size.height / 2 + 6, 6, 2), paint);

    // Sarı ışık çizgileri - sağ
    canvas.drawRect(Rect.fromLTWH(size.width - 8, size.height / 2 - 1, 8, 2), paint);
    canvas.drawRect(Rect.fromLTWH(size.width - 8, size.height / 2 - 8, 6, 2), paint);
    canvas.drawRect(Rect.fromLTWH(size.width - 8, size.height / 2 + 6, 6, 2), paint);

    // Deniz feneri gövdesi
    paint.color = const Color(0xFF2E402F);
    final path = Path();
    path.moveTo(size.width / 2 - 4, size.height - 5);
    path.lineTo(size.width / 2 - 3, size.height / 2 + 5);
    path.lineTo(size.width / 2 + 3, size.height / 2 + 5);
    path.lineTo(size.width / 2 + 4, size.height - 5);
    path.close();
    canvas.drawPath(path, paint);

    // Deniz feneri üst kısım (ışık odası)
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 4, size.height / 2, 8, 6),
      paint,
    );

    // Sarı ışık
    paint.color = const Color(0xFFF8E58A);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 + 3),
      3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
