# Replace the code block in the file path in the read.me with the code below, this will start pulling in the correct information to your Nagios instance.

sub init {
  my $self = shift;
  my %params = @_;
  $self->debug("enter init");
  $self->init_nagios();
  if ($params{mode} =~ /server::instance::replication::slavelag/) {
    # "show slave status", "Seconds_Behind_Master"
    my $slavehash = $self->{handle}->selectrow_hashref(q{
            SHOW REPLICA STATUS
        });
    if ((! defined $slavehash->{Seconds_Behind_Source}) && 
        (lc $slavehash->{Slave_IO_Running} eq 'no')) {
      $self->add_nagios_critical(
          "unable to get slave lag, because io thread is not running");
    } elsif (! defined $slavehash->{Seconds_Behind_Source}) {
      $self->add_nagios_critical(sprintf "unable to get seconds behind source info%s",
          $self->{handle}->{errstr} ? $self->{handle}->{errstr} : "");
    } else {
      $self->{seconds_behind_master} = $slavehash->{Seconds_Behind_Source};
    }
  } elsif ($params{mode} =~ /server::instance::replication::slaveiorunning/) {
    # "show slave status", "Slave_IO_Running"
    my $slavehash = $self->{handle}->selectrow_hashref(q{
            SHOW REPLICA STATUS
        });
    if (! defined $slavehash->{Replica_IO_Running}) {
      $self->add_nagios_critical(sprintf "unable to get replica IO running%s",
          $self->{handle}->{errstr} ? $self->{handle}->{errstr} : "");
    } else {
      $self->{slave_io_running} = $slavehash->{Replica_IO_Running};
    }
  } elsif ($params{mode} =~ /server::instance::replication::slavesqlrunning/) {
    # "show slave status", "Slave_SQL_Running"
    my $slavehash = $self->{handle}->selectrow_hashref(q{
            SHOW REPLICA STATUS
        });
    if (! defined $slavehash->{Replica_SQL_Running}) {
      $self->add_nagios_critical(sprintf "unable to get replica sql state running%s",
          $self->{handle}->{errstr} ? $self->{handle}->{errstr} : "");
    } else {
      $self->{slave_sql_running} = $slavehash->{Replica_SQL_Running};
    }
  }
}