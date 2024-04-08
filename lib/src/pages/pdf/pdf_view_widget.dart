import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyPdfViewer extends StatefulWidget {
  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isLoading = true;
  bool _fileDownloaded = false;
  late String _pdfPath;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _initPdfFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como lidar com escorpiões'),
      ),
      body: Column(
        children: [
          _fileDownloaded
              ? Flexible(
                child: PDFView(
                    filePath: _pdfPath,
                    autoSpacing: true,
                    enableSwipe: true,
                    pageSnap: true,
                    swipeHorizontal: true,
                    fitPolicy: FitPolicy.WIDTH,
                    onViewCreated: (PDFViewController vc) {
                      _pdfViewController = vc;
                      _getTotalPages();
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() {
                        _currentPage = page ?? 0;
                        _totalPages = total ?? 0;
                      });
                    },
                    onError: (error) {
                      _showErrorDialog(context, error);
                    },
                    onRender: (_pages) {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
              )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Página ${_currentPage+1} de $_totalPages'),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_pdfViewController != null && _currentPage > 0) {
                    _pdfViewController!.setPage(_currentPage - 1);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  if (_pdfViewController != null &&
                      _currentPage < _totalPages) {
                    _pdfViewController!.setPage(_currentPage + 1);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initPdfFile() async {
    final dir = await getApplicationDocumentsDirectory();

    if (await File('${dir.path}/sample.pdf').exists()) {
      setState(() {
        _pdfPath = '${dir.path}/sample.pdf';
        _fileDownloaded = true;
      });
      return;
    }

    const url =
        'http://vigilancia.saude.mg.gov.br/index.php/download/folder-sobre-escorpiao-ses/?wpdmdl=3975'; 
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final path = '${dir.path}/sample.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes);
    setState(() {
      _pdfPath = path;
      _fileDownloaded = true;
    });
  }

  Future<void> _getTotalPages() async {
    final int? totalPages = await _pdfViewController!.getPageCount();
    setState(() {
      _totalPages = totalPages ?? 0;
    });
  }

  void _showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao tentar abrir o PDF. '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
