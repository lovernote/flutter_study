import 'dart:async';

import 'package:flutter_study/model/search_model.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final SearchApi api;

  //初始化
  Stream<List<SearchModel>> _results = Stream.empty();

  Stream<String> _log = Stream.empty();

  ReplaySubject<String> _query = ReplaySubject<String>();

  Stream<String> get log => _log;

  Stream<List<SearchModel>> get results => _results;

  Sink<String> get query => _query;


  SearchBloc(this.api) {

    _results =
        _query.distinct().asyncMap(api.getSearchResult).map((value) => (!value
            .error && null != value.results && value.results.length > 0) ? value
            .results : null).asBroadcastStream();


    _log = Observable(results)
        .withLatestFrom(_query.stream, (_, query) => '当前搜索的关键字： $query')
        .asBroadcastStream();
  }

  void dispose() {
    _query.close();
  }
}