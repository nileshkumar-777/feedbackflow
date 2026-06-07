import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:feedback_flow/feedback_data.dart';

class StepThreeScreen extends StatelessWidget {
  final FeedbackData feedbackData;
  const StepThreeScreen({Key? key, required this.feedbackData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AttachEvidenceScreen(feedbackData: feedbackData);
  }
}

class AttachEvidenceScreen extends StatefulWidget {
  final FeedbackData feedbackData;
  const AttachEvidenceScreen({Key? key, required this.feedbackData})
    : super(key: key);

  @override
  State<AttachEvidenceScreen> createState() => _AttachEvidenceScreenState();
}

class _AttachEvidenceScreenState extends State<AttachEvidenceScreen> {
  // Dynamic list to hold your uploaded files when you implement your file picker
  final List<Map<String, dynamic>> _selectedMedia = [];

  @override
  void initState() {
    super.initState();
    for (var attachment in widget.feedbackData.attachments) {
      _selectedMedia.add({'name': attachment, 'isUploading': false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            'Attach Evidence',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Upload screenshots, images, or videos that help explain the issue.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Upload Dropzone Area
          DottedBorder(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1.5,
            dashPattern: const [6, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xff1A1B26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cloud Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Upload Media',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Images or Videos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Browse Button
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: true, type: FileType.media);
                      if (result != null) {
                        setState(() {
                          for (var file in result.files) {
                            _selectedMedia.add({
                              'name': file.name,
                              'isUploading': false,
                            });
                            widget.feedbackData.attachments.add(file.name);
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff242636),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tap to browse files',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Selected Media Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selected Media',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_selectedMedia.length} files',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dynamic Media Horizontal List View
          SizedBox(
            height: 120,
            child: _selectedMedia.isEmpty
                ? Center(
                    child: Text(
                      'No files added yet.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMedia.length,
                    itemBuilder: (context, index) {
                      final file = _selectedMedia[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: _buildMediaCard(
                          fileName: file['name'] ?? '',
                          isUploading: file['isUploading'] ?? false,
                          progressText: file['progressText'] ?? '',
                          progressValue: file['progressValue'] ?? 0.0,
                          child: file['thumbnail'] ?? const SizedBox(),
                          onRemove: () {
                            setState(() {
                              widget.feedbackData.attachments.remove(
                                file['name'],
                              );
                              _selectedMedia.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Dynamic attachment card builder helper template
  Widget _buildMediaCard({
    required String fileName,
    required Widget child,
    required bool isUploading,
    String progressText = '',
    double progressValue = 0.0,
    required VoidCallback onRemove,
  }) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: child,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (isUploading)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 4,
                        backgroundColor: Colors.transparent,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              if (isUploading) ...[
                const SizedBox(width: 4),
                Text(
                  progressText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
