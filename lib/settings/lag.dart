import '../template/layer.dart';
import '../template/tile.dart';
import '../book/book.dart';

class LagLayer extends Layer {
  @override
  void construct() {
    scroll = true;
    action = Tile('Newest first');
    list = Book().lags.reversed.map((lag) => Tile('$lag  ms'));
  }
}
