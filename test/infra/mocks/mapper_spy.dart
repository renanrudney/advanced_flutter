import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import '../../mocks/fakes.dart';

final class MapperSpy<Dto> implements Mapper<Dto> {
  Json? toDtoInput;
  int toDtoCallsCount = 0;
  int toJsonCallsCount = 0;
  Dto toDtoOutput;
  Dto? toJsonInput;
  Json toJsonOutput = anyJson();

  MapperSpy({
    required this.toDtoOutput
  });

  @override
  Dto toDto(Json json) {
    toDtoInput = json;
    toDtoCallsCount++;
    return toDtoOutput;
  }

  @override
  Json toJson(Dto dto) {
    toJsonInput = dto;
    toJsonCallsCount++;
    return toJsonOutput;
  }
}
