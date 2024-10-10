// lib/bloc/data_state.dart
class DataState {
  final List<int>? results;
  final bool isLoading;
  final String? error;

  DataState({this.results, this.isLoading = false, this.error});
}
