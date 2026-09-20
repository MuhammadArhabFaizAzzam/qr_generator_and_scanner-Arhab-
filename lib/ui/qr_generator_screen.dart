import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const Color primaryColor = Color(0xFF2E236C);
const Color secondaryColor = Color(0xFF17153B);

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _textController = TextEditingController();

  String? _qrData;
  Color _qrColor = Colors.white;
  Color _dotsColor = Colors.black;
  bool _isSmooth = true;
  bool _showLogo = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: AppBar(
        title: const Text('Create Premium QR'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // QR Preview Card
                  Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _qrColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _qrData == null || _qrData!.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code_2_rounded, size: 64, color: Colors.grey.shade300),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Awaiting input...',
                                      style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            : PrettyQrView.data(
                                data: _qrData!,
                                decoration: PrettyQrDecoration(
                                  shape: _isSmooth
                                      ? PrettyQrSmoothSymbol(color: _dotsColor)
                                      : PrettyQrRoundedSymbol(color: _dotsColor),
                                  image: _showLogo
                                      ? const PrettyQrDecorationImage(
                                          image: AssetImage('assets/images/splash.png'),
                                          position: PrettyQrDecorationImagePosition.embedded,
                                        )
                                      : null,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Input Section
                  TextField(
                    controller: _textController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter URL or Text',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                    onChanged: (value) {
                      setState(() => _qrData = value.trim().isEmpty ? null : value.trim());
                    },
                  ),
                  const SizedBox(height: 24),

                  // Customization Tabs
                  _buildCustomizationPanel(),
                ],
              ),
            ),
          ),

          // Sticky Bottom Actions
          _buildActionPanel(),
        ],
      ),
    );
  }

  Widget _buildCustomizationPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customize Appearance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        const SizedBox(height: 16),

        // Style Switcher
        Row(
          children: [
            Expanded(
              child: _buildOptionTile(
                label: 'Smooth',
                isSelected: _isSmooth,
                onTap: () => setState(() => _isSmooth = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionTile(
                label: 'Rounded',
                isSelected: !_isSmooth,
                onTap: () => setState(() => _isSmooth = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Logo Switcher
        _buildToggleTile(
          label: 'Show App Logo',
          value: _showLogo,
          onChanged: (val) => setState(() => _showLogo = val),
        ),
        const SizedBox(height: 20),

        // Background Color Picker
        const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Colors.white,
              Colors.grey.shade100,
              const Color(0xFFFFF4E6),
              const Color(0xFFE6F3FF),
              const Color(0xFFF3E6FF),
            ].map((color) => _buildColorCircle(color, isBg: true)).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Dots Color Picker
        const Text('Dots Color', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Colors.black,
              primaryColor,
              Colors.red.shade700,
              Colors.green.shade700,
              Colors.blue.shade700,
            ].map((color) => _buildColorCircle(color, isBg: false)).toList(),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildOptionTile({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile({required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color, {required bool isBg}) {
    bool isSelected = isBg ? _qrColor == color : _dotsColor == color;
    return GestureDetector(
      onTap: () => setState(() {
        if (isBg) _qrColor = color; else _dotsColor = color;
      }),
      child: Container(
        width: 44,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? secondaryColor : Colors.grey.shade300, width: isSelected ? 3 : 1),
          boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: isSelected ? const Icon(Icons.check, size: 20, color: Colors.blueGrey) : null,
      ),
    );
  }

  Widget _buildActionPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _qrData == null ? null : () => _handleShare(),
              icon: const Icon(Icons.share_rounded, size: 20),
              label: const Text('Share'),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.print_rounded, color: primaryColor),
              onPressed: _qrData == null ? null : () => _generateAndPrintPdf(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.red),
              onPressed: () {
                setState(() {
                  _qrData = null;
                  _textController.clear();
                  _qrColor = Colors.white;
                  _dotsColor = Colors.black;
                  _isSmooth = true;
                  _showLogo = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleShare() async {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final Uint8List? imageBytes = await _screenshotController.capture(pixelRatio: pixelRatio);
    if (imageBytes != null) {
      await Share.shareXFiles(
        [XFile.fromData(imageBytes, name: 'qr_code.png', mimeType: 'image/png')],
        text: 'Check out this QR Code generated with QRODE',
      );
    }
  }

  Future<void> _generateAndPrintPdf() async {
    final imageBytes = await _screenshotController.capture(pixelRatio: 3.0);
    if (imageBytes == null) return;

    final pdf = pw.Document();
    final qrImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('PREMIUM QR CODE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Image(qrImage, width: 250, height: 250),
                pw.SizedBox(height: 30),
                pw.Text('Content: $_qrData', style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 20),
                pw.Text('Generated by QRODE Premium', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save(), name: 'QR_Code_QRODE.pdf');
    }
    }