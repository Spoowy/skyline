-module(media).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    HeaderNav = [#panel{class=["hero-foot"], body=[#panel{class=["container"], body=[#nav{class=["tabs", "is-boxed"], body=[#ul{body=[
        #li{body=[#link{href="/", body="&Uuml;bersicht"}]},
        #li{class=["is-active"], body=[#link{href="/media?s=marketing", body="Marketing Material"}]}
    ]}]}]}]}],
    HeaderSecondaryNav = [#nav{class=["navbar"], body=[#panel{class=["container"], body=[#panel{class=["navbar-tabs"], body=[
        #link{class=["navbar-item", "is-tab", "is-active"], href="/media", body="Alle"},
        #link{class=["navbar-item", "is-tab"], href="/media?s=facebook_post", body="Facebook Post"}
    ]}]}]}],
    Header = index:header("Marketing Material", HeaderNav, HeaderSecondaryNav),
    [#dtl{file = "index", app=web, bindings=[{title,<<"Skyline">>}, {body,Header ++ body() ++ index:footer()},{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}].

body() ->
	[#panel{class=["is-fancy", "is-fullheight", "hero"], body=[#panel{class=["container", "is-fluid", "row-outer-7"], body=[
        #panel{class=["columns", "is-multiline", "is-desktop"], body=[
            #dtl{file=mediapreview}
        ]}
    ]}]}].



dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].
