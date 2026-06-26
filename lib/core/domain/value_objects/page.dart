import 'package:collection/collection.dart';

class PageRequest {
  factory PageRequest({int limit = 50, int offset = 0}) {
    if (limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'Must be positive');
    }
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Cannot be negative');
    }
    return PageRequest._(limit: limit, offset: offset);
  }

  const PageRequest._({required this.limit, required this.offset});

  final int limit;
  final int offset;

  PageRequest next() => PageRequest(limit: limit, offset: offset + limit);

  @override
  bool operator ==(Object other) {
    return other is PageRequest &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(limit, offset);
}

class Page<T> {
  Page({required List<T> items, required this.request, required this.total})
    : items = List.unmodifiable(items) {
    if (total < 0 || total < request.offset + this.items.length) {
      throw ArgumentError.value(total, 'total', 'Inconsistent page total');
    }
  }

  final List<T> items;
  final PageRequest request;
  final int total;

  bool get hasNext => request.offset + items.length < total;
  PageRequest? get nextRequest => hasNext ? request.next() : null;

  @override
  bool operator ==(Object other) {
    return other is Page<T> &&
        const ListEquality<Object?>().equals(other.items, items) &&
        other.request == request &&
        other.total == total;
  }

  @override
  int get hashCode =>
      Object.hash(const ListEquality<Object?>().hash(items), request, total);
}
