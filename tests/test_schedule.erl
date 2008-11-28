-module(test_schedule).
-include_lib("eunit/include/eunit.hrl").


start_enabled_test() ->
    StartTime = urlcron_util:get_future_time(60000),
    {ok, Pid} = urlcron_schedule:start_link(StartTime, "url", enabled),
    Timer = urlcron_schedule:get_timer(Pid),
    Status = urlcron_schedule:get_status(Pid),
    ?assertEqual({StartTime, "url", Timer, inactive_enabled}, Status),
    urlcron_schedule:stop(Pid).

start_disabled_test() ->
    StartTime = urlcron_util:get_future_time(60000),
    {ok, Pid} = urlcron_schedule:start_link(StartTime, "url", disabled),
    Status = urlcron_schedule:get_status(Pid),
    ?assertEqual({StartTime, "url", none, inactive_disabled}, Status),
    urlcron_schedule:stop(Pid).

schedule_runs_and_exists_test() ->
    StartTime = urlcron_util:get_future_time(1000),
    {ok, Pid} = urlcron_schedule:start_link(StartTime, "url", enabled),
    ?assert(is_process_alive(Pid) == true),
    timer:sleep(2000),
    ?assert(is_process_alive(Pid) == false).

