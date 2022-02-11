import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/walk_record_view_model.dart';

class WalkRecordListScreen extends ConsumerWidget {
  const WalkRecordListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(walkRecordViewModelProvider);

    // Initが完了するまで
    if (!viewModel.isInitSuccess) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    var addNum = (viewModel.hasNext) ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('walk record'),
      ),
      body: ListView.separated(
        controller: viewModel.scrollController,
        itemCount: viewModel.walkRecordList.length + addNum,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (viewModel.hasNext) {
            if (index == viewModel.walkRecordList.length) {
              return const CupertinoActivityIndicator();
            }
          }

          return ListTile(
            title: Text(viewModel.walkRecordList[index].date.toString()),
          );
        },
      ),
    );
  }
}
