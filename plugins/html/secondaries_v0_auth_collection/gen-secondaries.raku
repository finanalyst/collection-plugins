#!/usr/bin/env raku
use v6.d;
use ProcessedPod;
use Collection::Progress;

sub ( $pp, %processed, %options ) {# these chars cannot appear in a unix filesystem path
    my regex defnmark {
        '<!-- defnmark' \s+
        $<target> = (.+?) \s+
        '-->'
        $<body> = ( .+? )
        <?before '<h' | '</section' | '</body' >
    }
    sub good-name($name is copy --> Str) is export {
        # / => $SOLIDUS
        # % => $PERCENT_SIGN
        # ^ => $CIRCUMFLEX_ACCENT
        # # => $NUMBER_SIGN
        my @badchars  = ["/", "^", "%"];
        my @goodchars = @badchars
                        .map({ '$' ~ .uniname      })
                        .map({ .subst(' ', '_', :g)});
        $name = $name.subst(@badchars[0], @goodchars[0], :g);
        $name = $name.subst(@badchars[1], @goodchars[1], :g);

        # if it contains escaped sequences (like %20) we do not
        # escape %
        if ( ! ($name ~~ /\%<xdigit>**2/) ) {
            $name = $name.subst(@badchars[2], @goodchars[2], :g);
        }
        return $name;
    }
    my %data = $pp.get-data('heading');
    #| each of the things we want to group in a file
    my %things = %( routine => {}, syntax => {} );
    my %templates := $pp.tmpl; # templates hash in ProcessedPod instance
    my @transfers; #this is for the triples describing the files
    my %definitions = %data<defs>;
    counter(:items( %definitions.keys ), :header('Generating secondaries'));
    for %definitions.kv -> $fn, %targets {
        counter(:dec);
        my $html = %processed{$fn}.pod-output;
        my $parsed = $html ~~ / [ <defnmark> .*? ]+ $ /;
        for $parsed<defnmark> {
            note 'Error in secondaries, expected target ｢' ~ .<target> ~ '｣ not found in definitions'
                unless %targets{ .<target> }:exists;
            my %attr = %targets{ .<target> }.clone;
            my $kind = %attr<kind>:delete;
            %attr<target> = .<target>.Str;
            %attr<body> = .<body>.trim;
            %attr<source> = $fn;
            %things{$kind}{ %attr<name> } = [] unless (%things{$kind}{ %attr<name> }:exists);
            %things{$kind}{ %attr<name> }.push: %attr;
        }
    }
    for %things.kv -> $kind, %defns {
        for %defns.kv -> $dn, @dn-data {
            # my $url = "/{$kind.Str.lc}/{good-name($name)}";
            my $fn-name = "{$kind.Str.lc}/{good-name($dn)}";
            my $title = $dn;
            my $subtitle = 'Synthesised documentation from ';
            my @subkind;
            my @category;
            my $podf = PodFile.new(
                name => $fn-name,
                :pod-config-data( %( :$kind, )),
                :$title,
                :path('synthetic documentation'),
            );
            my $body;
            for @dn-data {
                # Construct body
                @subkind.append: .<subkind>;
                @category.append: .<category>;
                $subtitle ~= ' ' ~ .<source>;
                $body ~= %templates<heading>.( %(
                    :1level,
                    :skip-parse,
                    :target($kind ~ .<subkind> ),
                    :text('From ' ~ .<source>),
                    :top( $podf.top )
                ), %templates );
                $body ~= %templates<para>.(%(
                    :contents(qq:to/CONT/)
                        See <a href="{
                           '/' ~ .<source> ~ '.html' ~ '#' ~ .<target>
                        }">Original text</a> in context
                        CONT
                ), %templates);
                $body ~= .<body>
            }
            # Construct TOC
            # No TOC for the time being

            # Add data to Processed file
            $podf.pod-config-data( :$kind, :@subkind, :@category );
            %processed{ $fn-name } = $podf;
            # Output html file / construct transfer triple
            "html/$fn-name\.html".IO.spurt: %templates<source-wrap>.( %(
                :$title,
                :$subtitle,
                :$body,
                :config( %( :name($dn), :path($fn-name), :lang($podf.lang) )),
                :toc(''),
                :glossary(''),
                :meta(''),
                :footnotes(''),
            ), %templates);
            @transfers.push: [ "$fn-name\.html", 'myself', "html/$fn-name\.html" ]
        }
    }
    @transfers
}
