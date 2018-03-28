-module(media).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/user.hrl").
-include_lib("skyline.hrl").

main() ->
    CurrentSection = currentSection(),
    HeaderNav = [#panel{class=["hero-foot"], body=[#panel{class=["container"], body=[#nav{class=["tabs", "is-boxed"], body=[#ul{body=[
        #li{body=[#link{href="/", body="&Uuml;bersicht"}]},
        #li{class=["is-active"], body=[#link{href="/media", body="Marketing Material"}]}
    ]}]}]}]}],
    HeaderSecondaryNav = [#nav{class=["navbar"], body=[#panel{class=["container"], body=[#panel{class=["navbar-tabs"], body=[
        % Alle Navbar item
        #link{class=["navbar-item", "is-tab", [case wf:to_list(CurrentSection#category.handle) of "alle" -> "is-active"; _->"" end]], href="/media", body="Alle"},
        % Loop categories
        [event({client,{E#category.id,E#category.handle,E#category.name}}) || E <- index:categories()]
    ]}]}]}],
    Header = index:header("Marketing Material - " ++ wf:to_list(CurrentSection#category.name), HeaderNav, HeaderSecondaryNav),
    [#dtl{file = "index", app=web, bindings=[{title,<<"Skyline">>}, {body,Header ++ body() ++ index:footer()},{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}].

body() ->
	[#panel{class=["is-fancy", "is-fullheight", "hero"], body=[#panel{class=["container", "is-fluid", "row-outer-7"], body=[
        #panel{class=["columns", "is-multiline", "is-desktop"], body=[
            [#dtl{file=mediapreview, bindings=[{type, M#media.type}, {name, M#media.name}, {thumbnail, M#media.thumbnail_path}]} || M <- media()]
        ]}
    ]}]}].

checkAccess (User, Category)->
    ok.

currentSection () ->
    AlleRecord = #category{id = 1,container = feed,feed_id = [],prev = [],next = [],feeds = [],handle = [<<"alle">>],name = [<<"Alle">>]},
    case wf:q("s") of undefined ->
        AlleRecord;
    _->
        Sid = wf:to_integer(wf:q("s")),
        case kvs:get(category, Sid) of
            {ok, S} ->
                S;
            Err ->
                AlleRecord
        end
    end.

media(CategoryId) ->
    Media = [case kvs:get(media, M#media.id) of {ok, R} -> R; _-> ok end || M <- kvs:all(media), M#media.category == CategoryId].

media() ->
    CurrentSection = currentSection(),
    case CurrentSection#category.id of 1 ->
        % Fixme: Not returning a #media record but lists
        %[media(C#category.id) || C <- index:categories()];
        kvs:all(media);
    _->
        media(CurrentSection#category.id)
    end.

dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].

event(#client{data={Id,Handle,Name}}) ->
    Section = currentSection(),
    CategoryId = wf:to_list(Id),
    CurrentCategoryId = wf:to_list(Section#category.id),
    IsActive = case CurrentCategoryId of CategoryId -> "is-active"; _ -> "" end,
    #link{class=["navbar-item", "is-tab", IsActive], href="/media?s=" ++ wf:to_list(Id), body=Name}.
