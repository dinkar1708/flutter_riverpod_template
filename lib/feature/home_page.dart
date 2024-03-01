import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/counter/counter_page.dart';
import 'package:flutter_riverpod_template/feature/repository_list/views/repository_list_page.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    required this.title,
    Key? key,
  }) : super(key: key);
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RepositoryListPage(),
                      ),
                    );
                  },
                  child: const Text('Open Github User API Page')),
              const Divider(),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CounterPage(
                          title: "Counter Example",
                        ),
                      ),
                    );
                  },
                  child: const Text('Counter Example')),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: AppColor.textSecondayLight,
        ));
  }
}
