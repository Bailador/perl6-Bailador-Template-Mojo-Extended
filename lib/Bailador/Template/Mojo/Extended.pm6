use Bailador::Template;

unit class Bailador::Template::Mojo::Extended:ver<1.001001>
    does Bailador::Template;

use Template::Mojo;
use Bailador;

my $param-str = '% my ( %s ) = @_; my $s = %s;' ~ "\n";

method render ($template is copy, *@params, *%params) {
    my %vars;
    %vars{ $0 } = ~$1 while $template ~~ s/^ '%%' \s* (\w+)\s* ':' \s* (\N+) \n//;
    %vars = |%vars, pos => @params, |%params;

    my $layout-file = $*SPEC.catdir(
        'views', 'layouts', (%vars<layout> || 'default') ~ '.tt'
    ).IO;
    die "Unable to find or read layout `$layout-file`"
        unless .r and .f given $layout-file;

    %vars<content> = Template::Mojo.new($param-str ~ $template)
        .render: %vars;

    return Template::Mojo.new($param-str ~ $layout-file.slurp)
        .render: %vars;
}
