import 'package:favirote_plaseces/place_screen/add_newscreen.dart';
import 'package:favirote_plaseces/widget/myplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favirote_plaseces/Providers/myplasece.dart';

// ignore: camel_case_types
class ScreenPlace extends ConsumerStatefulWidget {
  const ScreenPlace({super.key});

  @override
  ConsumerState<ScreenPlace> createState() {
    return _ScreenPlace();
  }
}

// ignore: camel_case_types
class _ScreenPlace extends ConsumerState<ScreenPlace> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(myplace.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final mycons = ref.watch(myplace);

    return Scaffold(
      appBar: AppBar(
        title: Text('your places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddNewscreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Myplace(
                      mycons: mycons,
                    ),
        ),
      ),
    );
  }
}
