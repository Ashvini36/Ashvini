import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/constants.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  String? termsAndCondition;

  @override
  void initState() {
    FireStoreUtils.firestore.collection(Setting).doc("termsAndConditions").get().then((value) {
      print(value['terms_and_condition']);
      setState(() {
        termsAndCondition = value['terms_and_condition'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: termsAndCondition != null
              ? HtmlWidget(
                  // the first parameter (`html`) is required
                  '''
                  $termsAndCondition
                   ''',
                  onErrorBuilder: (context, element, error) => Text('$element ${"error: ".tr()}$error'),
                  onLoadingBuilder: (context, element, loadingProgress) => const CircularProgressIndicator(),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
