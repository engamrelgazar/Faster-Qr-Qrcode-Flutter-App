import 'package:fasterqr/features/history/domain_layer/history_repository_impl.dart';
import 'package:fasterqr/features/history/presentation_layer/widgets/delete_dialog.dart';
import 'package:fasterqr/services/data/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:fasterqr/features/history/bloc/history_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  late HistoryBloc _historyBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc(HistoryRepositoryImpl())..add(LoadHistory());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _historyBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _historyBloc.add(LoadMoreHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDeleteDialog(
                    context: context,
                    title: 'Delete all operations?',
                    onConfirm: () {
                      _historyBloc.add(DeleteAllOperations());
                    },
                  )),
        ],
      ),
      body: BlocProvider(
        create: (context) => _historyBloc,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              return HistoryListView(
                scrollController: _scrollController,
                historyBloc: _historyBloc,
                state: state,
              );
            } else if (state is HistoryError) {
              return Center(child: Text(state.message));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

/// Widget to display the list of history items
class HistoryListView extends StatelessWidget {
  final ScrollController scrollController;
  final HistoryBloc historyBloc;
  final HistoryLoaded state;

  const HistoryListView({
    super.key,
    required this.scrollController,
    required this.historyBloc,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: state.history.length + (state.hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= state.history.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final operation = state.history[index];
        return HistoryListTile(
          operation: operation,
          historyBloc: historyBloc,
        );
      },
    );
  }
}

/// Widget to display a single history item
class HistoryListTile extends StatelessWidget {
  final Operation operation;
  final HistoryBloc historyBloc;

  const HistoryListTile({
    super.key,
    required this.operation,
    required this.historyBloc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(operation.result),
      subtitle: Text(operation.dateTime.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: operation.result));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        },
      ),
      onLongPress: () {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete this operation?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    historyBloc.add(DeleteOperation(operation.key));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
