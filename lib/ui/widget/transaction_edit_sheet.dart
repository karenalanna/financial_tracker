import 'package:flutter/material.dart';
import '../../domain/entity/transaction_entity.dart';

class TransactionEditSheet extends StatefulWidget {
  final TransactionEntity transaction; // transação para editar
  final Function(TransactionEntity) onSave; // callback ao salvar

  const TransactionEditSheet({
    super.key,
    required this.transaction,
    required this.onSave,
  });

  @override
  State<TransactionEditSheet> createState() => _TransactionEditSheetState();
}

class _TransactionEditSheetState extends State<TransactionEditSheet> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _selectedDate = widget.transaction.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final editedTransaction = widget.transaction.copyWith(
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      date: _selectedDate,
    );
    widget.onSave(editedTransaction);
    Navigator.of(context).pop(); // fecha o modal
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Editar Transação',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: [
                Text(
                  'Data: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(onPressed: _save, child: const Text('Salvar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
