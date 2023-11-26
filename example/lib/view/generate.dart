import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libsodium_pt2_example/view/sign.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/fancy_button.dart';
import 'package:flutter_libsodium_pt2_example/view/widgets/shell.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/generate_vm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GenerateKeysWidget extends StatefulWidget {
  const GenerateKeysWidget({super.key});

  @override
  State<GenerateKeysWidget> createState() => _GenerateKeysWidgetState();
}

class _GenerateKeysWidgetState extends State<GenerateKeysWidget> {
  @override
  Widget build(BuildContext context) {
    return AppShell(child:
        Consumer<GenerateViewModel>(builder: (context, generateViewModel, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.44),
            child: Text('Generate Key Pair',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          FancyButton(
            size: 18,
            color: const Color(0xffE8E8E8),
            onPressed: () async {
              await generateViewModel.generateKeys();
              setState(() {});
            },
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Text("Generate your key pairs",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Transform.rotate(
                  angle: 15,
                  child: const Icon(
                    Icons.key,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          if (generateViewModel.base64DecodedPublicKey.isNotEmpty &&
              generateViewModel.base64DecodedSecretKey.isNotEmpty) ...[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.63),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.315),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.23625),
                              child: Text('Public Key',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.07875),
                              child: IconButton(
                                splashRadius: 24,
                                splashColor: Colors.white12,
                                padding: const EdgeInsets.only(right: 12),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: generateViewModel
                                          .base64DecodedPublicKey));
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.25625),
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 2, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 2, color: Colors.black))),
                            child: DefaultTextStyle(
                                style: GoogleFonts.electrolize(
                                    fontSize: 12,
                                    letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TypewriterAnimatedText(generateViewModel
                                        .base64DecodedPublicKey),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.315),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.23625),
                              child: Text('Secret Key',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.07875),
                              child: IconButton(
                                splashRadius: 24,
                                splashColor: Colors.white12,
                                padding: const EdgeInsets.only(right: 12),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: generateViewModel
                                          .base64DecodedSecretKey));
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.25625),
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 2, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 2, color: Colors.black))),
                            child: DefaultTextStyle(
                                style: GoogleFonts.electrolize(
                                    fontSize: 12,
                                    letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TypewriterAnimatedText(generateViewModel
                                        .base64DecodedSecretKey),
                                  ],
                                )),
                          ),
                        ),
                      ],
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
                            'Copy these keys, and keep them somewhere safe. Then press next'),
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
                            builder: (context) => const SignWidget()));
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
