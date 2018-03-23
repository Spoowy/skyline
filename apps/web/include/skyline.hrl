-ifndef(SKYLINE_HRL).
-define(SKYLINE_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(category, {?ITERATOR(feed),
					handle=[],
					name=[]}).

-record(media, {?ITERATOR(feed),
					name=[],
					category=[],
					type=[],
					file_path=[],
					thumbnail_path=[],
					date_created=[] }).

-record(user_category_access, {?ITERATOR(feed),
					user_id=[],
					categories=[] }).

-record(user_download_log, {?ITERATOR(feed),
					user_id=[],
					media_id=[],
					date=[] }).
-endif.
