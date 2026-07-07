import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../features/auth/widgets/login_form.dart';
import '../../../features/auth/widgets/login_header.dart';
import '../../../features/auth/widgets/login_left_panel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: mobile
            ? const _MobileLogin()
            : const _DesktopLogin(),
      ),
    );
  }
}

class _DesktopLogin extends StatelessWidget {
  const _DesktopLogin();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 5,
          child: LoginLeftPanel(),
        ),

        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),

                child: Card(
                  elevation: 8,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(40),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: const [

                        LoginHeader(),

                        SizedBox(height: 40),

                        LoginForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLogin extends StatelessWidget {
  const _MobileLogin();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),

      child: Column(

        children: const [

          LoginHeader(),

          SizedBox(height: 40),

          LoginForm(),

        ],

      ),

    );
  }
}