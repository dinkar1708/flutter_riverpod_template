import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/users/models/user_model.dart';
import 'package:flutter_riverpod_template/feature/users/providers/users_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/users/providers/users_filter_parameter_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

@RoutePage()
class UsersPage extends StatefulHookConsumerWidget {
  final String title;

  const UsersPage({required this.title, super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPage();
}

class _UsersPage extends ConsumerState<UsersPage> {
  final _searchController = TextEditingController();
  bool isSearching = false;
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isSearching = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: context.color.backgroundPrimary,
              foregroundColor: context.color.textPrimary,
              title: Text(' User ${widget.title} Repositories'),
              floating: true,
              actions: [
                IconButton(
                  icon: Icon(isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                    if (!isSearching) {
                      _clearSearch(ValueNotifier(false));
                    }
                  },
                ),
              ],
            ),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 8)),
            if (isSearching) _buildSearchView(),
            _buildListRootView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    final isSearchingNotifier = useState(false);
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverToBoxAdapter(
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Search',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _clearSearch(isSearchingNotifier),
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            isSearchingNotifier.value = value.isNotEmpty;
            _onQueryChanged(value);
          },
        ),
      ),
    );
  }

  void _clearSearch(ValueNotifier<bool> isSearchingNotifier) {
    _searchController.clear();
    isSearchingNotifier.value = false;
    ref.read(usersFilterParameterNotifierProvider.notifier).clear();
  }

  Widget _buildListRootView() {
    final usersListAsync = ref.watch(filteredUsersProvider);

    return switch (usersListAsync) {
      AsyncError(:final error) => SliverToBoxAdapter(
        child: SliverToBoxAdapter(child: Text('Error $error')),
      ),
      AsyncData(:final value) => _buildListView(value),
      _ => const SliverToBoxAdapter(child: Center(child: Text('Loading...'))),
    };
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(usersFilterParameterNotifierProvider.notifier).setQuery(value);
    });
  }

  Widget _buildListView(List<UserModel> modelList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final entry = modelList[index];
        return _buildListRowView(entry);
      }, childCount: modelList.length),
    );
  }

  Widget _buildListRowView(UserModel model) {
    return ListTile(
      title: Text(model.name.toString(), style: AppTextStyle.labelLarge),
      subtitle: Text(
        'desc',
        style: AppTextStyle.bodySmall.copyWith(
          color: context.color.textPrimary,
        ),
      ),
    );
  }
}
