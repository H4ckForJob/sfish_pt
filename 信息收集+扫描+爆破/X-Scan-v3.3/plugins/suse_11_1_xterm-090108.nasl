
#
# (C) Tenable Network Security, Inc.
#
# The text description of this plugin is (C) Novell, Inc.
#

include("compat.inc");

if ( ! defined_func("bn_random") ) exit(0);

if(description)
{
 script_id(40327);
 script_version("$Revision: 1.3 $");
 script_name(english: "SuSE 11.1 Security Update:  xterm (2009-01-08)");
 script_set_attribute(attribute: "synopsis", value: 
"The remote SuSE system is missing a security patch for xterm");
 script_set_attribute(attribute: "description", value: "XTerm evaluated various ANSI Escape sequences so that
command execution was possible if an attacker could pipe
raw data to an xterm. (CVE-2008-2383)

(It is usually not recommended to display raw data on an
xterm.)
");
 script_set_attribute(attribute: "cvss_vector", value: "CVSS2#AV:N/AC:M/Au:N/C:C/I:C/A:C");
script_set_attribute(attribute: "solution", value: "Run yast to install the security patch for xterm");
script_set_attribute(attribute: "see_also", value: "https://bugzilla.novell.com/show_bug.cgi?id=462917");
script_end_attributes();

 script_cve_id("CVE-2008-2383");
script_summary(english: "Check for the xterm package");
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security, Inc.");
 script_family(english: "SuSE Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/SuSE/rpm-list");
 exit(0);
}

include("rpm.inc");

if ( ! get_kb_item("Host/SuSE/rpm-list") ) exit(1, "Could not gather the list of packages");
if ( rpm_check( reference:"xterm-236-1.50.1", release:"SUSE11.1", cpu:"i586") )
{
	security_hole(port:0, extra:rpm_report_get() );
	exit(0);
}
if ( rpm_check( reference:"xterm-236-1.50.1", release:"SUSE11.1", cpu:"x86_64") )
{
	security_hole(port:0, extra:rpm_report_get() );
	exit(0);
}
exit(0,"Host is not affected");
