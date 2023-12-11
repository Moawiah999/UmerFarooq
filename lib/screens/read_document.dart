import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class DocumentViewer extends StatefulWidget {
  final String documentUrl;

  const DocumentViewer({super.key, required this.documentUrl});

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Viewer'),
      ),
      body: SfPdfViewer.network(
        widget.documentUrl,
        canShowPageLoadingIndicator: true,
        enableHyperlinkNavigation: true,
        canShowScrollStatus: true,
        scrollDirection: PdfScrollDirection.vertical,

      ),
    );
  }
}
