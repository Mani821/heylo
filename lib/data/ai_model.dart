import 'dart:convert';

Models modelsFromJson(String str) => Models.fromJson(json.decode(str));

class Models {
  final List<Datum> data;

  Models({
    required this.data,
  });

  factory Models.fromJson(Map<String, dynamic> json) => Models(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );


}

class Datum {
  final String id;
  final String name;
  final String description;


  Datum({
    required this.id,
    required this.name,
    required this.description,
    // required this.pricing,

  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    // pricing: Pricing.fromJson(json["pricing"]),

  );

}


class Pricing {
  final String prompt;
  final String completion;
  final String request;
  final String image;
  final String webSearch;
  final String internalReasoning;
  final String inputCacheRead;
  final String inputCacheWrite;

  Pricing({
    required this.prompt,
    required this.completion,
    required this.request,
    required this.image,
    required this.webSearch,
    required this.internalReasoning,
    required this.inputCacheRead,
    required this.inputCacheWrite,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
    prompt: json["prompt"],
    completion: json["completion"],
    request: json["request"],
    image: json["image"],
    webSearch: json["web_search"],
    internalReasoning: json["internal_reasoning"],
    inputCacheRead: json["input_cache_read"],
    inputCacheWrite: json["input_cache_write"],
  );

  Map<String, dynamic> toJson() => {
    "prompt": prompt,
    "completion": completion,
    "request": request,
    "image": image,
    "web_search": webSearch,
    "internal_reasoning": internalReasoning,
    "input_cache_read": inputCacheRead,
    "input_cache_write": inputCacheWrite,
  };
}

class TopProvider {
  final int contextLength;
  final int maxCompletionTokens;
  final bool isModerated;

  TopProvider({
    required this.contextLength,
    required this.maxCompletionTokens,
    required this.isModerated,
  });

  factory TopProvider.fromJson(Map<String, dynamic> json) => TopProvider(
    contextLength: json["context_length"],
    maxCompletionTokens: json["max_completion_tokens"],
    isModerated: json["is_moderated"],
  );

  Map<String, dynamic> toJson() => {
    "context_length": contextLength,
    "max_completion_tokens": maxCompletionTokens,
    "is_moderated": isModerated,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
