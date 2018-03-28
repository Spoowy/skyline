-module(index).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/user.hrl").
-include_lib("skyline.hrl").

main() ->
    case wf:user() of
      undefined ->
        wf:redirect({http, "/login"});
    _->
        %kvs:put(#user_category_access{id=kvs:next_id(user_category_access, 1), user=6, category=13}),
        %kvs:put(#media{id=kvs:next_id(media, 1), name="Flyer text 1", category=5, type="Bild",
        %    file_path="https://images.unsplash.com/photo-1444658293155-105ae40f8278?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e5789724d9fc8af0f7c5f4d9ff9c7f42&auto=format",
    %        thumbnail_path="https://images.unsplash.com/photo-1444658293155-105ae40f8278?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e5789724d9fc8af0f7c5f4d9ff9c7f42&auto=format&fit=crop&w=640&h=480&q=60"
    %    }),
        HeaderNav = [#panel{class=["hero-foot"], body=[#panel{class=["container"], body=[#nav{class=["tabs", "is-boxed"], body=[#ul{body=[
            #li{class=["is-active"], body=[#link{href="/", body="&Uuml;bersicht"}]},
            #li{body=[#link{href="/media", body="Marketing Material" }]}
        ]}]}]}]}],
        Header = header("&Uuml;bersicht", HeaderNav, []),
        [#dtl{file = "index", app=web, bindings=[{title,<<"Skyline">>}, {body,Header ++ body() ++ footer()},{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}]
    end.

body() ->
	[#dtl{file="dashboard", app=web}].

header(Title, HeroNav, HeroSecondaryNav) ->
    case wf:user() of
      undefined ->
        wf:redirect({http, "/login"});
      User ->
        Email = wf:to_list(User#user.email),
        Avatar = case User#user.images of [] -> "holder.js/50x50"; [{_,A}|_] -> wf:to_list(A) end,
        Name = wf:to_list(User#user.names) ++ " " ++ wf:to_list(User#user.surnames),
        Navbar = [
        % Admin
        #panel{class=[<<"navbar-item">>, <<"has-dropdown">>, <<"is-hoverable">>], body=[
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
                [event({client,{E#category.id,E#category.handle,E#category.name}}) || E <- index:categories()]
            ]}
        ]}],

        NavbarRight = [
            #link{href="/profile", class=["profile-button", "button", "is-white", "is-large"], body=[
                #span{class=["avatar", "icon"], style=["background-image: url(" ++ Avatar ++ ")"]},
                #span{class=["inline-block"], style=["font-size:0.7em"], body=Name}
            ]}
        ],

        [#dtl{file="header", app=web, bindings=[{title, Title}, {navbar, Navbar}, {navbarRight, NavbarRight}, {heroFoot, HeroNav}, {heroSecondaryNav, HeroSecondaryNav}]}]
    end.

footer()->
    [#dtl{file="footer", app=web, bindings=[{javascript,(?MODULE:(wf:config(n2o,mode,dev)))()}]}].

dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].

categories() ->
    User = wf:user(),
    % Get categories user has access to
    % AccessRecords = kvs:all(user_category_access),
    %MatchingAccessRecords = [find_category_access(AccessRecords, 6) || AccessRecords <- kvs:all(user_category_access)],
    %MatchingAccessRecords = [wf:info(?MODULE, "~n~n~n~n~n~n~n~n loop: ~p~n~n~n~n~n~n~n", [AccessRecords]) || AccessRecords
    %    <- lists:keyfind(6, #user_category_access.user, kvs:all(user_category_access))],

    MatchingAccessRecords = [case kvs:get(category, AccessRecords#user_category_access.category) of {ok, Record} -> Record; _-> ok end || AccessRecords <- kvs:all(user_category_access), AccessRecords#user_category_access.user == User#user.id],

    %wf:info(?MODULE, "~n~n~n~n~n~n~n~n MatchingAccessRecords: ~p~n~n~n~n~n~n~n~n",[MatchingAccessRecords]),
    %wf:info(?MODULE, "~n~n~n~n~n~n~n~nuser: ~p~n~n~n~n~n~n~n~n",[User#user.id]),
    F = fun(X, Y) -> {X#category.id} < {Y#category.id} end,
    lists:sort(F, MatchingAccessRecords).

find_category_access([#user_category_access{user=User, category=Category} | _], User) ->
    {found,  Category};
find_category_access([_| T], User) ->
    find_category_access(T, User);
find_category_access([], User) ->
    not_found.

event(#client{data={Id,Handle,Name}}) ->
    #link{class=[<<"navbar-item">>], href="/media?s=" ++ wf:to_list(Id), body=Name}.
