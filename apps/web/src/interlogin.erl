-module(interlogin).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/user.hrl").
-include_lib("avz/include/avz.hrl").

-define(LOGIN, [facebook, twitter, google]).

main() ->
 avz:callbacks(?LOGIN),
 #dtl{file="login",app=web,bindings=[{title,<<"Login">>},{body,body()}]}.

body() ->
    header()++
  [#panel{class=login, body=[
    avz:buttons(?LOGIN)
  ]} | avz:sdk(?LOGIN)].

event(init) ->
    wf:wire(#jq{target=loginfb, method=["classList.add"], args=["'button','is-medium','row-space-right-2','is-link'"]}),
    wf:wire(#jq{target=twlogin, method=["classList.add"], args=["'button','is-medium','row-space-right-2'"]}),
    wf:wire(#jq{target=gloginbtn, method=["classList.add"], args=["'google-button'"]});

event({register, U=#user{}}) ->
  case kvs:add(U#user{id=kvs:next_id("user",1)}) of
    {ok, U1} -> avz:login_user(U1);
    {error,E} -> event({login_failed,E}) end;

event({login, #user{}=U, N}) ->
  Updated = avz:merge(U,N),
  ok = kvs:put(Updated),
  avz:login_user(Updated);

event({login_failed, E}) ->
  wf:update(display, #span{id=display, body=[E] });

event(X) -> wf:info(?MODULE,"Event:~p~n",[X]),avz:event(X).
api_event(X,Y,Z) -> avz:api_event(X,Y,Z).

header() ->
  [#header{class=[header], body=[
    #h1{class=title, body="SkylineCircle - Kundenlogin"},
    #hr{}
  ]}].

%
footer() -> #footer{class=[footer], body=[ <<"&copy; 2017">> ]}.
