import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/repository_list/providers/repository_list_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';

class RepositoryListPage extends ConsumerStatefulWidget {
  const RepositoryListPage({super.key});

  @override
  ConsumerState<RepositoryListPage> createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends ConsumerState<RepositoryListPage> {
  RepositoryListNotifier get notifier =>
      ref.read(repositoryListNotifierProvider.notifier);
  @override
  Widget build(BuildContext context) {
    // keep watching
    final repositoryListAsync = ref.watch(repositoryListNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: repositoryListAsync.when(
            data: (data) => _buildListView(data),
            error: (error, stackTrace) {
              debugPrint(error.toString());
              debugPrint(stackTrace.toString());
              return Text('Error $error');
            },
            loading: () => const Center(child: Text('Loading...')),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<RepositoryListModel> modelList) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(' User(${notifier.userName}) Repositories'),
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final entry = modelList[index];
              return _buildListRowView(entry);
            },
            childCount: modelList.length,
          ),
        ),
      ],
    );
  }

  Widget _buildListRowView(RepositoryListModel model) {
    return ListTile(
      title: Text(
        model.name,
        style: AppTextStyle.labelLarge,
      ),
      subtitle: Text(
        model.description,
        style: AppTextStyle.bodySmall.copyWith(color: AppColor.mint2),
      ),
    );
  }
}
