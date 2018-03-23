-module(config).
-compile(export_all).
-include_lib("kvs/include/metainfo.hrl").
-include_lib("kvs/include/kvs.hrl").
-include_lib("kvs/include/feed.hrl").
-include_lib("skyline.hrl").

metainfo() ->
    #schema{name=web,tables=[
      #table{name=category,fields=record_info(fields, category)},
      #table{name=media,fields=record_info(fields, media)},
      #table{name=user_category_access,fields=record_info(fields,user_category_access),keys=[user]},
      #table{name=user_download_log,fields=record_info(fields,user_download_log),keys=[user]}
    ]}.

log_level() -> info.
log_modules() -> % any
  [
    login,
%    wf_convert,
%    n2o_file,
    n2o_async,
    n2o_proto,
%    n2o_client,
%    n2o_static,
    n2o_stream,
    n2o_nitrogen,
    n2o_session,
    kvs,
    store_mnesia,
    index
  ].
