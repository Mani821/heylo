import 'package:flutter/cupertino.dart';
import 'package:heylo/const/app_colors.dart';
import 'package:heylo/data/ai_model.dart';
import 'package:heylo/service/ai_service.dart';
import 'package:heylo/widgets/helo_loading.dart';

class ChangeModelView extends StatefulWidget {
  const ChangeModelView({super.key});

  @override
  State<ChangeModelView> createState() => _ChangeModelViewState();
}

class _ChangeModelViewState extends State<ChangeModelView> {
  final _aiService = AIService();
  List<Datum> models = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    _fetchModels();
    super.initState();
  }

  _fetchModels() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _aiService.fetchAllModels();
      setState(() {
        models = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:
          isLoading
              ? MyLoading()
              : Column(
                children: [
                  CupertinoTextField(
                    controller: searchController,
                    placeholderStyle: TextStyle(
                      color: primaryColor.withValues(alpha: 0.4),
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    cursorColor: primaryColor,
                    cursorHeight: 15,
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    placeholder: 'Search for a model',
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final model = models[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            // margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: bgColor, width: 2),
                            ),

                            child: Text(
                              model.name,
                              maxLines: 1,
                              style: TextStyle(
                                color: bgColor,
                                fontFamily: 'Lexend',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
