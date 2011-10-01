# 1.0.1 (September 30th, 2011)

* Fixed bug where using #items without an array in parameters caused error.

# 1.0.0 (September 30th, 2011)

* Embedded documents. There is a known issue that generated data (e.g. MongoPopulator.words()) is only generated once per set of embedded documents.

* Static arrays.

* Static dictionaries.

* Backwards-compat breaking API change: to conform better to the mongo gem API, attributes set to `nil` will be set to NULL in the resulting document. To suppress an attribute from a document, use MongoPopulator#skip (see README).

# 0.2.1 (September 14th, 2011)

* MongoArrays are now guaranteed unique.

# 0.2.0 (September 14th, 2011)

* an attribute set to nil (directly or randomly via an array) will not appear in the resulting document.

# 0.1.1 (September 14th, 2011)

* remove required minimum RubyGems version.

# 0.1.0 (September 14th, 2011)

* initial release based on fork of http://github.com/ryanb/populator.
