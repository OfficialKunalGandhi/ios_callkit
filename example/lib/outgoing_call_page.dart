import 'package:flutter/material.dart';
import 'package:ios_callkit/ios_callkit.dart';
import 'package:uuid/uuid.dart';

class OutgoingCallPage extends StatefulWidget {
  static const routeName = '/outgoing_call_page';

  @override
  _OutgoingCallPageState createState() => _OutgoingCallPageState();
}

class _OutgoingCallPageState extends State<OutgoingCallPage> {
  final voIPKit = IOSCallKit.instance;
  bool isOutgoing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤙 Your Caller'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: isOutgoing
                ? const Text(
                    '🤙 Calling the callee device.\n\nNotifies the callee device of VoIP notifications if there is a server to post to APNs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : const Text(
                    '👇 Tap to start call to the callee device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(isOutgoing ? Icons.cancel : Icons.call),
        label: Text(
          isOutgoing ? 'Cancel call' : 'Start call',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: isOutgoing ? Colors.red : Colors.blue,
        onPressed: () async {
          (isOutgoing)
              ? await voIPKit.endCall()
              : await voIPKit.startCall(
                  uuid: Uuid().v4(),
                  targetName: 'Dummy Tester',
                );
          setState(() {
            isOutgoing = !isOutgoing;
          });
        },
      ),
    );
  }
}
