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
<xsl:param name="zoomBase.value"/>
<xsl:param name="zoomOn.value"/> 
<xsl:template name="jsod-printable-metadata">
<xsl:variable name="credit"><xsl:call-template name="insert-printable-credit"/></xsl:variable>
<xsl:variable name="label">
	<xsl:choose>
		<xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'thumbnail')][1]/m:file) &gt; 1">
 			<xsl:value-of select="key('divByOrder', $order)/@LABEL"/>
			<xsl:text> / </xsl:text>
 			<xsl:value-of select="if ($page/m:mets) then $page/m:mets/@LABEL else $page/TEI.2/m:mets/@LABEL"/>
		</xsl:when>
		<xsl:otherwise>
 			<xsl:value-of select="if ($page/m:mets) then $page/m:mets/@LABEL else $page/TEI.2/m:mets/@LABEL"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
/* metadata via javascript on demand */
function populateMetadata() {

	document.title =  '<xsl:value-of select='replace( normalize-space($label), "&apos;" , "\\&apos;" )'/>';
	var metadata  = YAHOO.util.Dom.get('printable-description');
	// var insertCredit  = YAHOO.util.Dom.get('insertCredit');
	var string = '<xsl:apply-templates select="$credit" mode="xmlInJs"/>';
  string += '<![CDATA[</div>]]>';
	if (metadata) metadata.innerHTML = string;
	// insertCredit.innerHTML = '<![CDATA[<div class="publisher">Courtesy of ]]><xsl:value-of select="($page/mets:mets/publisher[@xtf:meta])[1] | ($page/../TEI.2/xtf:meta/publisher)[1]"/><![CDATA[</div>]]>';
}
</xsl:template>

<xsl:template match="*" mode="xmlInJs">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:apply-templates select="@*" mode="xmlInJs"/>
	<xsl:text>&gt;</xsl:text>
	<xsl:apply-templates select="*|text()" mode="xmlInJs"/>
	<xsl:text>&lt;/</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="@*" mode="xmlInJs">
	<xsl:text> </xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>=&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="xmlInJs">
	<xsl:value-of select='normalize-space(replace(.,"&apos;","\\&apos;"))'/>
</xsl:template>

<xsl:template name="single-image-zoom">
	<xsl:if test="(($page/mets:mets/format = 'jp2') or ($page/format = 'jp2')) and ($zoomOn.value = 'yes')">
<script type="text/javascript">
<xsl:comment>
	document.getElementById('zoomMe').href =
    "<xsl:value-of select="$zoomBase.value"/>Fullscreen.ics?ark=<xsl:value-of select="$page/mets:mets/@OBJID"/>/z1&amp;<xsl:value-of select="$brandCgi"/>";
</xsl:comment>
</script>
</xsl:if>
</xsl:template>

<xsl:template match="insert-print-links">
<xsl:if test="(($page/mets:mets/format = 'jp2') or ($page/format = 'jp2')) and ($zoomOn.value = 'yes')">
<script type="text/javascript">
<xsl:comment>
	document.getElementById('clicktext').innerHTML = 'Click image to zoom';
</xsl:comment>
</script>
</xsl:if>

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
 <!-- test for pdf -->
 <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'application')]/m:file[@MIMETYPE='application/pdf']) = 1"/>
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

<xsl:template match="insert-printable-credit" name="insert-printable-credit">
<xsl:if test="($page/mets:mets/publisher[@xtf:meta])[1] | ($page/../TEI.2/xtf:meta/publisher)[1] | ($page/TEI.2/xtf:meta/publisher)[1]">
<div class="publisher">
Courtesy of <xsl:value-of select="($page/mets:mets/publisher[@xtf:meta])[1] | ($page/../TEI.2/xtf:meta/publisher)[1] | ($page/TEI.2/xtf:meta/publisher)[1]"/>
</div>
</xsl:if>
<div class="identifier">

<xsl:value-of 
   select="replace(($page/mets:mets/identifier[@xtf:meta] | $page/../TEI.2/xtf:meta/identifier)[1] | ($page/TEI.2/xtf:meta/identifier)[1]
		,'^http://ark.cdlib.org/','http://content.cdlib.org/')"/>
<xsl:if test="$brand">
	<xsl:text>/?brand=</xsl:text>
          <xsl:value-of select="$brand"/>
</xsl:if>
</div>
</xsl:template>

</xsl:stylesheet>
