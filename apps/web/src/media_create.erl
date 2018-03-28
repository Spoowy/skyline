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

event(init)->
    wf:reg(n2o_session:session_id()),
    wf:info(?MODULE,"~n~n~n~n~n~n~n~n~n~n~nBinary DONE~n~n~n~n~n~n~n~n~n~n~n~n~n~n",[]),
    %wf:update(mediumUrl,#input{id=mediumUrl, class=["input", "is-medium"], value=["Awesome"]}),
    wf:update(upload,#upload{id=upload}),
    wf:update(upload2,#upload{id=upload2});

event(#bin{data=Data}) ->
    wf:info(?MODULE,"Binary Delivered ~p~n",[Data]),
    wf:info(?MODULE,"~n~n~n~n~n~n~n~n~n~n~nBinary DONE~n~n~n~n~n~n~n~n~n~n~n~n~n~n",[]),
    #bin{data = "SERVER"};

event(#ftp{sid=Sid,filename=Filename,status={event,stop}}=Data) ->
    % Fixme: if same file is present file will not be uploaded!
    wf:info(?MODULE,"FTP Delivered ~p~n",[Data]),
    Name = hd(lists:reverse(string:tokens(wf:to_list(Filename),"/"))),
    Path = iolist_to_binary(["/static/",Sid,"/",wf:url_encode(Name)]),
    erlang:put(message,wf:render(#link{href=iolist_to_binary(["/static/",Sid,"/",wf:url_encode(Name)]),body=Name})),
    %wf:info(?MODULE,"Message ~p~n",[wf:q(message)]),
    wf:info(?MODULE,"~n~n~n~n~n~n~n~n~n~n~nFTP DONE~n~n~n~n~n~n~n~n~n~n~n~n~n~n",[]),
    % Update dom input <input id="mediumUrl" class="input is-medium" type="text" placeholder="Link">
    wf:update(mediumUrl,#input{id=mediumUrl, class=["input", "is-medium"], value=Path, placeholder=["Link"]});
    % Todo: if jpeg or png, create thumbnail from file and put it into thumbnail url
    %event(chat);

event(Event) ->
    wf:info(?MODULE,"Event: ~p", [Event]),
    ok.



dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].
