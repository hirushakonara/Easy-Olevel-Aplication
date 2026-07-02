import 'package:easyol/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // තෝරාගත් පිළිතුරු ගබඩා කිරීම සඳහා Map එකක් භාවිතා කරයි
  Map<String, String> userAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz & Questions"),
        backgroundColor: kPrimaryBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var qData = snapshot.data!.docs[index];
              List options = qData['options'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qData['question'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...options.map(
                        (option) => RadioListTile(
                          title: Text(option),
                          value: option,
                          // තෝරාගත් පිළිතුර පෙන්වීම සඳහා State එක යාවත්කාලීන කරයි
                          groupValue: userAnswers[qData.id],
                          onChanged: (val) {
                            setState(() {
                              userAnswers[qData.id] = val as String;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
