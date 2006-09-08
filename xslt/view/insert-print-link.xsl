<xsl:stylesheet
   version="2.0"
   xmlns:view="http://www.cdlib.org/view"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:mets="http://www.loc.gov/METS/"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:m="http://www.loc.gov/METS/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all"  >

<xsl:param name="http.URL"/>

<xsl:template match="insert-print-links">
<xsl:comment>insert-print-links @shape: <xsl:value-of select="@shape"/></xsl:comment>
<xsl:comment><xsl:value-of select="static-base-uri()"/></xsl:comment>
<xsl:variable name="inCgiString" select="replace(substring-after($http.URL,'?'),'&amp;?layout=[^&amp;]*','')"/>
<xsl:variable name="printableCgi">
		<xsl:value-of select="$inCgiString"/>
		<xsl:text>&amp;layout=printable</xsl:text>
</xsl:variable>

<xsl:choose><!-- to layout options @shape="wide" or its not -->
 <!-- MOA2 extracted from EAD don't get the print link -->
 <xsl:when test="contains($page/m:mets/@PROFILE, 'kt3q2nb7vz') and $MOA2 = 'MOA2'"/>
 <xsl:when test="@shape='wide'">
  <div id="print-control" class="nifty4">
            <div class="box4">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <td align="left" valign="middle">
<xsl:copy-of select="$brand.print.img"/>
                  </td>
                  <td align="left" valign="middle">
                    <div class="button nifty6">
                      <div class="box6">
                        <a href="?{$printableCgi}">image only</a>
                      </div>
                    </div>
                  </td>
                  <td align="left" valign="middle">
                    <div class="button nifty6">
                      <div class="box6">
                        <a href="?{$printableCgi}-details">image with details</a>
                      </div>
                    </div>
                  </td>
                </tr>
              </table>
            </div>
          </div>
 </xsl:when>
 <xsl:otherwise>
          <div id="print-control">
            <div class="nifty4">
              <div class="box4">
                <img src="http://dali.cdlib.org/~esatzman/calisphere/dev/images/headings_text/printable_version.gif" width="110" height="16" alt="Printable Version" title="Printable Version" />
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="middle">
                      <div class="button">
                        <div class="nifty6">
                          <div class="box6">
                            <a href="?{$printableCgi}">image only</a>
                          </div>
                        </div>
                      </div>
                    </td>
                    <td align="left" valign="middle">
                      <div class="button">
                        <div class="nifty6">
                          <div class="box6">
                            <a href="?{$printableCgi}-details">image with details</a>
                          </div>
                        </div>
                      </div>
                    </td>
                  </tr>
                </table>
              </div>
            </div>
          </div>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="insert-printable-credit">
<xsl:if test="($page/mets:mets/publisher[@xtf:meta])[1]">
<div class="publisher">
Courtesy of <xsl:value-of select="($page/mets:mets/publisher[@xtf:meta])[1]"/>
</div>
</xsl:if>
<div class="identifier">
<xsl:value-of 
   select="replace(($page/mets:mets/identifier[@xtf:meta])[1]
		,'^http://ark.cdlib.org/','http://content.cdlib.org/')"/>
<xsl:if test="$brand">
	<xsl:text>/?brand=</xsl:text>
          <xsl:value-of select="$brand"/>
</xsl:if>
</div>
</xsl:template>

</xsl:stylesheet>
