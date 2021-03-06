# This script was automatically generated from the dsa-555
# Debian Security Advisory
# It is released under the Nessus Script Licence.
# Advisory is copyright 1997-2009 Software in the Public Interest, Inc.
# See http://www.debian.org/license
# DSA2nasl Convertor is copyright 2004-2009 Tenable Network Security, Inc.

if (! defined_func('bn_random')) exit(0);

include('compat.inc');

if (description) {
 script_id(15653);
 script_version("$Revision: 1.8 $");
 script_xref(name: "DSA", value: "555");
 script_cve_id("CVE-2004-0563");

 script_set_attribute(attribute:'synopsis', value: 
'The remote host is missing the DSA-555 security update');
 script_set_attribute(attribute: 'description', value:
'Simon Josefsson noticed that the tspc.conf configuration file in
freenet6, a client to configure an IPv6 tunnel to freenet6.net, is set
world readable.  This file can contain the username and the password
used to contact the IPv6 tunnelbroker freenet6.net.
For the stable distribution (woody) this problem has been fixed in
version 0.9.6-1woody2.
');
 script_set_attribute(attribute: 'see_also', value: 
'http://www.debian.org/security/2004/dsa-555');
 script_set_attribute(attribute: 'solution', value: 
'The Debian project recommends that you upgrade your freenet6 package.');
script_set_attribute(attribute: 'cvss_vector', value: 'CVSS2#AV:L/AC:L/Au:N/C:P/I:N/A:N');
script_end_attributes();

 script_copyright(english: "This script is (C) 2009 Tenable Network Security, Inc.");
 script_name(english: "[DSA555] DSA-555-1 freenet6");
 script_category(ACT_GATHER_INFO);
 script_family(english: "Debian Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/Debian/dpkg-l");
 script_summary(english: "DSA-555-1 freenet6");
 exit(0);
}

include("debian_package.inc");

if ( ! get_kb_item("Host/Debian/dpkg-l") ) exit(1, "Could not obtain the list of packages");

deb_check(prefix: 'freenet6', release: '3.0', reference: '0.9.6-1woody2');
if (deb_report_get()) security_note(port: 0, extra:deb_report_get());
else exit(0, "Host is not affected");
