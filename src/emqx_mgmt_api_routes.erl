%%--------------------------------------------------------------------
%% Copyright (c) 2015-2017 EMQ Enterprise, Inc. (http://emqtt.io).
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_mgmt_api_routes).

-author("Feng Lee <feng@emqtt.io>").

-include_lib("emqx/include/emqx.hrl").

-rest_api(#{name   => list_routes,
            method => 'GET',
            path   => "/routes/",
            func   => list,
            descr  => "List routes"}).

-rest_api(#{name   => lookup_routes,
            method => 'GET',
            path   => "/routes/:bin:topic",
            func   => lookup,
            descr  => "Lookup routes to a topic"}).

-export([list/2, lookup/2]).

list(Bindings, Params) when map_size(Bindings) == 0 ->
    {ok, emqx_mgmt_api:paginate(mqtt_route, Params, fun format/1)}.

lookup(#{topic := Topic}, _Params) ->
    {ok, [format(R) || R <- emqx_mgmt:lookup_routes(Topic)]}.

format(#mqtt_route{topic = Topic, node = Node}) ->
    #{topic => Topic, node => Node}.
