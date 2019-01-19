#!/usr/bin/env python

"""
Pingmon v0.2
Packet drop indicator for Ubuntu
(c) 2013 Travis Mick <lq@le1.ca>

This script provides a Unity AppIndicator displaying the percentage of pings
to a certain host that are dropped. Some potential uses are to monitor the
health of a server, and to monitor the drop rate of a wireless connection.

https://gist.github.com/le1ca/5461776

Configuration:

PING_HOSTNAME is the name or address of the host you want to ping
PING_FREQUENCY is the rate (in ms) that pings will be sent
PING_THRESHOLD is the threshold below which we should change the indicator
PING_BUFFER is the number of ping results to store; the displayed drop rate
    is derived from the contents of the buffer
PING_MAKECSV is whether to print out a file "pingmon.csv" in the working
    directory containing a report of changes in the drop rate
"""

PING_HOSTNAME  = "8.8.8.8"
PING_FREQUENCY = 2500
PING_THRESHOLD = 10
PING_BUFFER    = 20
PING_MAKECSV   = False




import gtk, gobject, appindicator, subprocess, datetime

class pingmon:
        
    def __init__(self):
        
        self.pings = []
        self.lastRate = [-1, -1, True]
        menu = gtk.Menu()
        quit = gtk.MenuItem("Quit")
        about = gtk.MenuItem("Packet Drop Indicator")
        ind = appindicator.Indicator(
                "pingmon-indicator", 
                "emblem-OK",
                appindicator.CATEGORY_OTHER,
              )
        ind.set_menu(menu)
        ind.set_attention_icon("emblem-ohno")
        self.updateIcon(ind)
        quit.connect("activate", self.destroy)
        about.connect("activate", self.about)
        menu.append(about)
        menu.append(quit)
        menu.show_all()
        gobject.timeout_add(PING_FREQUENCY, self.ping, ind)
   
        
    def ping(self, ind):
        """
        Sends one ping to PING_HOSTNAME with a timeout of 1000ms, and updates
        the ping buffer to reflect its result. Always returns True, because a
        False return would stop the timer that uses this function as a
        callback.
        
        We simply call the iputils 'ping' command because Python does not allow
        normal users to create ICMP packets, and we don't need to run this
        script as root.
        """
        r = subprocess.call(
                "ping -c 1 -W 1 %s" % PING_HOSTNAME,
                shell  = True,
                stdout = open('/dev/null', 'w'),
                stderr = subprocess.STDOUT
            )
        self.pings.append(r == 0)
        if len(self.pings) > PING_BUFFER:
            self.pings.pop(0)
        self.updateIcon(ind)
        return True
        
    def getDropRate(self):
        """
        Calculates the packet drop rate from the contents of the ping buffer,
        and returns it as a percentage (value 0-100).
        """
        if len(self.pings) == 0:
            return 0
        dropped = 0
        for packet in self.pings:
            if packet == False:
                dropped += 1
        r = 100 * dropped / len(self.pings)
        d = str(datetime.datetime.today())
        p = False
        if PING_MAKECSV and r != self.lastRate[1]:
            f = open("pingmon.csv", "a")
            if not self.lastRate[2]:
                f.write("%s,%s\n" % ( self.lastRate[0], str(round(self.lastRate[1], 2))))
            f.write("%s,%s\n" % ( d, str(round(r, 2))))
            p = True
        self.lastRate = [d, r, p]
        return r
    
    def updateIcon(self, ind):
        dr = self.getDropRate()
        ind.set_label(str(round(dr)) + "%" )
        if dr < PING_THRESHOLD:
            ind.set_status(appindicator.STATUS_ACTIVE)
        else:
            ind.set_status(appindicator.STATUS_ATTENTION)     
    def main(self):
        gtk.main()
        
    def about(self, widget):
        about = gtk.AboutDialog()
        about.set_destroy_with_parent(True)
        about.set_name("Packet Drop Indicator")
        about.set_comments(
                "Intermittently sends out a ping and provides an "
                "indication of the drop rate.\n\nCurrently pinging " + PING_HOSTNAME + " every " +
                str(PING_FREQUENCY) + " ms.\nThreshold = " + str(PING_THRESHOLD) +" / Buffer = " + str(PING_BUFFER)
            )
        about.set_version("0.1")
        about.set_authors(["Travis Mick <tmick@nmsu.edu>"])
        about.run()
        about.destroy()
        
    def destroy(self, widget, data=None):
        gtk.main_quit()

    def delete_event(self, widget, event, data=None):
        return 0
        
if __name__ == "__main__":
    pingmon().main()
        