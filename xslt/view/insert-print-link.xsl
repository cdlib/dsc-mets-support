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
<xsl:param name="creditExperiment.on"/>
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
	var string = '<xsl:apply-templates select="$credit" mode="xmlInJs"/>';
  string += '<![CDATA[</div>]]>';
	if (metadata) metadata.innerHTML = string;
}

<xsl:call-template name="insert-tracking">
  <xsl:with-param name="brand" select="$brand"/>
  <xsl:with-param name="onContent" select="'onContent'"/>
  <xsl:with-param name="tracking_institution" select="$page/m:mets/facet-institution"/>
</xsl:call-template>
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

<xsl:template match="*:p[@id='clicktext']">
  <xsl:choose>
    <xsl:when test="$creditExperiment.on='on'">
<p>
http://content.cdlib.org/<xsl:value-of select="$page/m:mets/@OBJID"/> courtesy of <xsl:call-template name="insert-good-institution-name"/>
</p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
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
 <xsl:when test="$page/m:mets/@PROFILE='pamela://year1' and lower-case($page/m:mets/@TYPE)='sound'">
  <xsl:call-template name="audio-link"/>
 </xsl:when>
 <xsl:when test="$page/m:mets/@PROFILE='pamela://year1'">
  <xsl:call-template name="video-link"/>
 </xsl:when>
 <xsl:when test="contains($page/m:mets/@PROFILE, 'kt3q2nb7vz') and $MOA2 = 'MOA2'"/>
 <!-- test for pdf -->
 <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'application')]/m:file[@MIMETYPE='application/pdf']) = 1"/>
 <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'reference')]/m:file[@MIMETYPE='application/pdf']) = 1"/>
 <xsl:when test="$page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'Application-PDF')] "/>
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
                        <a href="?{$printableCgi}" 
onclick="_gaq.push(['cst._trackEvent', 'print-links', 'image only', window.title ]);"
                        >image only</a>
                      </div>
                    </div>
                  </td>
                  <td align="left" valign="middle">
                    <div class="button nifty6">
                      <div class="box6">
                        <a href="?{$printableCgi}-details"
onclick="_gaq.push(['cst._trackEvent', 'print-links', 'image with details', window.title ]);"
                         >image with details</a>
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
                <img src="/default/images/icons/headings_text/printable_version.gif" width="110" height="16" alt="Printable Version" title="Printable Version" />
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="middle">
                      <div class="button">
                        <div class="nifty6">
                          <div class="box6">
                            <a href="?{$printableCgi}"
onclick="_gaq.push(['cst._trackEvent', 'print-links', 'image only', window.title ]);"
                            >image only</a>
                          </div>
                        </div>
                      </div>
                    </td>
                    <td align="left" valign="middle">
                      <div class="button">
                        <div class="nifty6">
                          <div class="box6">
                            <a href="?{$printableCgi}-details"
onclick="_gaq.push(['cst._trackEvent', 'print-links', 'image with details', window.title ]);"
                            >image with details</a>
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

<xsl:template name="video-link">
                <div id="print-control">
                   <div class="nifty4">
                      <div class="box4" style="padding-left: 1em;">
 <p><a href="/{$page/m:mets/@OBJID}/?layout=printable-details{if($brand!='calisphere') then concat('&amp;brand=',$brand) else ''}">view video</a></p>
                      </div>
                   </div>
                </div>
</xsl:template>
<xsl:template name="audio-link">
                <div id="print-control">
                   <div class="nifty4">
                      <div class="box4" style="padding-left: 1em;">audio file</div>
                   </div>
                </div>
</xsl:template>


<xsl:template match="insert-printable-credit" name="insert-printable-credit">
  <xsl:variable name="facet-institution" 
    select="($page/mets:mets/facet-institution | $page/TEI.2/xtf:meta/facet-institution )"
  />
  <xsl:choose>
    <xsl:when test="$facet-institution">
      <div class="publisher">
        Courtesy of <xsl:value-of select="replace($facet-institution,'::',', ')"/>
      </div>
    </xsl:when>
    <xsl:otherwise><xsl:if test="($page/mets:mets/publisher[@xtf:meta])[1] | ($page/../TEI.2/xtf:meta/publisher)[1] | ($page/TEI.2/xtf:meta/publisher)[1]">
<div class="publisher">
Courtesy of <xsl:value-of select="($page/mets:mets/publisher[@xtf:meta])[1] | ($page/../TEI.2/xtf:meta/publisher)[1] | ($page/TEI.2/xtf:meta/publisher)[1]"/>
</div>
    </xsl:if></xsl:otherwise>
  </xsl:choose>
<div class="identifier">

<xsl:variable name="url-pre">
<xsl:value-of select="normalize-space(replace(($page/mets:mets/identifier[@xtf:meta] | $page/../TEI.2/xtf:meta/identifier)[1] | ($page/TEI.2/xtf:meta/identifier)[1] ,'^http://ark.cdlib.org/','http://content.cdlib.org/'))"/>
<xsl:value-of select="if ($order) then concat('/?order=',$order) else ''"/>
</xsl:variable>

<xsl:variable name="url">
  <xsl:choose>
    <xsl:when test="$brand = 'oac4'">
<xsl:value-of select="replace($url-pre,'content.cdlib.org','www.oac.cdlib.org')"/>
    </xsl:when>
    <xsl:otherwise>
<xsl:value-of select="$url-pre"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<a href="{$url}"><xsl:value-of select="$url"/></a>

</div>
</xsl:template>

<xsl:template name="insert-good-institution-name">
  <xsl:choose>
    <xsl:when test="$brand='calisphere'">
        <xsl:call-template name="insert-good-institution-url"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:call-template name="insert-good-institution-name-orig"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="insert-good-institution-url" name="insert-good-institution-url">
  <xsl:variable name="facet-institution"
    select="($page/mets:mets/facet-institution | $page/TEI.2/xtf:meta/facet-institution )"
  />
  <xsl:variable 
    name="url" 
    select="$page/mets:mets/institution-url | $page/TEI.2/xtf:meta/institution-url" />
  <xsl:choose>
    <xsl:when test="$facet-institution or $url!=''">
      <a href="{if ($facet-institution and $brand='calisphere') 
                then replace(concat('http://',System:getenv('PUBLICDL_HOSTNAME'),'/institutions/',$facet-institution),' ','+') 
                else $url}" xmlns:System="java:java.lang.System">
        <xsl:call-template name="insert-good-institution-name-orig"/>
      </a>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="insert-good-institution-url" name="insert-good-institution-name-orig">
  <xsl:variable name="facet-institution"
    select="($page/mets:mets/facet-institution | $page/TEI.2/xtf:meta/facet-institution )"
  />
  <xsl:choose>
    <xsl:when test="$facet-institution">
        <xsl:value-of select="replace($facet-institution,'::',', ')"/>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
