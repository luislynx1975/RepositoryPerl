use Net::Ping;
     
$p = Net::Ping->new();
$host = '192.168.21.24';
$p->hires();
($ret, $duration, $ip) = $p->ping($host, 5.5);
printf( "$host [ip: $ip] is alive (packet return time: %.2f ms)\n" , 1000 * $duration)if $ret;
$p->close();
