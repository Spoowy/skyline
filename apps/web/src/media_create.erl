-module(media_create).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    HeaderNav = [#panel{class=["hero-foot"], body=[#panel{class=["container"], body=[#nav{class=["tabs", "is-boxed"], body=[#ul{body=[
        #li{body=[#link{href="/admin", body="Admin"}]},
        #li{body=[#link{href="/admin/customers", body="Konten"}]},
        #li{class=["is-active"], body=[#link{href="/admin/media", body="Dateien"}]}
    ]}]}]}]}],
    HeaderSecondaryNav = [#nav{class=["navbar"], body=[#panel{class=["container"], body=[#panel{class=["navbar-tabs"], body=[
        #link{class=["navbar-item", "is-tab"], href="/media", body="Alle"},
        #link{class=["navbar-item", "is-tab", "is-active"], href="/admin/media/create", body="Neu hinzuf&uuml;gen"}
    ]}]}]}],
    Header = index:header("Admin - Neues Material hinzuf&uuml;gen", HeaderNav, HeaderSecondaryNav),
    [#dtl{file = "index", app=web, bindings=[{title,<<"Skyline">>}, {body,Header ++ body() ++ index:footer()},{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}].

body() ->
	[#dtl{file=media_create}].



dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].
