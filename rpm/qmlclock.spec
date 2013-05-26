# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.26
# 

Name:       qmlclock

# >> macros
# << macros

Summary:    QML clocks application
Version:    0.0.0
Release:    1
Group:      Applications/System
License:    BSD
URL:        http://github.com/nemomobile/qmlclock
Source0:    %{name}-%{version}.tar.bz2
Source100:  qmlclock.yaml
Requires:   nemo-qml-plugin-time
Requires:   qt-components
Requires:   mapplauncherd-booster-qtcomponents
BuildRequires:  pkgconfig(QtDeclarative)
BuildRequires:  pkgconfig(QtGui)
BuildRequires:  pkgconfig(qdeclarative-boostable)
BuildRequires:  desktop-file-utils

%description
Clocks application written using QML


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake 

make %{?jobs:-j%jobs}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/qmlclock
%{_datadir}/applications/qmlclock.desktop
# >> files
# << files
