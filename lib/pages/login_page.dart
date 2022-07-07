import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fl_chat/helpers/mostrar_alerta.dart';
import 'package:fl_chat/services/services.dart';
import 'package:fl_chat/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
   
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: const [
                Logo(titulo: 'Messenger'),
                _Form(),
                Labels(ruta: 'register', titulo: '¿No tienes cuenta?', subtitulo: 'Crea una ahora!'),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl
          ),          
          BotonAzul(
            text: 'Ingrese',
            onPressed: authService.autenticando 
              ? null 
              : () async {
                FocusScope.of(context).unfocus();
                final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
                if (loginOk) {
                  Navigator.pushReplacementNamed(context, 'usuarios');
                } else {
                  // Mostrar alerta
                  mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales nuevamente');
                }
              }                 
          )
        ],
      ),
    );
  }
}