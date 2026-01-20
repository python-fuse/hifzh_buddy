import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/widgets/my_appbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Settings"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Grouped Settings
            //
            // Downloads Groud
            _buildDownloadSettingsGroup(context),
          ],
        ),
      ),
    );
  }

  Container _buildDownloadSettingsGroup(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            "Downloads".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w100),
          ),

          SizedBox(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text("Reciters"),
                  onTap: () {
                    context.push('/downloads');
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  leading: Icon(Icons.multitrack_audio_rounded),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  subtitle: Text("Manage and download reciters audio"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
