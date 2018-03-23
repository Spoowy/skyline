-ifndef(CATEGORY_HRL).
-define(CATEGORY_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(category, {?ITERATOR(feed),
					handle=[],
					name=[]}).

-endif.
