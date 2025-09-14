import 'package:flutter/material.dart';
import '../../models/chat_message.dart';

class MessageBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: _buildMessageContainer(),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: message.isLoading 
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            child: const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        : message.isError
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[400],
              ),
              child: const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            )
          : ClipOval(
              child: Image.asset(
                'assets/images/daniel.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4DB6AC).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/fat_donkey.jpg',
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMessageContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isUser 
          ? const Color(0xFF4DB6AC)
          : (message.isError ? Colors.red[50] : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: message.isUser 
          ? null 
          : Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: message.isUser 
              ? const Color(0xFF4DB6AC).withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isLoading && !message.isUser) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (message.isError && !message.isUser) ...[
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 8),
          ],
          if (message.text.isNotEmpty)
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser 
                  ? Colors.white 
                  : (message.isError ? Colors.red[700] : const Color(0xFF37474F)),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (message.cardWidget != null) ...[
            if (message.text.isNotEmpty) const SizedBox(height: 8),
            message.cardWidget!,
          ],
        ],
      ),
    );
  }
}