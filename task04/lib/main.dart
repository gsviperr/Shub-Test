import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/data_bloc.dart';
import 'bloc/data_event.dart';
import 'bloc/data_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: 'Query Processor',
      home: BlocProvider(
        create: (context) => DataBloc()..add(FetchDataEvent()),
        child: QueryScreen(),
      ),
    );
  }
}

class QueryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Processor')),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text(state.error!));
          } else if (state.results != null) {
            return ListView.builder(
              itemCount: state.results!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Result ${index + 1}: ${state.results![index]}',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            );
          }
          return Center(child: Text('No results'));
        },
      ),
    );
  }
}
