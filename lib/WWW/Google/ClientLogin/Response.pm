package WWW::Google::ClientLogin::Response;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    $args{params} ||= {};
    bless { %args }, $class;
}

sub is_success {
    $_[0]->{is_success} ? 1 : 0;
}

sub has_error {
    !$_[0]->is_success;
}

sub code {
    $_[0]->{code};
}

sub message {
    $_[0]->{message};
}

sub status_line {
    my $self = shift;
    sprintf '%d %s', $self->code, $self->message;
}

sub http_response {
    $_[0]->{http_response};
}

sub params {
    $_[0]->{params};
}

sub auth_token {
    $_[0]->params->{auth_token};
}

sub sid {
    $_[0]->params->{sid};
}

sub lsid {
    $_[0]->params->{lsid};
}

sub is_captcha_required {
    $_[0]->{is_captcha_required} ? 1 : 0;
}

sub captcha_token {
    $_[0]->params->{captcha_token};
}

sub captcha_url {
    $_[0]->params->{captcha_url};
}

1;
