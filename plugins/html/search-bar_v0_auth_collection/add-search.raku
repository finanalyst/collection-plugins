#!/usr/bin/env raku
use v6.d;
use JSON::Fast;
use ProcessedPod;

sub ($pp, %processed, %options) {
    # This routine creates the JS data structure to be added to the JS query function
    # The data structure is an array of hashes :category, :value, :url
    # Category is used to split up items, value is what is searched for, url is where it is to be found.
    # eg { "category": "Types", "value": "Distribution::Hash", "url": "/type/Distribution::Hash" }
    # The first three items are supplied for some reason.
    #| total length of search bar in char
    my $search-len = 110;
    #| the number of extra chars in the candidate rendering
    #| spaces in the break between the value and the info section
    #| [  ]
    my $bar-chars = 8;
    my @entries;
    my $categories = <Heading Indexed>.SetHash;
    # collect info stored from parsing headers
    # structure of processed
    # <filename> => %( :config-data => :kind, @sub-kind, @category )
    # Helper functions as in Documentable
    sub escape(Str $s) is export {
        $s.trans([</ \\ ">] => [<\\/ \\\\ \\">]);
    }
    sub escape-json(Str $s) is export {
        $s.subst(｢\｣, ｢%5C｣, :g)
                .subst('"', '\"', :g)
                .subst(｢?｣, ｢%3F｣, :g)
                .subst(｢.｣, '%2E', :g)
    }
    for %processed.kv -> $fn, $podf {
        my $value = $podf.title;
        my $info = '';
        # some files don't have a subtitle, so no extra information to show
        with $podf.subtitle {
            if m/ \S / {
                $info = .subst(/ '<p>' | '</p>' /,'',:g);
            }
        }
        if $fn ~~ / ^ [ 'syntax/' | 'routine/' ] / {
            @entries.push: %(
                :category($podf.pod-config-data<subkind>.tc),
                :$value,
                :$info,
                :url(escape-json('/' ~ $podf.path)),
                :type<composite>,
            );
        }
        else {
            @entries.push: %(
                :category( $podf.pod-config-data<subkind>.tc // 'Language' ), # a default subkind in case one is missing.
                :$value,
                :$info,
                :url(escape-json('/' ~ $fn)),
                :type<primary>,
            )
        }
        for $podf.raw-toc.grep({ !(.<is-title>) }) {
            @entries.push: %(
                :category<Heading>,
                :value(.<text>),
                :info('Section in <b>' ~ $podf.title ~ '</b>'),
                :url(escape-json('/' ~ $fn ~ '#' ~ .<target>)),
                :type<headings>,
            )
        }
        $categories{ $podf.pod-config-data<kind>.tc }++
    }
    # try to filter out duplicates by looking for only unique urls
    @entries .= unique(:as(*.<url>));
    # now sort so js only does filtering.
    sub head-or-fivesix($a, $b) {
        # heading and 5to6 are independent
        return Order::Same unless $a ~~ Str:D and $b ~~ Str:D;
        my $a-h = $a.contains('heading', :i);
        my $b-h = $b.contains('heading', :i);
        my $a5 = $a.contains('5to6');
        my $b5 = $b.contains('5to6');
        return Order::Same if ($a-h and $b-h) or ($a5 and $b5);
        return Order::More if $a-h or $a5;
        return Order::Less if $b-h or $b5;
        return $a cmp $b
    }
    @entries .= sort({ &head-or-fivesix($^a.<category>, $^b.<category>) })
        .sort({ &head-or-fivesix($^a.<url>, $^b.<url>) })
        .sort({ $^a.<value> cmp $^b.<value> });
    $pp.add-data('extendedsearch', $categories.keys);
    'search-bar.js'.IO.spurt: qq[
            var items =
            { JSON::Fast::to-json(@entries) }
            ;
            { 'search-temp.js'.IO.slurp }
    ];

    [
        [ 'assets/scripts/search-bar.js', 'myself', 'search-bar.js' ],
    ]
}