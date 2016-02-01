defmodule LuserBotTest do
  use ExUnit.Case
  import LuserBot.MyWorker
  doctest LuserBot

  test "recognize HTTP URL pattern" do
    assert extract_urls("http://cool.com") == ["http://cool.com"]
    assert extract_urls("message before http://cool.com") == ["http://cool.com"]
    assert extract_urls("http://cool.com message after") == ["http://cool.com"]
    assert extract_urls("https://cool.com message after") == ["https://cool.com"]
    assert extract_urls("https://cool.vn message after") == ["https://cool.vn"]
    assert extract_urls("https://cool.co.uk message after") == ["https://cool.co.uk"]
    assert extract_urls("http://google.com ahah https://cool.co.uk message after") == ["http://google.com", "https://cool.co.uk"]

    assert extract_urls("http://www.dhgate.com/wholesale/drone+kit.html") == ["http://www.dhgate.com/wholesale/drone+kit.html"]

    assert extract_urls("https://cool message after") == ["https://cool"]

    assert extract_urls("https:cool.com message after") == []
  end
end
