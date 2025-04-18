import 'package:advanced_flutter/infra/repositories/load_next_event_from_api_with_cache_fallback_repo.dart';
import 'package:advanced_flutter/main/factories/infra/api/repositories/load_next_event_api_repo_factory.dart';
import 'package:advanced_flutter/main/factories/infra/cache/adapters/cache_manager_adapter_factory.dart';
import 'package:advanced_flutter/main/factories/infra/cache/repositories/load_next_event_cache_repo_factory.dart';
import 'package:advanced_flutter/main/factories/infra/mappers/next_event_mapper_factory.dart';

LoadNextEventFromApiWithCacheFallbackRepository makeLoadNextEventFromApiWithCacheFallbackRepository() {
  return LoadNextEventFromApiWithCacheFallbackRepository(
    loadNextEventFromCache: makeLoadNextEventCacheRepository().loadNextEvent,
    loadNextEventFromApi: makeLoadNextEventApiRepository().loadNextEvent,
    cacheClient: makeCacheManagerAdapter(),
    key: 'next_event',
    mapper: makeNextEventMapper()
  );
}
