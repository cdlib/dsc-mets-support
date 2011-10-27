<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:iso="http://www.loc.gov"
  exclude-result-prefixes="#all"
  xmlns:xtf="http://cdlib.org/xtf"
  xmlns:m="http://www.loc.gov/METS/"
  version="2.0">

<xsl:template name="insert-google-tracking">
    <xsl:param name="brand"/>
    <xsl:param name="onContent"/>
    <xsl:param name="google_analytics_tracking_code"/>
    <script>
<xsl:comment>
var _gaq = _gaq || [];
_gaq.push( ['_gat._anonymizeIp'], ['cst._setAccount', 'UA-438369-1']);
_gaq.push(['cst._trackPageLoadTime']);
_gaq.push(['cst._setCustomVar', 1, 'brand', '<xsl:value-of select="$brand"/>', 3 ]);

      <xsl:if test="$google_analytics_tracking_code != ''">
_gaq.push( ['contrib._setAccount', '<xsl:value-of select="$google_analytics_tracking_code"/>'] );
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$onContent='onContent'">
/* page can be served via reverse proxy from multiple hosts */
if (window.location.host.indexOf("calisphere") != -1) { // .contains http://stackoverflow.com/questions/1789945/
  _gaq.push( ['cst._setAllowHash', false], ['cst._trackPageview'], ['cst._setAllowLinker', true]);
} else {
  _gaq.push( ['cst._setDomainName', 'none'], ['cst._setAllowLinker', true], ['cst._trackPageview']);
  $("a[href^='http://www.calisphere']").click(function () {
    _gaq.push(['_link', this.href]);
  });
} 
          </xsl:when>
          <xsl:otherwise>
  _gaq.push( ['cst._setDomainName', 'none'], ['cst._setAllowLinker', true], ['cst._trackPageview']);
          </xsl:otherwise>
      </xsl:choose>
// google async load
(function() {
    var ga = document.createElement('script');     ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:'   == document.location.protocol ? 'https://ssl'   : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    var href = window.location.href;
})();
</xsl:comment>
</script>
  </xsl:template>

</xsl:stylesheet>
