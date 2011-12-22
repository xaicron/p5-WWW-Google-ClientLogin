package WWW::Google::ClientLogin;

use strict;
use warnings;
use Carp ();
use LWP::UserAgent;
use LWP::protocol::https; # preload

use WWW::Google::ClientLogin::Response;

use 5.008_001;
our $VERSION = '0.01';

our $URL = 'https://www.google.com/accounts/ClientLogin';

sub new {
    my ($class, %params) = @_;
    unless ($params{email} && $params{password} && $params{service}) {
        Carp::croak("Usage: $class->new(email => \$email, password => \$password, service => \$service)");
    }

    $params{type}   ||= 'HOSTED_OR_GOOGLE';
    $params{source} ||= __PACKAGE__ .'_'.$VERSION;
    $params{ua}     ||= LWP::UserAgent->new(agent => __PACKAGE__.' / '.$VERSION);

    bless { %params }, $class;
}

sub authenticate {
    my $self = shift;
    my $res = $self->{ua}->post($URL, Content => [
        accountType => $self->{type},
        Email       => $self->{email},
        Passwd      => $self->{password},
        service     => $self->{service},
        source      => $self->{source},
        $self->{logintoken}   ? (logintoken   => $self->{logintoken})   : (),
        $self->{logincaptcha} ? (logincaptcha => $self->{logincaptcha}) : (),
    ]);

    my $result;
    if ($res->is_success) {
        my $content = $res->content;
        my $params = { map { split '=', $_, 2 } split /\n/, $content };
        $result = WWW::Google::ClientLogin::Response->new(
            is_success    => 1,
            code          => $res->code,
            message       => $res->message,
            http_response => $res,
            params        => {
                auth_token => $params->{Auth},
                sid        => $params->{SID},
                lsid       => $params->{LSID},
            },
        );
    }
    elsif ($res->code == 403) {
        my $content = $res->content;
        my $params = { map { split '=', $_, 2 } split /\n/, $content };
        $result = WWW::Google::ClientLogin::Response->new(
            is_success    => 0,
            http_response => $res,
            code          => $res->code,
            message       => $params->{Error},
        );
        if ($params->{Error} eq 'CaptchaRequired') {
            $result->{is_captcha_required} = 1;
            $result->{params} = {
                captcha_token => $params->{CaptchaToken},
                captcha_url   => $params->{CaptchaUrl},
            };
        }
    }
    else {
        $result = WWW::Google::ClientLogin::Response->new(
            is_success    => 0,
            http_response => $res,
            code          => $res->code,
            message       => $res->message,
        );
   }

   return $result;
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

WWW::Google::ClientLogin -

=head1 SYNOPSIS

  use WWW::Google::ClientLogin;

=head1 DESCRIPTION

WWW::Google::ClientLogin is

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
