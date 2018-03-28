-module(setup).
-compile(export_all).
-include_lib("skyline.hrl").

init () ->
	%% Create records for Categories
	kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Fotos">>], handle=[<<"fotos">>]}),
    kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Instagram Post">>], handle=[<<"instagram_post">>]}),
    kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Flyer">>], handle=[<<"flyer">>]}),
    kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Banner">>], handle=[<<"banner">>]}),
    kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Zeitungsanzeige">>], handle=[<<"zeitungsanzeige">>]}),
    %kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Fotos - 8er - Zirkel">>], handle=[<<"fotos_8er">>]}),
    %kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Fotos - 6er - Zirkel">>], handle=[<<"fotos_6er">>]}),
    %kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Fotos - 4er - Zirkel">>], handle=[<<"fotos_4er">>]}),
    %kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Fotos - All-in-one - Zirkel">>], handle=[<<"fotos_all_in_one">>]}),
    kvs:put(#category{id=kvs:next_id(category,1), name=[<<"Videos">>], handle=[<<"videos">>]}),
	ok.
