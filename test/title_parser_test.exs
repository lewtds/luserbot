defmodule LuserBot.HTMLTitleParser.Test do
  use ExUnit.Case
  import LuserBot.HTMLTitleParser

  test "nice HTML" do
    title = parse """
    <html>
    <head>
    <title>Hello</title>
    </head>
    </html>
    """

    assert title == "Hello"
  end

  test "non-ending HTML" do
    title = parse """
    <html>
    <head>
    <title>Hello</title>
    """

    assert title == "Hello"
  end

  test "medium.com" do
    title = parse """

    <!DOCTYPE html><html xmlns:cc="http://creativecommons.org/ns#"><head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# medium-com: http://ogp.me/ns/fb/medium-com#"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Father, Professor — Medium</title><link rel="canonical" href="https://medium.com/@huyentran/father-professor-39cb026bc8b7"><meta name="title" content="Father, Professor"><meta name="referrer" content="always"><meta name="description" content="8-hour-lecture, 4-hour-sleep daily. Homework. Coding. Group project. Part-time job. Charity class. Me — sometime, somewh…"><meta property="og:site_name" content="Medium"><meta property="og:title" content="Father, Professor"><meta property="og:url" content="https://medium.com/@huyentran/father-professor-39cb026bc8b7"><meta property="og:image" content="https://cdn-images-
    """

    assert title == "Father, Professor — Medium"
  end

  test "stackoverflow.com" do
    # Failing test case because of the "itemscope" HTML5-style attribute
    title = parse """
<!DOCTYPE html>
<html itemscope itemtype="http://schema.org/QAPage">
<head>

<title>node.js - Running an IRC bot on Heroku - Stack Overflow</title>
    <link rel="shortcut icon" href="//cdn.sstatic.net/stackoverflow/img/favicon.ico?v=4f32ecc8f43d">
    <link rel="apple-touch-icon image_src" href="//cdn.sstatic.net/stackoverflow/img/apple-touch-icon.png?v=c78bd457575a">
    <link rel="search" type="application/opensearchdescription+xml" title="Stack Overflow" href="/opensearch.xml">
    <meta name="twitter:card" content="summary">
    <meta name="twitter:domain" content="stackoverflow.com"/>
    <meta property="og:type" content="website" />    
    <meta property="og:image" itemprop="image primaryImageOfPage" content="http://cdn.sstatic.net/stackoverflow/img/apple-touch-icon@2.png?v=73d79a89bded&a" />
    <meta name="twitter:title" property="og:title" itemprop="title name" content="Running an IRC bot on Heroku" />
    <meta name="twitter:description" property="og:description" itemprop="description" content="I&#39;ve got my bot up and running, and I would like it to run on Heroku to keep it persistently connected to our IRC-channel. This is the content of my procfile:

web: coffee marvin.coffee
    """

    assert title == "node.js - Running an IRC bot on Heroku - Stack Overflow"
  end

  test "FluxBB" do
    title = parse """
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Help with Firestarter set up / Newbie Corner / Arch Linux Forums</title>
    <link rel="stylesheet" type="text/css" href="style/ArchLinux.css" />
    <link rel="canonical" href="viewtopic.php?id=20754" title="Page 1" />
    <link rel="alternate" type="application/atom+xml" href="extern.php?action=feed&amp;tid=20754&amp;type=atom" title="Atom topic feed" />
    <link rel="stylesheet" media="screen" href="style/ArchLinux/arch.css?v=3" />
    <link rel="stylesheet" media="screen" href="style/ArchLinux/archnavbar.css?v=2" />
    <link rel="shortcut icon" href="style/ArchLinux/favicon.ico" />
    </head>
    """

    assert title == "Help with Firestarter set up / Newbie Corner / Arch Linux Forums"
  end

  test "multiline title" do
    title = parse """
    <title>haha
    hihi
    </title>
    """

    assert title == """
    haha
    hihi
    """
  end
end
