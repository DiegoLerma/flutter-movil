import 'package:yes_no/domain/entities/message.dart';

class ChatResponseModel {
  final String answer;
  final bool forced;

  ChatResponseModel({
    required this.answer,
    required this.forced,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      ChatResponseModel(
        answer: json["answer"],
        forced: json["forced"] ?? false, // Asumimos false si no se proporciona
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "forced": forced,
      };

  Message toMessageEntity() => Message(text: answer, fromWho: FromWho.bot);
}
