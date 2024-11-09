import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class PhraseLayer extends Layer {
  @override
  void construct() {
    String syllables = '';
    for (String point in Pref.syllables.value) {
      syllables = syllables + point;
    }

    action = Tile.fromPref(Pref.phraseMultiplier, suffix: ' x Cursor',
        onPrefInput: (i) {
      Pref.phraseMultiplier.set(int.parse(i).clamp(1, 10000));
    });
    list = [
      Tile.fromPref(Pref.phraseOpacity, suffix: '%', onPrefInput: (i) {
        Pref.phraseOpacity.set(int.parse(i).clamp(0, 100));
      }),
      Tile.fromListPref(Pref.phraseBreaks),
    ];
  }
}
