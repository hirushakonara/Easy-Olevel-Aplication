import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String pdfUrl;
  final String lessonName;

  const PdfViewScreen({
    super.key,
    required this.pdfUrl,
    required this.lessonName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lessonName),
        backgroundColor: Colors.blue, // kPrimaryBlue එක මෙතනට දෙන්න පුළුවන්
      ),
      // URL එක හරහා PDF එක load කිරීම
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
      ),
    );
  }
}
