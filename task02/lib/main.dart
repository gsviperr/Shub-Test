import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'bloc/transaction__bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Form'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Transaction Form Content'),
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Form'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                FocusScope.of(context).unfocus();
                var formData = _formKey.currentState!.value;

                // Dispatch the update event
                context.read<TransactionBloc>().add(UpdateTransaction(
                  time: formData['time'],
                  quantity: formData['quantity'],
                  reference: formData['reference'],
                  revenue: formData['revenue'],
                  unitPrice: formData['unitPrice'],
                ));
              } else {
                // Lấy thông tin lỗi từ form
                final errors = _formKey.currentState?.fields.entries.map((field) {
                  final error = field.value.errorText; // Sử dụng đúng kiểu để lấy lỗi
                  return error != null ? error : ''; // Chỉ lấy các lỗi không null
                }).toList() ?? [];

                // Kiểm tra các lỗi và phát sự kiện tương ứng
                for (var error in errors) {
                  if (error.isNotEmpty) {
                    context.read<TransactionBloc>().add(ShowErrorEvent(errorText: error));
                  }
                }
              }
            },
            child: const Text('Update'),
          ),
          const SizedBox(width: 16), // Thêm khoảng cách giữa title và button
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  name: 'time',
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Thời gian',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập ngày và giờ',
                    ),
                        (val) {
                      if (val != null && val is DateTime) {
                        if (val.isAfter(DateTime.now())) {
                          return 'Vui lòng chọn ngày hợp lệ';
                        }
                      }
                      return null;
                    },
                  ]),
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'quantity',
                  decoration: const InputDecoration(
                    labelText: 'Số Lượng',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập số lượng',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Vui lòng nhập số hợp lệ',
                    ),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown(
                  name: 'reference',
                  decoration: const InputDecoration(
                    labelText: 'Trụ',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'option1',
                      child: Text('Option 1'),
                    ),
                    DropdownMenuItem(
                      value: 'option2',
                      child: Text('Option 2'),
                    ),
                    DropdownMenuItem(
                      value: 'option3',
                      child: Text('Option 3'),
                    ),
                  ],
                  validator: FormBuilderValidators.required(
                    errorText: 'Vui lòng chọn số Trụ',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'revenue',
                  decoration: const InputDecoration(
                    labelText: 'Doanh Thu',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập Doanh Thu',
                    ),
                    FormBuilderValidators.numeric(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'unitPrice',
                  decoration: const InputDecoration(
                    labelText: 'Đơn Giá',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập Đơn Giá',
                    ),
                    FormBuilderValidators.numeric(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowErrorEvent extends TransactionEvent {
  final String errorText;

  ShowErrorEvent({required this.errorText});

  @override
  List<Object> get props => [errorText];
}
