import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class CursorLayer extends Layer {
  @override
  void construct() {
    String syllables = '';
    for (String point in Pref.syllables.value) {
      syllables = syllables + point;
    }

    action = Tile.fromPref(Pref.intensity, onPrefInput: (i) {
      Pref.intensity.set(int.parse(i).clamp(0, double.infinity).toInt());
    });
    list = [
      Tile.fromPref(Pref.cursorAnimation, suffix: 'ms', onPrefInput: (i) {
        Pref.cursorAnimation.set(int.parse(i).clamp(0, 10000));
      }),
      Tile.fromPref(Pref.cursorOuter, suffix: 'x', onPrefInput: (i) {
        Pref.cursorOuter.set(int.parse(i).clamp(0, 10000));
      }),
      Tile.fromPref(Pref.exponential),
      Tile.fromPref(Pref.cursorShift),
      Tile.fromListPref(Pref.syllables),
      Tile.fromListPref(Pref.breakpoints),
    ];
  }
}
