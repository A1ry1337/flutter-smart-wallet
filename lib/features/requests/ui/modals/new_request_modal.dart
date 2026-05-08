import 'package:flutter/material.dart';
import 'package:kliensy/features/requests/state/requests_controller.dart';


class NewRequestModal extends StatefulWidget {
  const NewRequestModal({
    super.key,
    required this.requestsController,
    this.preselectedClientId,
    this.preselectedClientName,
  });

  final RequestsController requestsController;
  final int? preselectedClientId;
  final String? preselectedClientName;

  @override
  State<NewRequestModal> createState() => _NewRequestModalState();
}

class _NewRequestModalState extends State<NewRequestModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _phoneController = TextEditingController();

  int? _selectedClientId;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedClientId != null) {
      _selectedClientId = widget.preselectedClientId;
      _clientNameController.text = widget.preselectedClientName ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _clientNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) return;

    final ok = await widget.requestsController.createRequest(
      clientId: _selectedClientId!,
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

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
              // Handle
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
                  const Text(
                    'Новая заявка',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Client field
              const Text('Клиент',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              _ClientSearchField(
                controller: _clientNameController,
                onClientSelected: (id) {
                  setState(() => _selectedClientId = id);
                },
              ),
              const SizedBox(height: 16),

              // Title field
              const Text('Название заявки',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Например: Ремонт розетки'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Description
              const Text('Описание',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputDecoration('Опишите заявку'),
              ),
              const SizedBox(height: 24),

              AnimatedBuilder(
                animation: widget.requestsController,
                builder: (_, __) {
                  final isLoading = widget.requestsController.isSubmitting;
                  final error = widget.requestsController.submitError;
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
                          onPressed: isLoading || _selectedClientId == null
                              ? null
                              : _submit,
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
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Создать заявку',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
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
}

/// Поле поиска клиента с автодополнением.
/// В реальном проекте стоит использовать ClientsApi напрямую.
class _ClientSearchField extends StatelessWidget {
  const _ClientSearchField({
    required this.controller,
    required this.onClientSelected,
  });

  final TextEditingController controller;
  final ValueChanged<int> onClientSelected;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Введите имя контакта',
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
      ),
      validator: (v) =>
      (v == null || v.trim().isEmpty) ? 'Выберите клиента' : null,
      // In a real app: use Autocomplete widget + ClientsApi
    );
  }
}