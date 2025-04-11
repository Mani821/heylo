import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heylo/const/data.dart';
import 'package:heylo/screens/home/change_model_view.dart';
import 'package:heylo/screens/home/history_view.dart';
import 'package:heylo/service/app_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/app_colors.dart';
import '../../service/ai_service.dart';
import '../../service/menu_service.dart';
import '../../widgets/helo_loading.dart';
import '../../widgets/menu_button.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late AnimationController buttonController;
  final color = Color(0xFF14213d);
  final tileColor = Color(0xFFfca311);
  bool showMenu = false;
  late TabController tabController;
  int currentIndex = 0;
  final AIService _aiService = AIService();
  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _chatHistory = [];
  bool _isLoading = false;
  final scrollController = ScrollController();
  late AnimationController _typingController;
  final List<String> _typingDots = [".", "..", "..."];
  int _typingIndex = 0;

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(vsync: this, duration: 60.ms);
    controller = AnimationController(vsync: this, duration: 1.seconds);
    animation = Tween<double>(begin: 6.0, end: 1.6).animate(buttonController);
    tabController = TabController(length: 3, vsync: this);
    _typingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
      if (_typingController.status == AnimationStatus.completed) {
        _typingController.reset();
        setState(() {
          _typingIndex = (_typingIndex + 1) % _typingDots.length;
        });
        if (_isLoading) {
          _typingController.forward();
        }
      }
    });

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          currentIndex = tabController.index;
        });
      }
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showMenu = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          showMenu = false;
        });
      }
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _chatController.text.trim();
    if (messageText.isEmpty) {
      return; // Don't send empty messages
    }

    // Add user message to UI immediately
    setState(() {
      _chatHistory.add(ChatMessage(role: 'user', content: messageText));
      _isLoading = true; // Show loading indicator
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Start typing animation
    _typingController.forward();

    _chatController.clear(); // Clear the input field

    try {
      // Prepare history (you might want to limit its length for performance/cost)
      List<ChatMessage> historyForApi = List.from(_chatHistory);
      historyForApi.removeLast(); // Remove the user message we just added to UI

      final aiResponse = await _aiService.sendMessage(
        // Use a system prompt to define the chatbot's personality if desired
        systemPrompt: "You are Heylo, a friendly and helpful assistant.",
        conversationHistory:
            historyForApi, // Send history *before* the current user message
        userMessage: messageText, // Send the actual user message text
        // You could potentially get the model from your state if user can change it
        // model: _selectedModel,
      );

      // Add AI response to UI and stop loading
      setState(() {
        _chatHistory.add(ChatMessage(role: 'assistant', content: aiResponse));
        _isLoading = false; // Hide loading indicator
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      _typingController.stop();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _chatHistory.add(
          ChatMessage(
            role: 'system',
            content: 'Error: Could not get response. $e',
          ),
        );
      });
      _typingController.stop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting AI response: $e')));
      debugPrint("Error sending message: $e"); // Log for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> allMessages = List.from(
      _chatHistory.map((message) {
        return _buildMessageBubble(message);
      }),
    );

    if (_isLoading) {
      allMessages.add(_buildLoading());
    }

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFeaf4f4),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: showMenu ? color : Color(0xFFeaf4f4),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFeaf4f4),
        appBar: AppBar(
          backgroundColor: color,
          title: AnimatedSwitcher(
            duration: 200.ms,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              key: ValueKey(currentIndex),
              currentIndex == 0
                  ? 'Heylo'
                  : currentIndex == 1
                  ? "Change Model"
                  : "Chat History",
              style: GoogleFonts.bungee(color: Colors.white),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              if (currentIndex != 0) {
                tabController.animateTo(0);
                return;
              }
              if (controller.status == AnimationStatus.completed) {
                controller.reverse();
                tabController.animateTo(0);
                setState(() {
                  showMenu = false;
                });
              } else {
                controller.forward();
                setState(() {
                  showMenu = true;
                });
              }
            },
            icon: AnimatedCrossFade(
              firstChild: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: controller,
                color: Colors.white,
              ),
              secondChild: Icon(Icons.chevron_left_rounded, color: bgColor),
              crossFadeState:
                  currentIndex != 0
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: 300.ms,
            ),
          ),
          actions: [
            if (currentIndex == 0)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _chatHistory.clear();
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/new.svg',
                    colorFilter: ColorFilter.mode(
                      Color(0xFFeaf4f4),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (_chatHistory.isEmpty && !_isLoading)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to Heylo!',
                            style: GoogleFonts.bungee(fontSize: 20),
                          ),
                          Text(
                            "What's on your mind today?",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(8.0),
                      children: allMessages,
                    ),
                  ),

                // Chat input row
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'splash',
                          child: SvgPicture.asset(
                            'assets/icons/icon.svg',
                            height: 36,
                            width: 36,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CupertinoTextField(
                            controller: _chatController,
                            placeholder: 'Ask me anything...',
                            placeholderStyle: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            cursorColor: Color(0xFF14213d),
                            cursorHeight: 15,
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF14213d),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFeaf4f4),
                              border: Border.all(color: Color(0xFF14213d)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if (_chatController.text.isNotEmpty) {
                              _sendMessage();
                            }
                          },
                          child: AnimatedContainer(
                            duration: 200.ms,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF14213d),
                            ),
                            child: Center(
                              child: Transform.translate(
                                offset: Offset(0, 2),
                                child: Transform.rotate(
                                  angle: 49.5,
                                  child: Icon(
                                    CupertinoIcons.paperplane_fill,
                                    size: 18,
                                    color: Color(0xFFeaf4f4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -50,
              left: -10,
              child: IgnorePointer(
                child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: color,
                      ),
                    )
                    .animate(autoPlay: false, controller: controller)
                    .scaleXY(
                      alignment: Alignment.topLeft,
                      end: 6,
                      duration: 800.ms,
                      curve: Curves.easeInOutCirc,
                    ),
              ),
            ),
            Positioned(
              top: -60,
              right: -60,
              child: IgnorePointer(
                child: Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: color,
                      ),
                    )
                    .animate(autoPlay: false, controller: controller)
                    .scaleXY(
                      alignment: Alignment.topRight,
                      end: 5,
                      duration: 800.ms,
                      curve: Curves.easeInOutCirc,
                    ),
              ),
            ),
            Positioned(
              left: -300,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: color,
                      ),
                    )
                    .animate(autoPlay: false, controller: controller)
                    .scaleXY(
                      alignment: Alignment.bottomLeft,
                      end: 6,
                      duration: 800.ms,
                      curve: Curves.easeInOutCirc,
                    ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: IgnorePointer(
                child: Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: color,
                      ),
                    )
                    .animate(autoPlay: false, controller: controller)
                    .scaleXY(
                      alignment: Alignment.bottomRight,
                      end: 5,
                      duration: 800.ms,
                      curve: Curves.easeInOutCirc,
                    ),
              ),
            ),
            if (showMenu)
              TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final delay = (index * 150).ms;
                        return MenuButton(
                              onTap: () async {
                                if (index == 0) {
                                  tabController.animateTo(1);
                                } else if (index == 1) {
                                  tabController.animateTo(2);
                                } else if (index == 2) {
                                  if (await canLaunchUrl(
                                    Uri.parse(linkedInUrl),
                                  )) {
                                    await launchUrl(Uri.parse(linkedInUrl));
                                  }
                                } else {
                                  if (await canLaunchUrl(
                                    Uri.parse(githubUrl),
                                  )) {
                                    await launchUrl(Uri.parse(githubUrl));
                                  }
                                }
                              },
                              text: menuItems[index].title,
                              imagePath: menuItems[index].imagePath,
                            )
                            .animate(target: showMenu ? 1 : 0, autoPlay: false)
                            .scaleXY(
                              alignment: Alignment.centerLeft,
                              delay: delay,
                              duration: 800.ms,
                              curve: Curves.easeInOutQuint,
                            );
                      }),
                    ),
                  ),
                  ChangeModelView(),
                  HistoryView(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final parts = _parseMixedContent(message.content);
    return Align(
      alignment:
          message.role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: message.role == 'user' ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              parts.map((part) {
                if (part['type'] == 'html') {
                  return HtmlWidget(part['content'] ?? '');
                } else {
                  return SelectableText(
                    part['content'] ?? '',
                    style: TextStyle(
                      color:
                          message.role == 'user'
                              ? Colors.white
                              : Colors.black87,
                      fontFamily: 'Lexend',
                    ),
                  );
                }
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    if (!_typingController.isAnimating && _isLoading) {
      _typingController.forward();
    }

    return Align(alignment: Alignment.centerLeft, child: HeyloLoading());
  }

  List<Map<String, String>> _parseMixedContent(String text) {
    final regex = RegExp(r'```html\s*([\s\S]*?)```', multiLine: true);
    final matches = regex.allMatches(text);
    final parts = <Map<String, String>>[];

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        parts.add({
          'type': 'text',
          'content': text.substring(lastIndex, match.start),
        });
      }

      parts.add({'type': 'html', 'content': match.group(1)?.trim() ?? ''});

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      parts.add({'type': 'text', 'content': text.substring(lastIndex)});
    }

    return parts;
  }

  @override
  void dispose() {
    _chatController.dispose();
    _typingController.dispose();
    controller.dispose();
    buttonController.dispose();
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
