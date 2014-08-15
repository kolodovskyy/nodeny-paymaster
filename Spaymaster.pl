#!/usr/bin/perl

use Text::Iconv;

sub PayMaster
{
  my $TEST = 0;
  my $LMI_MERCHANT_ID = 'MERCHANT_ID';
  my $STAT_URL = 'STAT_URL';

  my @SYSTEMS = (
    { 'system' => 'paymaster_card', 'system_id' => '21', 'name' => 'VISA / MasterCard / Maestro', 'description' => 'Оплата банковской картой VISA / MasterCard / Maestro' },
    { 'system' => 'webmoney', 'system_id' => '1', 'name' => 'WebMoney', 'description' => 'Оплата с кошелька WebMoney' },
    { 'system' => 'privat24', 'system_id' => '20', 'name' => 'Приват24', 'description' => 'Оплата через Интернет-Банкинг Приват24' },
    { 'system' => 'monexy', 'system_id' => '6', 'name' => 'MoneXy', 'description' => 'Оплата через MoneXy' },
    { 'system' => 'easypay', 'system_id' => '12', 'name' => 'EasyPay', 'description' => 'Оплата через EasyPay' },
    { 'system' => 'nsmep', 'system_id' => '15', 'name' => 'НСМЭП', 'description' => 'Оплата через НСМЭП' },
    { 'system' => 'webmoney_terminal', 'system_id' => '17', 'name' => 'Терминалы Украины', 'description' => 'Оплата системой WebMoney' },
    { 'system' => 'liqpay', 'system_id' => '19', 'name' => 'LiqPay', 'description' => 'Оплата через LiqPay' },
  );

  my $ACTION = 'https://lmi.paymaster.ua';
  my $LMI_SUCCESS_URL = "$STAT_URL$script?uu=$F{uu}&pp=$F{pp}&a=$F{a}&result=success";
  my $LMI_FAIL_URL = "$STAT_URL$script?uu=$F{uu}&pp=$F{pp}&a=$F{a}&result=fail";

  &OkMess('Оплата произведена успешно') if ($F{result} eq 'success');
  &ErrorMess('Ошибка оплаты либо отказ') if ($F{result} eq 'fail');
  
  $OUT .= '<link rel="stylesheet" href="/paymaster/paymaster.css" type="text/css">';
  $OUT .= '<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>';
  $OUT .= '<script type="text/javascript" src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>';
  $OUT .= '<script type="text/javascript" src="/paymaster/paymaster.js"></script>';

  $iconv = Text::Iconv->new("windows-1251", "utf-8");

  foreach (@SYSTEMS) {
    $OUT .= "
      <div class=\"ukrindex-message\">
        <table class=\"ukrindex-container\">
          <tr>
            <td>
              <table class=\"ukrindex\">
                <tr>
                  <td class=\"ukrindex-text-center\" width=\"64px\"><img src=\"/paymaster/$_->{system}.png\" width=\"64\" height=\"64\"></td>
                  <td>
                    <h2>$_->{name}</h2>
                    $_->{description}
                  </td>
                  <td style=\"text-align:right\">
                    <form name=\"lmi_form\" method=\"post\" action=\"$ACTION\" id=\"lmi_form\">
                      <input type=\"hidden\" name=\"LMI_MERCHANT_ID\" value=\"$LMI_MERCHANT_ID\">
                      <input type=\"hidden\" name=\"LMI_PAYMENT_NO\" value=\"$Mid\">
                      <input type=\"hidden\" name=\"LMI_PAYMENT_DESC\" value=\"" . $iconv->convert("Оплата за услуги ($pm->{fio})") ."\">
                      <input type=\"hidden\" name=\"LMI_SUCCESS_URL\" value=\"$LMI_SUCCESS_URL\">
                      <input type=\"hidden\" name=\"LMI_SUCCESS_METHOD\" value=\"0\">
                      <input type=\"hidden\" name=\"LMI_FAIL_URL\" value=\"$LMI_FAIL_URL\">
                      <input type=\"hidden\" name=\"LMI_FAIL_METHOD\" value=\"0\">
                      <input type=\"hidden\" name=\"LMI_SIM_MODE\" value=\"0\">
                      <input type=\"hidden\" name=\"LMI_PAYMENT_SYSTEM\" value=\"" . ($TEST ? '18' : $_->{system_id}) . "\">
                      <input type=\"text\" name=\"LMI_PAYMENT_AMOUNT\" value=\"\" placeholder=\"Сумма к оплате\" class=\"ukrindex_paymaster_amount\">
                      <input type=\"submit\" value=\"Перейти к оплате\" class=\"ukrindex_paymaster_submit\" disabled=\"disabled\">
                    </form>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    ";
  }
}

1;
