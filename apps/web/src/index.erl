-module(index).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    HeaderNav = [#panel{class=["hero-foot"], body=[#panel{class=["container"], body=[#nav{class=["tabs", "is-boxed"], body=[#ul{body=[
        #li{class=["is-active"], body=[#link{href="/", body="&Uuml;bersicht"}]},
        #li{body=[#link{href="/media?s=marketing", body="Marketing Material"}]}
    ]}]}]}]}],
    %%HeaderSecondaryNav = [#nav{class=["navbar"], body=[#panel{class=["container"], body=[#panel{class=["navbar-tabs"], body=[
    %%    #link{class=["navbar-item", "is-tab", "is-active"], href="/media", body="Alle"},
    %%    #link{class=["navbar-item", "is-tab"], href="/media?s=facebook_post", body="Facebook Post"}
    %%]}]}]}],
    Header = header("&Uuml;bersicht", HeaderNav, []),
    [#dtl{file = "index", app=web, bindings=[{title,<<"Skyline">>}, {body,Header ++ body() ++ footer()},{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}].

body() ->
	[#dtl{file="dashboard", app=web}].

header(Title, HeroNav, HeroSecondaryNav) ->
    %% Build admin nav
    Navbar = [#panel{class=[<<"navbar-item">>, <<"has-dropdown">>, <<"is-hoverable">>], body=[
        #link{class=[<<"navbar-link">>], href="/admin", body="Admin"},
        #panel{class=[<<"navbar-dropdown">>, "is-boxed"], body=[
            #link{class=[<<"navbar-item">>], href="/admin", body="&Uuml;bersicht"},
            #link{class=[<<"navbar-item">>], href="/admin/customers", body="Alle Kunden"},
            #link{class=[<<"navbar-item">>], href="/admin/customers/create", body=[#span{class="icon", body=[#i{class=["fas", "fa-plus"]}]}, "&nbsp;Neues Konto"]},
            #link{class=[<<"navbar-item">>], href="/admin/media", body="Alle Dateien"},
            #link{class=[<<"navbar-item">>], href="/admin/media/create", body=[#span{class="icon", body=[#i{class=["fas", "fa-plus"]}]}, "&nbsp;Neue Datei"]}
        ]}
    ]},

    %% Dateien
    #panel{class=[<<"navbar-item">>, <<"has-dropdown">>, <<"is-hoverable">>], body=[
        #link{class=[<<"navbar-link">>], href="/admin", body="Dateien"},
        #panel{class=[<<"navbar-dropdown">>, "is-boxed"], body=[
            #link{class=[<<"navbar-item">>], href="/media", body="Alle"},
            %% Loop through categories
            #link{class=[<<"navbar-item">>], href="/media?s=facebook", body=["Neue Datei"]}
        ]}
    ]}],

    [#dtl{file="header", app=web, bindings=[{title, Title}, {navbar, Navbar}, {heroFoot, HeroNav}, {heroSecondaryNav, HeroSecondaryNav}]}].

footer()->
    [#dtl{file="footer", app=web}].

dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].
