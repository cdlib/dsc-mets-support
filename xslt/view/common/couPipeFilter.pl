while (<>) {

	my $in = $_;
	$in =~ s,^-,,;
	$in =~ m,^([a-z]*)\s+(.*),;
	print qq{<xsl:when test=" . = '$1'"><xsl:text>$2</xsl:text></xsl:when>\n};

}
