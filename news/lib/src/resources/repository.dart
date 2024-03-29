import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';


class Repository {
  List<Source> sources = <Source>[
    newsDbProvier,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvier,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIDs();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;

    for(source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for(var cache in caches) {
      if ( source != (cache as Source)) {
        cache.addItem(item);
      }
    }

    return item;
    // var item = await dbProvier.fetchItem(id);
    // if (item !=null){
    //   return item;
    // }

    // item = await apiProvider.fetchItem(id);
    // await dbProvier.addItem(item);

    // return item;
  }

  clearCache() async{
    for (var cache in caches) {
      await cache.clear();
    }
  }

}

abstract class Source {
  Future<List<int>> fetchTopIDs();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}