-ifndef(FORMS_META_HRL).
-define(FORMS_META_HRL, "meta_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(document,   { ?ITERATOR(feed), name=[], base=[], sections=[], fields=[], buttons=[], access=[], steps=[] }).
-record(validation, { name, type, msg, extract = fun(X) -> X end, options=[], function, field={record,pos} }).
-record(sec,        { id, name=[], desc=[], nameClass=[], descClass=small }).
-record(but,        { id, href, target, postback, name, title, sources=[], class, onclick, validation="preloadWithTimeout(this);" }).
-record(opt,        { id, name, title, postback, checked=false, disabled=false, noRadioButton=false }).
-record(sel,        { id, name, title, postback }).
-record(field,      { id, raw, sec=1, name, pos, title, layout, visible=true, disabled=false, format="~w", curr="",
                      postfun=[], desc, wide=normal, type=binary, etc, labelClass=label, fieldClass=field, boxClass=box,
                      access, tooltips=[], options=[], min=0, max=1000000, length=10, postback, onchange, validation }).

-endif.
