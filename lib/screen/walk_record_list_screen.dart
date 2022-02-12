import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/walk_record_view_model.dart';

import '../utility/utility.dart';

class WalkRecordListScreen extends ConsumerWidget {
  WalkRecordListScreen({Key? key}) : super(key: key);

  Utility _utility = Utility();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(walkRecordViewModelProvider);
    final viewModel2 = ref.watch(holidayViewModelProvider);

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          ListView.separated(
            controller: viewModel.scrollController,
            itemCount: viewModel.walkRecordList.length + addNum,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              if (viewModel.hasNext) {
                if (index == viewModel.walkRecordList.length) {
                  return const CupertinoActivityIndicator();
                }
              }

              _utility.makeYMDYData(
                  viewModel.walkRecordList[index].date.toString(), 0);
              var dispDate =
                  '${_utility.year}-${_utility.month}-${_utility.day}';

              var step = _utility.makeCurrencyDisplay(
                  viewModel.walkRecordList[index].step.toString());

              var distance = _utility.makeCurrencyDisplay(
                  viewModel.walkRecordList[index].distance.toString());

              return Card(
                color: _utility.getBgColor(dispDate, viewModel2.holidayList),
                child: ListTile(
                  title: DefaultTextStyle(
                    style: TextStyle(fontSize: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Text('${dispDate}（${_utility.youbiStr}）'),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text('${step} step.'),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text('${distance} m'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(viewModel.walkRecordList[index].spend),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text('timeplace'), flex: 1),
                            Expanded(
                                child: Text(
                                    viewModel.walkRecordList[index].timeplace),
                                flex: 3),
                          ],
                        ),
                        (viewModel.walkRecordList[index].temple != '')
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text('temple'), flex: 1),
                                  Expanded(
                                      child: Text(viewModel
                                          .walkRecordList[index].temple),
                                      flex: 3),
                                ],
                              )
                            : Container(),
                        (viewModel.walkRecordList[index].mercari != '')
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text('mercari'), flex: 1),
                                  Expanded(
                                      child: Text(viewModel
                                          .walkRecordList[index].mercari),
                                      flex: 3),
                                ],
                              )
                            : Container(),
                        (viewModel.walkRecordList[index].train != '')
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text('train'), flex: 1),
                                  Expanded(
                                      child: Text(viewModel
                                          .walkRecordList[index].train),
                                      flex: 3),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
