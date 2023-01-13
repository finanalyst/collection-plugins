#!/usr/bin/env raku
use v6.d;
%(
    'source-wrap' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <!DOCTYPE html>
        <html lang="{ %prm<config><lang> }"
            class="fontawesome-i2svg-active fontawesome-i2svg-complete">
        { %tml<head-block>.(%prm, %tml) }
        <body class="has-navbar-fixed-top">
        { %tml<top-of-page>.(%prm, %tml) }
        { %tml<header>.(%prm, %tml)  }
        { %tml<sidebar>.(%prm, %tml)  }
        { %tml<wrapper>.(%prm, %tml)  }
        <div id="raku-repl"></div>
        { %tml<footer>.(%prm, %tml)  }
        { %tml<js-bottom>.({}, {}) }
        { %tml<end-block>.(%prm, %tml) }
        BLOCK
    },
    'header' => sub (%prm, %tml) {
        q:to/BLOCK/
        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
          <div class="container">
            <div class="navbar-brand navbar-logo">
              <div class="navbar-logo">
                <a class="navbar-item" href="/">
                  <img src="/assets/images/camelia-recoloured.png" alt="Raku" width="52.83" height="38">
                </a>
                <div class="navbar-logo-tm">tm</div>
              </div>
              <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navMenu">
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
              </a>
            </div>
            <div id="navMenu" class="navbar-menu">
              <div class="navbar-start">
                  <a class="navbar-item" href="/language.html">
                    Language
                  </a>
                  <a class="navbar-item" href="/type.html">
                    Types
                  </a>
                  <a class="navbar-item" href="/routine.html">
                    Routines
                  </a>
                  <a class="navbar-item" href="/programs.html">
                    Programs
                  </a>
                <a class="navbar-item" href="https://raku.org">
                  Raku Homepage
                </a>
                <a class="navbar-item" href="https://webchat.freenode.net/?channels=#raku">
                  Chat with us
                </a>
                <div class="navbar-item has-dropdown is-hoverable">
                  <a class="navbar-link">
                    More
                  </a>
                  <div class="navbar-dropdown">
                    <a class="navbar-item" href="/search.html">
                      Extended Search
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item" href="/about.html">
                      About
                    </a>
                  </div>
                </div>
              </div>

            <div class="navbar-end navbar-search-wrapper">
                <div class="navbar-item">
                  <div class="field has-addons">
                    <div id="search" class="control">
                      <input id="query" class="input ui-autocomplete-input" type="text" placeholder="🔍" autocomplete="off">
                    </div>
                    <div class="control">
                      <a class="button is-primary">
                        <span class="icon">
                          <svg class="svg-inline--fa fa-search fa-w-16" aria-hidden="true" data-prefix="fas" data-icon="search" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M505 442.7L405.3 343c-4.5-4.5-10.6-7-17-7H372c27.6-35.3 44-79.7 44-128C416 93.1 322.9 0 208 0S0 93.1 0 208s93.1 208 208 208c48.3 0 92.7-16.4 128-44v16.3c0 6.4 2.5 12.5 7 17l99.7 99.7c9.4 9.4 24.6 9.4 33.9 0l28.3-28.3c9.4-9.4 9.4-24.6.1-34zM208 336c-70.7 0-128-57.2-128-128 0-70.7 57.2-128 128-128 70.7 0 128 57.2 128 128 0 70.7-57.2 128-128 128z"></path></svg><!-- <i class="fas fa-search "></i> -->
                        </span>
                      </a>
                    </div>
                  </div>
                </div>

                <div id="navbar-search" class="navbar-search-autocomplete" style="display: none;">
                    <ul id="ui-id-1" tabindex="0" class="ui-menu ui-widget ui-widget-content ui-autocomplete ui-front" style="display: none;"></ul>
                </div>
              </div>
            </div>
          </div>
        </nav>
        BLOCK
    },
    'sidebar' => sub (%prm, %tml) {
        return '' unless %prm<toc>;
        qq:to/BLOCK/
        <div class="raku-sidebar-toggle" style="">
          <a class="button is-primary">
            <span class="icon">
              <i class="fas fa-chevron-left is-medium"></i>
            </span>
          </a>
        </div>
        <div id="mainSidebar" class="raku-sidebar" style="width:0px; display:none;">
          <div class="field">
            <label class="label has-text-centered">Table of Contents</label>
            <div class="control has-icons-right">
              <input id="toc-filter" class="input" type="text" placeholder="Filter">
              <span class="icon is-right has-text-grey">
                <i class="fas fa-search is-medium"></i>
              </span>
            </div>
          </div>
          <div class="raku-sidebar-body">
            <aside id="toc-menu" class="menu">
            { %prm<toc> }
            </aside>
          </div>
        </div>
        BLOCK
    },
    'wrapper' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <div id="wrapper">
        { %tml<page-header>.(%prm, %tml)  }
        { %tml<page-content>.(%prm, %tml)  }
        { %tml<page-footnotes>.(%prm, %tml)  }
        { %tml<page-generated>.(%prm, %tml)  }
        </div>
        BLOCK
    },
    'page-header' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="raku page-header">
            <div class="container px-4">
                <div class="raku page-title has-text-centered">
                { %prm<title> }
                </div>
                <div class="raku page-subtitle has-text-centered">
                { %prm<subtitle> }
                </div>
                { %tml<page-edit>.(%prm,%tml) }
            </div>
        </section>
        BLOCK
    },
    'page-content' => sub (%prm, %tml) {
        my $rv = '<section class="raku page-content">';
        $rv ~= %prm<config><page-content-columns>
            ?? '<div class="container"><div class="columns">'
            !! '<div class="container px-4">';
        $rv ~=  %prm<body>;
        $rv ~= %prm<config><page-content-columns>
            ?? '</div></div>'
            !! '</div>';
        $rv ~= "</section>\n"
    },
    'page-footnotes' => sub (%prm, %tml) {
        return '' unless %prm<footnotes>;
        qq:to/BLOCK/
        <section class="page-footnotes">
            <div class="container">
            { %prm<footnotes>  }
            </div>
        </section>
        BLOCK
    },
    'page-generated' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="page-generated">
            <div class="container has-text-centered">
              <p> Generated from { %prm<config><path> }
                at { DateTime(now).truncated-to('second') }</p>
            </div>
        </section>
        BLOCK
    },
    'pod' => sub (%prm, %tml) {
        (%prm<contents> // '')
        ~ "\n" ~ (%prm<tail> // '') ~ "\n"
    },
    'footer' => sub (%prm, %tml) {
        q:to/BLOCK/
        <footer class="footer main-footer">
          <div class="container px-4">
            <nav class="level">
                <div class="level-left">
                  <div class="level-item">
                      <a href="/about">About</a>
                   </div>
                    <div class="level-item">
                      <a id="toggle-theme">Toggle theme</a>
                    </div>
                </div>
                <div class="level-right">
                  <div class="level-item">
                    <p>
                      This website is licensed under
                      <a href="https://raw.githubusercontent.com/Raku/doc/master/LICENSE">the Artistic License 2.0</a>
                    </p>
                  </div>
                </div>
            </nav>
          </div>
        </footer>
        BLOCK
    },
    'page-edit' => sub (%prm, %tml) {
        return '' unless %prm<config><path> ~~ / ^ .+ ('docs/' .+) $ /;
        qq:to/BLOCK/
        <div class="page-edit">
            <a class="button page-edit-button"
               href="https://github.com/Raku/doc/edit/master/{ %tml<escaped>.(~$0) }"
               title="Edit this page.">
              <span class="icon is-right">
                <i class="fas fa-pen-alt is-medium"></i>
              </span>
            </a>
          </div>
        BLOCK
    },
    'end-block' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <script
            defer=""
            src="https://use.fontawesome.com/releases/v5.3.1/js/all.js">
        </script>
        <div
            role="status"
            aria-live="assertive"
            aria-relevant="additions"
            class="ui-helper-hidden-accessible">
        </div>
        BLOCK
    },
    #placeholder
    'block-code' => sub (%prm, %tml) { # previous block-code is set by 02-highlighter
        my $hl = %tml.prior('block-code').(%prm, %tml);
        $hl .= subst( / '<pre class="' /, '<pre class="cm-s-ayaya ');
        '<div class="raku-code raku-lang">'
            ~ $hl
            ~ '</div>'
    },
    'heading' => sub (%prm, %tml) {
        my $h = 'h' ~ (%prm<level> // '1');
        "\n<$h"
            ~ ' id="'
            ~ %tml<escaped>.(%prm<target>)
            ~ '" '
            ~ "class=\"raku-$h\">"
            ~ '<a href="#'
            ~ %tml<escaped>.(%prm<top>)
            ~ '" class="u" title="go to top of document">'
            ~ (%prm<text> // '')
            ~ "</a></$h>\n"
    },
    table => sub (%prm, %tml) {
        my $tb = %tml.prior('table').(%prm, %tml);
        $tb.subst(/ '<table class="' /, '<table class="table is-bordered centered ')
    },
    'toc' => sub (%prm, %tml) {
        if %prm<toc>.defined and %prm<toc>.keys {
            my $rv = "<ul class=\"menu-list\">\n";
            my Bool $sub-list = False;
            my $last-level;
            for %prm<toc>.list -> $el {
                with $last-level {
                    if $el.<level> eq $last-level {
                        $rv ~= '</li>'
                    }
                    else {
                        if $el.<level> eq 1 {
                            $rv ~= '</ul></li>';
                            $sub-list = False
                        }
                        elsif ! $sub-list {
                            $rv ~= '<ul>';
                            $sub-list = True;
                        }
                    }
                }
                $rv ~= '<li>'
                    ~ '<a href="#'
                    ~ %tml<escaped>.($el.<target>)
                    ~ '">'
                    ~ %tml<escaped>.($el.<text> // '')
                    ~ '</a>';
                $last-level = $el.<level>;
            }
            if $last-level eq 1 {
                $rv ~= "</li></ul>\n"
            }
            else {
                $rv ~= "</li></ul></li></ul>\n"
            }
        }
        else { '' }
    },
);