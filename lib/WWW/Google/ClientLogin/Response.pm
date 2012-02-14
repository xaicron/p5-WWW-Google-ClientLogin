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
*is_error = *has_error;

sub code {
    $_[0]->http_response->code;
}

sub message {
    $_[0]->http_response->message;
}

sub status_line {
    my $self = shift;
    sprintf '%d %s', $self->code, $self->message;
}

sub http_response {
    $_[0]->{http_response};
}

sub error_code {
    $_[0]->{error_code} || '';
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
__END__

=encoding utf-8

=for stopwords

=head1 NAME

WWW::Google::ClientLogin::Response - Response Object

=head1 SYNOPSIS

  my $res = WWW::Google::ClientLogin::Response->new(
      is_success    => 1,
      code          => 200,
      message       => 'OK',
      http_response => $http_response_object,
      params        => { ... },
  );

=head1 DESCRIPTION

WWW::Google::ClientLogin::Response is a WWW::Google::ClientLogin internal class.

=head1 METHODS

=over

=item new(%args)

=item is_success()

  $res->is_success ? 1 : 0;

=item is_error()

  $res->is_error 1 : 0;

=item has_error()

  $res->has_error ? 1 : 0;

=item code()

HTTP Response code.

  say $res->code;

=item message()

HTTP message or ClientLogin error message

  say $res->message;

=item status_line()

C<< code >> and C<< message >>

  say $res->status_line; # eq say $res->code, ' ', $res->message;

=item http_response()

Original HTTP Response object.

  my $http_response = $res->http_response;
  say $http_response->as_string;

=item error_code()

Response error code. SEE ALSO L<< http://code.google.com/intl/ja/apis/accounts/docs/AuthForInstalledApps.html#Errors >>

  if ($res->error_code eq 'BadAuthentication') {
      ...
  }

=item auth_token()

  say $res->auth_token;

=item sid()

  say $res->sid;

=item lsid()

  say $res->lsid;

=item is_captcha_required()

  $res->is_captcha_required ? 1 : 0;

=item captcha_token()

  my $captcha_token = $res->captcha_token;

=item captcha_url()

  my $captcha_url = $res->captcha_url;

=item params()

Response parameters in HASHREF

  say $res->params->{auth_token};

=back

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
