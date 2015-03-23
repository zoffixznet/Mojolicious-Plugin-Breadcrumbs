package Mojolicious::Plugin::Breadcrumbs;

use Mojo::Base 'Mojolicious::Plugin';

# VERSION

use utf8;

my $Crumbs_Map = {
    '/' => 'Home',
};

sub register {
    my ($self, $app) = @_;

    $app->helper(
        breadcrumbs => sub {
            my $c = shift;
            @_ and $Crumbs_Map = shift;

            length $c->url_for->to_string
                or return; # if this is the case, we're just setting the
                           # $Crumbs_Map and not needing crumbs;

            my $path = '';
            my @crumbs;
            for my $crumb (
                '', grep length, split m{/}, $c->url_for->to_string
            ) {
                $path .= ($path eq '/' ? '' : '/') . $crumb;
                push @crumbs, {
                    path => $path,
                    text => $Crumbs_Map->{ $path }
                                // ucfirst($crumb =~ tr/-_/ /r),
                };
            }

            my $current_page = pop @crumbs;
            my $bread = '<section class="breadcrumbs">' .
                join(q{<span class="breadcrumb_sep">▸</span>},
                    (map qq{<a href="$_->{path}">$_->{text}</a>}, @crumbs),
                    '',
                );

            $bread .= '<span class="last_breadcrumb">'
                . ($current_page->{text}) . '</span></section>';

            return $bread;
        },
    );
}

'
Q. Why was the statement scared while the comment was not?
A. Statements are executed.
';

__END__

=encoding utf8

=for stopwords  breadcrumbs  autogenerating

=head1 NAME

Mojolicious::Plugin::Breadcrumbs - Mojolicious plugin for autogenerating breadcrumbs links

=head1 SYNOPSIS

=for pod_spiffy start code section

    #!perl

    use Mojolicious::Lite;

    plugin 'Breadcrumbs';

    get '/user/account-settings' => 'account-settings';

    app->start;

    __DATA__

    @@ account-settings.html.ep

    You are at <%== breadcrumbs %>

=for pod_spiffy end code section

The output in the browser then be this
I<(actual output will not have line breaks)>:

    You are at
    <section class="breadcrumbs">
        <a href="/">Home</a><span class="breadcrumb_sep">▸</span>
        <a href="/user">User</a><span class="breadcrumb_sep">▸</span>
            <span class="last_breadcrumb">Account settings</span>
    </section>

By default, C</> path will be named C<Home>, and all other paths
will be named by changing C<-> and C<_> characters to spaces and
capitalizing the first letter. You can provide your
own mapping for certain paths, by passing a mapping
hashref to C<breadcrumbs> helper. Anything not found in the map will
still be named as described above.

=for pod_spiffy start code section

    #!perl

    use Mojolicious::Lite;

    plugin 'Breadcrumbs';
    app->breadcrumbs({
        '/'     => 'Start page',
        '/user' => 'Your account',
        '/user/account-settings' => 'Settings',
    });
    get '/user/account-settings' => 'account-settings';

    app->start;

    __DATA__

    @@ account-settings.html.ep

    You are at <%== breadcrumbs %>

=for pod_spiffy end code section

The output in the browser then be this
I<(actual output will not have line breaks)>:

    You are at
    <section class="breadcrumbs">
        <a href="/">Start page</a><span class="breadcrumb_sep">▸</span>
        <a href="/user">Your account</a>
        <span class="breadcrumb_sep">▸</span>
            <span class="last_breadcrumb">Settings</span>
    </section>

=head1 DESCRIPTION

L<Mojolicious::Plugin::Breadcrumbs> is a L<Mojolicious> plugin for
auto-generating breadcrumbs.

=head1 METHODS

L<Mojolicious::Plugin::Breadcrumbs> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<< ->register() >>

=for pod_spiffy in object

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 HELPERS

=head2 C<breadcrumbs>

=for pod_spiffy in scalar optional

Using in HTML:

    You are at <%== breadcrumbs %>

Setting custom link names:

    app->breadcrumbs(
        '/'     => 'Start page',
        '/user' => 'Your account',
        '/user/account-settings' => 'Settings',
    );

See SYNOPSIS for full description of use and arguments.

=head1 REPOSITORY

=for pod_spiffy start github section

Fork this module on GitHub:
L<https://github.com/zoffixznet/Mojolicious-Plugin-Breadcrumbs>

=for pod_spiffy end github section

=head1 BUGS

=for pod_spiffy start bugs section

To report bugs or request features, please use
L<https://github.com/zoffixznet/Mojolicious-Plugin-Breadcrumbs/issues>

If you can't access GitHub, you can email your request
to C<bug-mojolicious-plugin-breadcrumbs at rt.cpan.org>

=for pod_spiffy end bugs section

=head1 AUTHOR

=for pod_spiffy start author section

=for pod_spiffy author ZOFFIX

=for text Zoffix Znet <zoffix at cpan.org>, (L<http://zoffix.com/>)

=for pod_spiffy end author section

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut