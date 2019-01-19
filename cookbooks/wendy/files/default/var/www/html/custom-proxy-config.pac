function FindProxyForURL(url, host)
{
  if (isInNet(host, "10.22.0.0", "255.255.0.0") || 
      isInNet(host, "10.8.0.0", "255.255.0.0") ||
      shExpMatch(host, "*.private.scl3.mozilla.com")) {
    return "SOCKS localhost:8124; DIRECT";
  } else {
    return "DIRECT";
  }
}
