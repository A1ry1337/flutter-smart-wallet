import 'package:flutter/material.dart';
import 'package:kliensy/features/clients/state/clients_controller.dart';


class NewClientModal extends StatefulWidget {
  const NewClientModal({super.key, required this.clientsController});

  final ClientsController clientsController;

  @override
  State<NewClientModal> createState() => _NewClientModalState();
}

class _NewClientModalState extends State<NewClientModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await widget.clientsController.createClient(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle:
    const TextStyle(fontSize: 14, color: Color(0xFFB0B7C3)),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
      const BorderSide(color: Color(0xFF1A5BFF), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Новый клиент',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Имя',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDec('Иван Иванов'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              const Text('Телефон',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDec('+7 (___) ___-__-__'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              const Text('Комментарий',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _commentController,
                maxLines: 2,
                decoration: _inputDec('Комментарий (необязательно)'),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: widget.clientsController,
                builder: (_, __) {
                  final isLoading = widget.clientsController.isSubmitting;
                  final error = widget.clientsController.submitError;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (error != null) ...[
                        Text(error,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 8),
                      ],
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                              : const Text('Сохранить клиента',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}