#
# Cookbook Name:: wendy
# Recipe:: teamviewer
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# http://askubuntu.com/a/363083/14601
if node["platform_version"] == "16.04"
  package [
      'libgcc1:i386',
      'libasound2:i386',
      'libfontconfig1:i386',
      'libfreetype6:i386',
      'libjpeg62:i386',
      'libpng12-0:i386',
      'libsm6:i386',
      'libxdamage1:i386',
      'libxext6:i386',
      'libxfixes3:i386',
      'libxrandr2:i386',
      'libxrender1:i386',
      'libxtst6:i386',
      'zlib1g:i386']
end

if node["platform_version"] == "18.04"
  package [
      'glib-networking:i386',
      'libatk-bridge2.0-0:i386',
      'libatk1.0-0:i386',
      'libatspi2.0-0:i386',
      'libbrotli1:i386',
      'libcairo-gobject2:i386',
      'libcolord2:i386',
      'libdatrie1:i386',
      'libdouble-conversion1:i386',
      'libegl-mesa0:i386',
      'libegl1:i386',
      'libepoxy0:i386',
      'libevdev2:i386',
      'libgbm1:i386',
      'libgdk-pixbuf2.0-0:i386',
      'libgraphite2-3:i386',
      'libgtk-3-0:i386',
      'libgudev-1.0-0:i386',
      'libharfbuzz0b:i386',
      'libhyphen0:i386',
      'libinput10:i386',
      'libjson-glib-1.0-0:i386',
      'libmtdev1:i386',
      'libpango-1.0-0:i386',
      'libpangocairo-1.0-0:i386',
      'libpangoft2-1.0-0:i386',
      'libproxy1v5:i386',
      'libqt5core5a:i386',
      'libqt5dbus5:i386',
      'libqt5gui5:i386',
      'libqt5network5:i386',
      'libqt5positioning5:i386',
      'libqt5printsupport5:i386',
      'libqt5qml5:i386',
      'libqt5quick5:i386',
      'libqt5sensors5:i386',
      'libqt5svg5:i386',
      'libqt5webchannel5:i386',
      'libqt5webkit5:i386',
      'libqt5widgets5:i386',
      'libqt5x11extras5:i386',
      'librest-0.7-0:i386',
      'libsm6:i386',
      'libsoup-gnome2.4-1:i386',
      'libsoup2.4-1:i386',
      'libthai0:i386',
      'libwacom2:i386',
      'libwayland-cursor0:i386',
      'libwayland-egl1:i386',
      'libwayland-egl1-mesa:i386',
      'libwoff1:i386',
      'libxcb-icccm4:i386',
      'libxcb-image0:i386',
      'libxcb-keysyms1:i386',
      'libxcb-render-util0:i386',
      'libxcb-shape0:i386',
      'libxcb-util1:i386',
      'libxcb-xfixes0:i386',
      'libxcb-xinerama0:i386',
      'libxcb-xkb1:i386',
      'libxkbcommon-x11-0:i386',
      'libxkbcommon0:i386',
      'qml-module-qtgraphicaleffects:i386',
      'qml-module-qtquick-controls:i386',
      'qml-module-qtquick-dialogs:i386',
      'qml-module-qtquick-layouts:i386',
      'qml-module-qtquick-privatewidgets:i386',
      'qml-module-qtquick-window2:i386',
      'qml-module-qtquick2:i386',
      'qt5-gtk-platformtheme:i386',
      'qtdeclarative5-qtquick2-plugin:i386'
  ]
end

# I'm having trouble getting this working. The 18.04 dependency list I derived from trying to install teamviewer_i386
# I was able to install the 64 bit version but couldn't interact with the UI, I could click in the fields
# So I'm hoping maybe the i386 version will work
# When trying to apt install the teamviewer_i386 and auto resolve dependencies, I got an error
# N: Download is performed unsandboxed as root as file '/root/.chef/local-mode-cache/cache/teamviewer_i386.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)
# so not sure what to do or whats going on

remote_dpkg 'teamviewer' do
  source "https://download.teamviewer.com/download/linux/teamviewer_i386.deb"
  # checksum '7a729557ef7618c41c8a94a6d668fa84422ecf9acf2b1889ea52c727849f7f07'
end

# remote_dpkg 'teamviewer' do
#   source "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
#   # checksum '7a729557ef7618c41c8a94a6d668fa84422ecf9acf2b1889ea52c727849f7f07'
# end

service 'teamviewerd' do
  action [:stop, :disable]
end