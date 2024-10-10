// lib/bloc/data_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/data_model.dart';


import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataState(isLoading: true)) {
    on<FetchDataEvent>((event, emit) async {
      emit(DataState(isLoading: true));

      try {
        final response = await http.get(
          Uri.parse("https://test-share.shub.edu.vn/api/intern-test/input"),
        );

        if (response.statusCode == 200) {
          final dataModel = DataModel.fromJson(json.decode(response.body));

          // In ra token đã lấy từ API input
          print('Token: ${dataModel.token}');

          final results = processQueries(dataModel.data, dataModel.queries);
          print('Data: ${dataModel.data}');
          emit(DataState(results: results, isLoading: false));

          // Gửi kết quả với token xác thực
          await sendResults(dataModel.token, results);
        } else {
          emit(DataState(error: 'Failed to load data', isLoading: false));
        }
      } catch (e) {
        emit(DataState(error: e.toString(), isLoading: false));
      }
    });
  }

  List<int> processQueries(List<int> data, List<Query> queries) {
    List<int> results = [];

    for (var query in queries) {
      int l = query.range[0];
      int r = query.range[1];

      if (query.type == "1") {
        // Type 1: Calculate the sum for the range
        int totalSum = 0;
        for (int i = l; i <= r; i++) {
          totalSum += data[i];
        }
        results.add(totalSum);
      } else if (query.type == "2") {
        // Type 2: Calculate the alternating sum
        int evenSum = 0; // Sum of elements at even indices
        int oddSum = 0;  // Sum of elements at odd indices
        for (int i = l; i <= r; i++) {
          if (i % 2 == 0) {
            evenSum += data[i]; // Add even index
          } else {
            oddSum += data[i]; // Add odd index
          }
        }
        // Result is the difference of evenSum and oddSum
        results.add(evenSum - oddSum);
      }
    }

    return results;
  }

  Future<void> sendResults(String token, List<int> results) async {
    try {
      final response = await http.post(
        Uri.parse("https://test-share.shub.edu.vn/api/intern-test/output"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(results),  // Gửi trực tiếp dưới dạng mảng JSON
      );

      // In ra headers và body của response để debug
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        print('Successfully sent results');
      } else {
        print('Failed to send results: ${response.body}');
      }
    } catch (e) {
      print('Error sending results: $e');
    }
  }
}
