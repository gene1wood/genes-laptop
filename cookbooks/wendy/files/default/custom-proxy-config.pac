function FindProxyForURL(url, host)
{
    // Proxy direct connections to these hosts
    if (isInNet(host, "10.22.0.0", "255.255.0.0") || 
        isInNet(host, "10.8.0.0", "255.255.0.0")) {
        return "SOCKS localhost:8124; DIRECT";
    }
    // Otherwise go directly
    else return "DIRECT";
}