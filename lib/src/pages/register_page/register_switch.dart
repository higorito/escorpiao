// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:escorpionico_proj/src/pages/register_page/agente_saude_register_page.dart';
import 'package:escorpionico_proj/src/pages/register_page/register_page.dart';

class RegisterSwitch extends StatelessWidget {
  final bool agenteSaude;

  const RegisterSwitch({
    Key? key,
    required this.agenteSaude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return agenteSaude ? const AgenteSaudeRegisterPage() : const RegisterPage();
  }
}
