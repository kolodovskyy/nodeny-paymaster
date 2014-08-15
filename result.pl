#!/usr/bin/perl

use DBI;
use Time::localtime;
use Time::Local;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);
use CGI;

my $SECRET = 'SECRET';
my $TEST = 0;

my %SYSTEMS = (
  '1'  => { 'category' => '71', 'description' => 'PayMaster - WebMoney' },
  '6'  => { 'category' => '72', 'description' => 'PayMaster - MoneXy' },
  '12' => { 'category' => '73', 'description' => 'PayMaster - EasyPay' },
  '15' => { 'category' => '74', 'description' => 'PayMaster - НСМЭП' },
  '17' => { 'category' => '75', 'description' => 'PayMaster - Терминалы Украины' },
  '19' => { 'category' => '76', 'description' => 'PayMaster - LiqPay' },
  '20' => { 'category' => '77', 'description' => 'PayMaster - Приват24' },
  '21' => { 'category' => '78', 'description' => 'PayMaster - VISA / MasterCard / Maestro' }
);

$SYSTEMS{18} = { 'category' => '71', 'description' => 'PayMaster - TEST' } if $TEST;

my $LOG_FILE = '/usr/local/nodeny/module/paymaster.log';

$c=new CGI;

sub debug
{
  my ($time);
  open LOG, ">>$LOG_FILE";
  $time = CORE::localtime;
  print LOG "$time: $_[0]\n";
  $c->save(\*LOG);
  close LOG;
}

sub return_ok
{
  debug "OK";
  print "Content-type: text/html; charset=utf-8;\n\nYES\n";
  exit;
}

sub return_fail
{
  debug $_[0];
  print "Content-type: text/html; charset=utf-8;\n\nFAIL:$_[0]\n";
  exit;
}

require '/usr/local/nodeny/nodeny.cfg.pl';
$dbh=DBI->connect("DBI:mysql:database=$db_name;host=$db_server;mysql_connect_timeout=$mysql_connect_timeout;",$user,$pw,{PrintError=>1});
die "Connection to database failed" unless $dbh;
require '/usr/local/nodeny/web/calls.pl';

return_fail "LMI_PAYMENT_AMOUNT" unless $c->param('LMI_PAYMENT_AMOUNT') =~ /^\d+(\.\d{1,2}){0,1}$/;
return_fail "LMI_PAYMENT_NO" unless $c->param('LMI_PAYMENT_NO') =~ /^\d+$/;
return_fail "LMI_PAYMENT_NO" unless &sql_select_line($dbh, "SELECT * FROM users WHERE id='" . $c->param('LMI_PAYMENT_NO') . "' AND mid='0'");
return_fail "LMI_PAYMENT_SYSTEM" unless $SYSTEMS{$c->param('LMI_PAYMENT_SYSTEM')};

return_ok if $c->param('LMI_PREREQUEST') eq '1';

my @HASH = (
  $c->param('LMI_MERCHANT_ID'),
  $c->param('LMI_PAYMENT_NO'),
  $c->param('LMI_SYS_PAYMENT_ID'),
  $c->param('LMI_SYS_PAYMENT_DATE'),
  $c->param('LMI_PAYMENT_AMOUNT'),
  $c->param('LMI_PAID_AMOUNT'),
  $c->param('LMI_PAYMENT_SYSTEM'),
  $c->param('LMI_MODE'),
  $SECRET
);
return_fail "LMI_HASH" unless uc(md5_hex(join('', @HASH))) eq uc($c->param('LMI_HASH'));

$CATEGORY = $SYSTEMS{$c->param('LMI_PAYMENT_SYSTEM')}->{category};
$DESCRIPTION = $SYSTEMS{$c->param('LMI_PAYMENT_SYSTEM')}->{description};

return_ok if (&sql_select_line($dbh, "SELECT mid FROM pays WHERE reason='" . $c->param('LMI_SYS_PAYMENT_ID') . "' AND type=10 AND category='" . $CATEGORY . "' LIMIT 1"));

&sql_do($dbh, "INSERT INTO pays SET
                mid='" . $c->param('LMI_PAYMENT_NO') . "',
                cash='" . $c->param('LMI_PAYMENT_AMOUNT') . "',
                time=UNIX_TIMESTAMP(NOW()),
                admin_id=0,
                admin_ip=0,
                office=0,
                bonus='y',
                reason='" . $c->param('LMI_SYS_PAYMENT_ID') . "',
                coment='" . $DESCRIPTION . "',
                type=10,
                category='" . $CATEGORY . "'");

&sql_do($dbh, "UPDATE users SET state='on', balance=balance+" . $c->param('LMI_PAYMENT_AMOUNT') . " WHERE id='" . $c->param('LMI_PAYMENT_NO') . "'");

return_ok;
