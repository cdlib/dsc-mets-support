<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:iso="http://www.loc.gov"
  exclude-result-prefixes="#all"
  xmlns:xtf="http://cdlib.org/xtf"
  xmlns:m="http://www.loc.gov/METS/"
  version="2.0">

<xsl:template name="insert-tracking">
    <xsl:param name="brand"/>
    <xsl:param name="onContent"/>
    <xsl:param name="tracking_institution"/>

    <!-- Matomo -->
    <script>
        var _paq = window._paq = window._paq || [];
        /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
        _paq.push(['setCustomDimension', customDimensionId=1, customDimensionValue='<xsl:value-of select="$brand"/>']);
        <xsl:if test="$tracking_institution != ''">
            _paq.push(['setCustomDimension', customDimensionId=2, customDimensionValue='<xsl:value-of select="$tracking_institution"/>']);
        </xsl:if>
        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);
        (function() {
            var u="//matomo.cdlib.org/";
            _paq.push(['setTrackerUrl', u+'matomo.php']);
            _paq.push(['setSiteId', '6']);
            var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
            g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
        })();
    </script>
    <!-- End Matomo Code -->
  </xsl:template>
</xsl:stylesheet>
