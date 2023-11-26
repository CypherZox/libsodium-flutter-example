import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libsodium_pt2_example/view/generate.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/confetti.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/fancy_button.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/shell.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/text_field.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/generate_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/sign_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/veify_vm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyWidget extends StatefulWidget {
  const VerifyWidget({super.key});

  @override
  State<VerifyWidget> createState() => _VerifyWidgetState();
}

class _VerifyWidgetState extends State<VerifyWidget> {
  late ConfettiController confettiController;
  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(child:
        Consumer<VerifyViewModel>(builder: (context, verifyViewModel, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Confetti(controllerCenter: confettiController),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44),
            child: Text('Verify the signature',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44,
                maxHeight: MediaQuery.of(context).size.height * 0.12),
            child: TextFieldWidget(
              controller: verifyViewModel.signatureController,
              hintText: 'Signature...',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44,
                maxHeight: MediaQuery.of(context).size.height * 0.12),
            child: TextFieldWidget(
              controller: verifyViewModel.messageController,
              hintText: 'The signed message...',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44,
                maxHeight: MediaQuery.of(context).size.height * 0.12),
            child: TextFieldWidget(
              controller: verifyViewModel.publicKeyController,
              hintText: 'Your public key...',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          FancyButton(
            size: 18,
            color: const Color(0xffE8E8E8),
            onPressed: () async {
              final signResult = await verifyViewModel.verifyMessage(
                  verifyViewModel.publicKeyController.text.replaceAll(' ', ''),
                  verifyViewModel.signatureController.text.replaceAll(' ', ''),
                  verifyViewModel.messageController.text.replaceAll(' ', ''));
              if (signResult == 0) {
                confettiController.play();
                Future.delayed(Duration(milliseconds: 300))
                    .then((value) => confettiController.stop());
              }
            },
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Text("Verify",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.63),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FancyButton(
                size: 18,
                color: Colors.white,
                onPressed: () {
                  context.read<GenerateViewModel>().keysClear();
                  context.read<SignViewModel>().clearSignature();
                  context.read<VerifyViewModel>().clearVerify();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GenerateKeysWidget()));
                },
                child: Row(
                  children: [
                    Text("START OVER",
                        style: GoogleFonts.electrolize(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Transform.rotate(
                      angle: -pi,
                      child: const Icon(
                        Icons.rotate_left,
                        color: Colors.black87,
                      ),
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }
}
