import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: TalkPage(
      isConnectedNotifier: ValueNotifier<bool>(false),
      connectedDeviceName: ValueNotifier<String?>(null),
    ),
  ));
}

class TalkPage extends StatefulWidget {
  final ValueNotifier<bool> isConnectedNotifier;
  final ValueNotifier<String?> connectedDeviceName;

  TalkPage({required this.isConnectedNotifier, required this.connectedDeviceName});

  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUserId = 'user1'; // Replace with your logic to get the current user's ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.red[100],
        actions: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
            'Klik tombol tempat sampah untuk mengakhiri percakapan!',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
              SizedBox(width: 8.0),
              Container(
                width: 40.0, // Set the width of the container
                height: 40.0, // Set the height of the container
                decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
                ),
                child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: _endConversation,
            color: Colors.white,
            padding: EdgeInsets.all(0),
                ),
              ),
            ],
          ),
              ),
            ),
          ),
        ],
            ),
      body: Container(
        padding: EdgeInsets.only(top: 0,bottom: 10, right: 10, left: 10),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _messagesRef.orderByChild('timestamp').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    var data = snapshot.data!.snapshot.value;
                    if (data is Map<dynamic, dynamic>) {
                      Map<dynamic, dynamic> messages = data;
                      List<Map<dynamic, dynamic>> messagesList = messages.values.map((e) => e as Map<dynamic, dynamic>).toList();
                      messagesList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          var message = messagesList[index];
                          return ChatBubble(
                            message: message['message'],
                            isCurrentUser: message['senderId'] == currentUserId,
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Unexpected data structure'));
                    }
                  } else {
                    return Center(child: Text('No messages'));
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: () {
                      // Add functionality for the mic button here
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _messagesRef.push().set({
        'message': _messageController.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': currentUserId,
      });
      _messageController.clear();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void _endConversation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Akhiri Percakapan'),
          content: Text('Apakah Anda yakin ingin mengakhiri percakapan? Semua pesan akan dihapus.'),
          actions: [
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                _messagesRef.remove();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  ChatBubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0.5, 0, 0.5), // set vertical margin to 0.5
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Text(
          message,
          style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
