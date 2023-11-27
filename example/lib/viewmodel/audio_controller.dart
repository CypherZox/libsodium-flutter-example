import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioController extends ChangeNotifier {
  static AudioPlayer player = AudioPlayer();
  final AssetSource buttonClick = AssetSource("interface-124464.mp3");

  final AssetSource approved =
      AssetSource("mixkit-ethereal-fairy-win-sound-2019.wav");
  final AssetSource fail = AssetSource("mixkit-losing-drums-2023.wav");
  final AssetSource collect = AssetSource("mixkit-collect-material-3209.wav");

  playButton() {
    player.play(buttonClick).then((value) {});
  }

  playCopy() {
    player.play(collect);
  }

  playApproved() {
    player.play(approved);
  }

  playFail() {
    player.play(fail);
  }
}
