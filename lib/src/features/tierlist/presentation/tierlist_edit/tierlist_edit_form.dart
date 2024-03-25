import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/info_label.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TierListEditFormData {
  const TierListEditFormData({
    required this.name,
  });

  final String name;
}

class TierListEditForm extends StatefulWidget {
  const TierListEditForm({
    super.key,
    this.initialTierList,
  });

  final TierList? initialTierList;

  @override
  State<TierListEditForm> createState() => TierListEditFormState();
}

class TierListEditFormState extends State<TierListEditForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTierList?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: InfoLabel(
        labelText: context.loc.tierlist_edit_nameField,
        child: TextFormField(
          controller: _nameController,
          validator: FormBuilderValidators.required(errorText: context.loc.tierlist_edit_nameRequiredError),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  TierListEditFormData value() {
    return TierListEditFormData(
      name: _nameController.text,
    );
  }
}
