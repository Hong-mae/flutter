import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:soul_talk/component/chat_text_field.dart';
import 'package:soul_talk/component/date_divider.dart';
import 'package:soul_talk/component/logo.dart';
import 'package:soul_talk/component/message.dart';
import 'package:soul_talk/model/message_model.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: '오늘 저녁메뉴 추천해줘',
    point: 1,
    date: DateTime(2025, 5, 15),
  ),
  MessageModel(
    id: 2,
    isMine: false,
    message: '치킨 어때요?',
    point: null,
    date: DateTime(2025, 5, 15),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isRunning = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: GetIt.I<Isar>().messageModels.where().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    return scrollToBottom();
                  });
                  return buildMessageList(messages);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 32.0,
              ),
              child: ChatTextField(
                controller: controller,
                onSend: handleSendMessage,
                error: error,
                loading: isRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  handleSendMessage() async {
    if (controller.text.isEmpty) {
      setState(() => error = '메세지를 입력하세요');
      return;
    }

    int? currentModelMessageId;
    int? currentUserMessageId;
    final isar = GetIt.I<Isar>();
    final currentPrompt = controller.text;

    try {
      setState(() {
        isRunning = true;
      });

      controller.clear();

      final myMessageCount =
          await isar.messageModels.filter().isMineEqualTo(true).count();

      currentUserMessageId = await isar.writeTxn(() async {
        return await isar.messageModels.put(
          MessageModel(
            isMine: true,
            message: currentPrompt,
            date: DateTime.now(),
            point: myMessageCount + 1,
          ),
        );
      });

      final contextMessages =
          await isar.messageModels.where().limit(5).findAll();

      print(
        'contextMessages: ${contextMessages.map((e) => e.message).toList()}',
      );

      final List<Content> promptContext =
          contextMessages
              .map(
                (e) => Content(e.isMine ? 'user' : 'model', [
                  TextPart(e.message!),
                ]),
              )
              .toList();

      final model = GenerativeModel(
        model: "gemini-1.5-flash",
        apiKey: "AIzaSyAD9B_1vDfej63hjH0czI8NXajPHMmV2Mg",
        systemInstruction: Content.system(
          "너는 이제부터 착하고 친절한 친구의 역할을 할 거야. 앞으로 채팅을 하면서 긍정적인 말만 할 수 있더록 해줘.",
        ),
      );

      String message = '';

      model
          .generateContentStream(promptContext)
          .listen(
            (event) async {
              if (event.text != null) {
                message += event.text!;
              }

              final MessageModel model = MessageModel(
                isMine: false,
                message: message,
                date: DateTime.now(),
              );

              if (currentModelMessageId != null) {
                model.id = currentModelMessageId!;
              }

              currentModelMessageId = await isar.writeTxn(
                () => isar.messageModels.put(model),
              );
            },
            onDone:
                () => setState(() {
                  isRunning = false;
                }),
            onError: (e) async {
              await isar.messageModels.delete(currentUserMessageId!);

              setState(() {
                error = e.toString();
                isRunning = false;
              });
            },
          );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: scrollController,
      itemCount: messages.length + 1,
      itemBuilder:
          (context, index) =>
              index == 0
                  ? buildLogo()
                  : buildMessageItem(
                    message: messages[index - 1],
                    prevMessage: index > 1 ? messages[index - 2] : null,
                    index: index - 1,
                  ),
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
    );
  }

  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Logo(),
      ),
    );
  }

  Widget buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final isMine = message.isMine;

    final shouldDrawDateDivider =
        prevMessage == null || shouldDrawDate(prevMessage.date!, message.date!);

    return Column(
      children: [
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DateDivider(date: message.date),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: isMine ? 64.0 : 16.0,
            right: isMine ? 16.0 : 64.0,
          ),
          child: Message(
            alignLeft: !isMine,
            message: message.message.trim(),
            point: message.point,
          ),
        ),
      ],
    );
  }

  bool shouldDrawDate(DateTime date1, DateTime date2) {
    return getStringDate(date1) != getStringDate(date2);
  }

  String getStringDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
