<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:opf="http://www.idpf.org/2007/opf"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="dc opf exsl">


<!-- Placeholder xsl:import instruction -->
<xsl:import href="DYNAMICALLY_UPDATED_PLACEHOLDER"/>


  <!-- Copy of gentext XML from core.xsl, with Recipe-specific handling added in -->
  <!-- Warning: any changes to core.xsl gentext will need to be replicated here -->
  <xsl:param name="local.l10n.xml" select="document('')"/>                      
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">                
    <l:l10n language="en">
      <l:gentext key="sect1" text="Recipe"/>
      <l:gentext key="section" text="Recipe"/>
      <l:gentext key="Section" text="Recipe"/>
      <!-- Just the heading text for XREFs to sects and sidebars -->
      <l:context name="xref">
	<l:template name="sect1" text="&#x201c;%t&#x201d;"/>
	<l:template name="sect2" text="&#x201c;%t&#x201d;"/>
	<l:template name="sect3" text="&#x201c;%t&#x201d;"/>
	<l:template name="sect4" text="&#x201c;%t&#x201d;"/>
	<l:template name="sect5" text="&#x201c;%t&#x201d;"/>
	<l:template name="section" text="&#x201c;%t&#x201d;"/>
	<l:template name="sidebar" text="&#x201c;%t&#x201d;"/>
	<l:template name="simplesect" text="&#x201c;%t&#x201d;"/>
      </l:context>
      <l:context name="xref-number">
	<l:template name="sect1" style="non-recipe" text="&#8220;%t&#8221;"/>
	<l:template name="sect1" style="rec-num-title" text="Recipe&#160;%n, &#8220;%t&#8221;"/>
	<!-- Below style used in series/hacks.xsl to do "Hack ##" style XREFs -->
	<l:template name="sect1" style="labelonly" text="%n"/>
	<l:template name="sect1" text="Recipe&#160;%n, &#8220;%t&#8221;"/>
	<l:template name="section" style="non-recipe" text="&#8220;%t&#8221;"/>
	<l:template name="section" style="rec-num-title" text="Recipe&#160;%n, &#8220;%t&#8221;"/>
	<!-- Below style used in series/hacks.xsl to do "Hack ##" style XREFs -->
	<l:template name="section" style="labelonly" text="%n"/>
	<l:template name="section" text="Recipe&#160;%n"/>
	<l:template name="chapter" style="chap-num-title" text="Chapter&#160;%n,&#160;%t"/>
  <l:template name="chapter" text="Chapter&#160;%n, %t"/>
	<l:template name="appendix" style="app-num-title" text="Appendix&#160;%n,&#160;%t"/>
	<l:template name="part" style="part-num-title" text="Part&#160;%n, %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
	<l:template name="sect1" text="Recipe&#160;%n, &#8220;%t&#8221;"/>
	<l:template name="section" text="Recipe&#160;%n, &#8220;%t&#8221;"/>
  <l:template name="chapter" text="Chapter&#160;%n, %t"/>
      </l:context>
      <l:context name="title">
	<!-- For custom Figure/Table/Example label handling; see
	     corresponding overrides in common/gentext.xsl 
	  -->
  <l:template name="chapter" style="chap-num-title" text="Chapter&#160;%n, %t"/>
	<l:template name="example" style="labelonly" text="Example %n. "/>
	<l:template name="figure" style="labelonly" text="Figure %n. "/>
	<l:template name="table" style="labelonly" text="Table %n. "/>
	<l:template name="example" style="titleonly" text="%t"/>
	<l:template name="figure" style="titleonly" text="%t"/>
	<l:template name="table" style="titleonly" text="%t"/>
      </l:context>
    </l:l10n>
  </l:i18n>




  <!-- Per AW, XREFs to sections/sidebars should include page numbers; others should not.  -->
<xsl:template match="xref" mode="class.value">
  <xsl:param name="class" select="local-name(.)"/>
  <!-- permit customization of class value only -->
  <!-- Use element name by default -->

  <!-- Get the target element (e.g., figure, table, section) and its name -->
  <xsl:variable name="target-element" select="id(@linkend)"/>
  <xsl:variable name="target-element-name" select="local-name(id(@linkend))"/>
  <xsl:value-of select="$class"/>
  <xsl:if test="not(normalize-space(substring-after(@xrefstyle, 'select:')) = 'nopage') and (($target-element-name = 'section') or ($target-element-name = 'sect1') or ($target-element-name = 'sect2') or ($target-element-name = 'sect3') or ($target-element-name = 'sect4') or ($target-element-name = 'sect5') or ($target-element-name = 'sidebar') or (normalize-space(substring-after(@xrefstyle, 'select:')) = 'page'))">
    <!-- Add @class value of "pagenum" to XREFs to sects, sidebars, and elements with xrefstyle of select:page...unless xrefstyle of select:nopage was used -->
    <xsl:text> pagenum</xsl:text>
  </xsl:if>
  <xsl:if test="$target-element[ancestor::preface]">
    <!-- Add @class value of "romannumeral" to XREFs to sects and sidebars if referenced content is in a preface -->
    <!-- ToDo: Consider parameterizing this handling if there are certain series that don't use roman-numeral page numbering for Preface -->
    <xsl:text> romannumeral</xsl:text>
  </xsl:if>
</xsl:template>



</xsl:stylesheet>