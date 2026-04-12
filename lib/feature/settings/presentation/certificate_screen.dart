import 'package:flutter/material.dart';

class CertificateScreen extends StatefulWidget {
  static const String routeName = "/certificates";

  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String type = "Medical";

  final List<String> types = [
    "Medical",
    "Fitness",
    "Yoga",
    "Other"
  ];

  /// 🔥 Dummy list (replace with Firebase later)
  final List<Map<String, String>> certificates = [
    {
      "title": "Medical Certificate",
      "type": "Medical",
      "date": "12 Jan 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Certificates"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 UPLOAD SECTION
            const Text(
              "Upload Certificate",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  /// TITLE
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Certificate Title",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => title = val,
                    validator: (val) =>
                        val!.isEmpty ? "Enter title" : null,
                  ),

                  const SizedBox(height: 12),

                  /// TYPE
                  DropdownButtonFormField<String>(
                    value: type,
                    decoration: const InputDecoration(
                      labelText: "Type",
                      border: OutlineInputBorder(),
                    ),
                    items: types
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => type = val!),
                  ),

                  const SizedBox(height: 12),

                  /// FILE PICKER
                  _UploadBox(
                    title: "Upload File (PDF/Image)",
                    icon: Icons.upload_file,
                    onTap: () {
                      // TODO: pick file
                    },
                  ),

                  const SizedBox(height: 16),

                  /// SUBMIT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6A66FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!
                            .validate()) {
                          _addCertificate();
                        }
                      },
                      child: const Text("Upload"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 VIEW SECTION
            const Text(
              "Your Certificates",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            /// LIST
            ListView.builder(
              itemCount: certificates.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = certificates[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf,
                        color: Color(0xFF6A66FF)),
                    title: Text(item["title"]!),
                    subtitle: Text(
                        "${item["type"]} • ${item["date"]}"),
                    trailing:
                        const Icon(Icons.visibility),
                    onTap: () {
                      // TODO: open file
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 ADD CERTIFICATE (TEMP LOGIC)
  void _addCertificate() {
    setState(() {
      certificates.add({
        "title": title,
        "type": type,
        "date": "Today",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploaded")),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _UploadBox({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 36,
                color: const Color(0xFF6A66FF)),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}