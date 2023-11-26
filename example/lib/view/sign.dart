import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libsodium_pt2_example/view/verify.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/fancy_button.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/shell.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/text_field.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/generate_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/sign_vm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignWidget extends StatefulWidget {
  const SignWidget({super.key});

  @override
  State<SignWidget> createState() => _SignWidgetState();
}

class _SignWidgetState extends State<SignWidget> {
  @override
  Widget build(BuildContext context) {
    return AppShell(child: Consumer2<SignViewModel, GenerateViewModel>(
        builder: (context, signViewModel, generateViewModel, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44),
            child: Text('Sign Your Message',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.44),
              child: TextFieldWidget(
                  controller: signViewModel.messageController,
                  hintText: 'Write the message you want to sign here...')),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          FancyButton(
            size: 18,
            color: const Color(0xffE8E8E8),
            onPressed: () async {
              await signViewModel.signMessage(
                  generateViewModel.keyPair!.secretKey,
                  signViewModel.messageController.text);
              setState(() {});
            },
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Text("Sign",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          if (signViewModel.signatureList != null) ...[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.63),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.23625),
                    child: Text('Signature',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.07875),
                    child: IconButton(
                      splashRadius: 24,
                      splashColor: Colors.white12,
                      padding: const EdgeInsets.only(right: 12),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                            text: signViewModel.signatureBase64 ?? ''));
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.63),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 192),
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(width: 2, color: Colors.black),
                              bottom:
                                  BorderSide(width: 2, color: Colors.black))),
                      child: DefaultTextStyle(
                          style: GoogleFonts.electrolize(
                              fontSize: 12,
                              letterSpacing: 2.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                  signViewModel.signatureBase64 ?? ''),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            const Spacer(),
            ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.63),
                child: DefaultTextStyle(
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        letterSpacing: 2.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    child: AnimatedTextKit(
                      pause: const Duration(seconds: 2),
                      totalRepeatCount: 1,
                      repeatForever: true,
                      animatedTexts: [
                        FadeAnimatedText(
                            'Copy the signature by clicking on it, and keep it somewhere safe. Then press next'),
                      ],
                    ))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.63),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FancyButton(
                  size: 18,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyWidget()));
                  },
                  child: Row(
                    children: [
                      Text("NEXT",
                          style: GoogleFonts.electrolize(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      // SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Transform.rotate(
                        angle: -pi,
                        child: const Icon(
                          Icons.arrow_back_ios,
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
        ],
      );
    }));
  }
}
