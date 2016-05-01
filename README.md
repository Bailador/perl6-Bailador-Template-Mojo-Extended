# NAME

Bailador::Template::Mojo::Extended

# SYNOPSIS

```perl6
use Bailador;
use Bailador::Template::Mojo::Extended;

renderer Bailador::Template::Mojo::Extended.new;

```

# DESCRIPTION

This module adds extra features to the default ::Mojo renderer.

# TURNING ON RENDERER

## `renderer ... .new`

```perl6
    renderer Bailador::Template::Mojo::Extended.new
```

Use Bailador's `renderer` sub to set up the new renderer
backend by calling `.new` on `Bailador::Template::Mojo::Extended` class.

# USAGE

See [Template::Mojo](modules.perl6.org/repo/Template::Mojo) for general
usage details. This module makes these modifications:

## Layout templates

You can use base templates into which to include your regular templates:

    # views/layouts/default.tt
    <h1>This is HTML layout</h1>
    <%= $s<content> %>

    # views/layouts/email.tt
    <h1>This is EMAIL layout</h1>
    <%= $s<content> %>

    # views/index.tt
    <p>Foo</p>

    # views/email.tt
    %% layout: email
    <p>Bar</p>

    ## index template results in
    # <h1>This is HTML layout</h1>
    # <p>Foo</p>

    # email template results in
    # <h1>This is EMAIL layout</h1>
    # <p>Bar</p>

See `examples/` directory for a working version of this sort of
set up. The layout templates are located in `views/layouts/`
directory. They are set by either providing `:layout` named
parameter to `template` Bailador sub or by using `%% layout:`
at the start of the template.

If unspecified, layout defaults to `views/default.tt`

## Stash Variables

Instead of exlicitly asking for passed parameters in your templates,
they are available in `$s` Hash (`%s` Hash is also available and is the same).
Template parameters are passed as named arguments to `template` Bailador
subroutine. Positional parameters are available as well under C<pos> key
in the `$s` Hash.

```perl6
    get '/foo' => sub { template 'index.tt', 'Znet', :name<Zoffix> }

    # In views/index.tt:
    <p>My name is <% $s<name> ~ ' ' ~ $s<pos>[0] %></p>

    # Results in:
    # <p>My name is Zoffix Znet</p>
```

This applies both to your layout templates and normal templates themselves.

## Template Stash Setting

At the start of your template, you can use lines starting with `%%` followed
by word-character key, followed by colon, followed by its value to set up
stash keys. These will be available in both the layout and the template
itself:

    # in views/template.tt
    %% layout: email
    %% title: Foo Bar Baz
    <p>Hello, World!</p>

    # in vies/layouts/email.tt
    <title><%= $s<title> %></title>
    <%= $s<content> %>

The stash variables provided in the template can be overriden by providing those
stash variables in the `template` call, thus your templates can specify default values.

    template 'template.tt', :title<SomeOtherTitle>;

----

# REPOSITORY

Fork this module on GitHub:
https://github.com/zoffixznet/perl6-Bailador-Template-Mojo-Extended

# BUGS

To report bugs or request features, please use
https://github.com/zoffixznet/perl6-Bailador-Template-Mojo-Extended/issues

# AUTHOR

Zoffix Znet (http://zoffix.com/)

# LICENSE

You can use and distribute this module under the terms of the
The Artistic License 2.0. See the `LICENSE` file included in this
distribution for complete details.
