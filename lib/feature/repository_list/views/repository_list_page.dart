import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/repository_list/providers/repository_list_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_sliver_app_bar.dart';

@RoutePage()
class RepositoryListPage extends ConsumerStatefulWidget {
  final String title;

  const RepositoryListPage({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RepositoryListPage> createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends ConsumerState<RepositoryListPage> {
  // read just once
  RepositoryListNotifier get repositoryListNotifier =>
      ref.read(repositoryListNotifierProvider.notifier);
  @override
  Widget build(BuildContext context) {
    // keep watching, contininouse changes observation
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
        SharedSliverAppBar(
          title: widget.title + repositoryListNotifier.userName,
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
        model.description ?? '',
        style:
            AppTextStyle.bodySmall.copyWith(color: context.color.textPrimary),
      ),
    );
  }
}
