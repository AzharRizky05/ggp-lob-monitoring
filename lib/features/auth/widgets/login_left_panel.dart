import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LoginLeftPanel extends StatelessWidget {
  const LoginLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            AppColors.primary,

            AppColors.secondary,

          ],

        ),

      ),

      child: Center(

        child: Padding(

          padding: const EdgeInsets.all(40),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(

                Icons.factory_rounded,

                color: Colors.white,

                size: 120,

              ),

              const SizedBox(height: 40),

              const Text(

                "LOB Monitoring",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 34,

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(height: 20),

              Text(

                "Monitoring produksi secara real-time, cepat, akurat, dan terintegrasi.",

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.white.withValues(alpha: 0.9),

                  fontSize: 17,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}