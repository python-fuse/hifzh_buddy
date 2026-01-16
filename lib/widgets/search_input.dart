import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';

class SearchInput extends ConsumerWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      style: TextStyle(fontSize: 14),

      onChanged: (value) {
        ref.read(searchTermProvider.notifier).state = value;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search by name or number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
