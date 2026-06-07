import 'package:flutter/material.dart';

class StepTwoScreen extends StatelessWidget {
  const StepTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
      ),
      home: const Scaffold(body: SafeArea(child: DescribeIssueWidget())),
    );
  }
}

class DescribeIssueWidget extends StatefulWidget {
  const DescribeIssueWidget({super.key});

  @override
  State<DescribeIssueWidget> createState() => _DescribeIssueWidgetState();
}

class _DescribeIssueWidgetState extends State<DescribeIssueWidget> {
  String? _selectedCategory;
  String _selectedSeverity = 'Low';

  // Dropdown categories extracted from your second image
  final List<String> _categories = [
    'UI Bug',
    'Crash',
    'Performance',
    'Feature Request',
    'Security',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Describe the Issue',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          const Text(
            "Help us understand the problem you're facing.",
            style: TextStyle(fontSize: 14, color: Colors.white38),
          ),
          const SizedBox(height: 28),

          // Main Card Container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF14141C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E1E28), width: 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bug Title Section
                    _buildLabel('BUG TITLE'),
                    const SizedBox(height: 8),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. App crashes on login',
                        hintStyle: const TextStyle(
                          color: Colors.white12,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.title,
                          color: Colors.white30,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A24),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E2445),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF6366F1),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Section
                    _buildLabel('CATEGORY'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: Row(
                        children: const [
                          Icon(
                            Icons.category_outlined,
                            color: Colors.white30,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Select Category',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      dropdownColor: const Color(0xFF14141C),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white30,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1A1A24),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E1E28),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF3E3E52),
                          ),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Severity Section
                    _buildLabel('SEVERITY'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSeverityButton(
                            label: 'Low',
                            activeBgColor: const Color(0xFF102A1E),
                            activeTextColor: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSeverityButton(
                            label: 'Medium',
                            activeBgColor: const Color(0xFF2B2214),
                            activeTextColor: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSeverityButton(
                            label: 'High',
                            activeBgColor: const Color(0xFF341A1A),
                            activeTextColor: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSeverityButton(
                      label: 'Critical',
                      activeBgColor: const Color(0xFF3A142C),
                      activeTextColor: const Color(0xFFEC4899),
                      fullWidth: true,
                    ),
                    const SizedBox(height: 24),

                    // Description Section
                    _buildLabel('DESCRIPTION'),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail...',
                        hintStyle: const TextStyle(
                          color: Colors.white12,
                          fontSize: 15,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 60.0),
                          child: Icon(
                            Icons.description_outlined,
                            color: Colors.white30,
                            size: 20,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A24),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E1E28),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF3E3E52),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Text Helper
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.white38,
        letterSpacing: 1.2,
      ),
    );
  }

  // Updated Dynamic Severity Button Helper accepting custom distinct color profiles
  Widget _buildSeverityButton({
    required String label,
    required Color activeBgColor,
    required Color activeTextColor,
    bool fullWidth = false,
  }) {
    bool isSelected = _selectedSeverity == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSeverity = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeTextColor : const Color(0xFF1E1E28),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? activeTextColor : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }
}
