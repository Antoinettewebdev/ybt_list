import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../core/constants/google_auth_config.dart';

/// Single-page app: Google login → profile form → global real-time chat.
class GlobalChatPage extends StatefulWidget {
  const GlobalChatPage({super.key});

  @override
  State<GlobalChatPage> createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: GoogleAuthConfig.webClientId,
  );

  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  User? _user;
  bool _initializing = true;
  bool _busy = false;
  bool _profileComplete = false;
  String? _error;
  DateTime? _dateOfBirth;

  static const _usersCollection = 'users';
  static const _messagesCollection = 'messages';

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(_onAuthChanged);
    final current = _auth.currentUser;
    if (current != null) {
      _onAuthChanged(current);
    } else {
      _initializing = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onAuthChanged(User? user) async {
    setState(() {
      _user = user;
      _error = null;
      if (user == null) {
        _profileComplete = false;
        _initializing = false;
      }
    });
    if (user != null) {
      await _checkProfile(user.uid);
    }
  }

  Future<void> _checkProfile(String uid) async {
    setState(() {
      _initializing = true;
      _error = null;
    });
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(uid).get();
      final data = doc.data();
      final name = data?['name'] as String?;
      final hasProfile = doc.exists &&
          name != null &&
          name.isNotEmpty &&
          data?['dateOfBirth'] != null;

      if (mounted) {
        setState(() {
          _profileComplete = hasProfile;
          _initializing = false;
          if (hasProfile) {
            _nameController.text = name;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load profile: $e';
          _initializing = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw Exception(
          'No ID token from Google. Add your app SHA-1 in Firebase Console, '
          're-download google-services.json, then run: flutter clean && flutter run',
        );
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Sign-in failed.');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }
    if (_dateOfBirth == null) {
      setState(() => _error = 'Please select your date of birth.');
      return;
    }
    final uid = _user?.uid;
    if (uid == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _firestore.collection(_usersCollection).doc(uid).set(
        {
          'name': name,
          'dateOfBirth': Timestamp.fromDate(_dateOfBirth!),
          'email': _user!.email,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      setState(() => _profileComplete = true);
    } catch (e) {
      setState(() => _error = 'Could not save profile: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    final email = _user?.email;
    if (text.isEmpty || email == null) return;

    setState(() => _busy = true);
    try {
      await _firestore.collection(_messagesCollection).add({
        'text': text,
        'email': email,
        'uid': _user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    } catch (e) {
      setState(() => _error = 'Could not send message: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream() {
    return _firestore
        .collection(_messagesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Sending…';
    return DateFormat.yMMMd().add_jm().format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return _buildSignIn(context);
    }

    if (!_profileComplete) {
      return _buildProfileForm(context);
    }

    return _buildChat(context);
  }

  Widget _buildSignIn(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'YBT Global Chat',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in with Google to continue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
              FilledButton.icon(
                onPressed: _busy ? null : _signInWithGoogle,
                icon: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome! Tell us a bit about you.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickDateOfBirth,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _dateOfBirth == null
                      ? 'Select date of birth'
                      : DateFormat.yMMMMd().format(_dateOfBirth!),
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 16),
              ],
              FilledButton(
                onPressed: _busy ? null : _saveProfile,
                child: _busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue to chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    final displayName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : (_user?.displayName ?? 'Chat');

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _busy ? null : _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(
                  onPressed: () => setState(() => _error = null),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hello!'),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final text = data['text'] as String? ?? '';
                    final email = data['email'] as String? ?? 'Unknown';
                    final createdAt =
                        data['createdAt'] as Timestamp?;
                    final isMine = email == _user?.email;

                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              email,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(text),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(createdAt),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message…',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _busy ? null : (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _busy ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
