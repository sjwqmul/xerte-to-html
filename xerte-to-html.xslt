<?xml version="1.0" encoding="UTF-8"?>
<!--
    The MIT License (MIT)

Copyright (c) 2015 Steve Welburn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
    
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0">
    <xsl:preserve-space elements="nestedPage"/>
    <xsl:output indent="no" method="html"/>
    
    <xsl:param name="FileLocation"/>
    
    <!-- Setup the basic skeleton -->
    <xsl:template match="/">
        <html><xsl:text>&#xa;</xsl:text>
            <head><xsl:text>&#xa;</xsl:text>
                <title><xsl:value-of select="learningObject/@name" disable-output-escaping="yes"/></title><xsl:text>&#xa;</xsl:text>
                <xsl:comment>Style for proportionally spaced info. with embedded line breaks</xsl:comment><xsl:text>&#xa;</xsl:text>
                <style><xsl:text>&#xa;</xsl:text>
                p.prop {
                    display: block;
                    font-family: times;
                    white-space: pre-line;
                }
                .bordered {
                    border: 1px solid black;
                    border-collapse: collapse;
                }
                </style><xsl:text>&#xa;</xsl:text>
            </head><xsl:text>&#xa;</xsl:text>
            <body><xsl:text>&#xa;</xsl:text>
                <xsl:apply-templates/><xsl:text>&#xa;</xsl:text>
            </body><xsl:text>&#xa;</xsl:text>
        </html><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process main Learning Object -->
    <xsl:template match="learningObject">
        <H1><xsl:value-of select="./@name" disable-output-escaping="yes"/></H1><xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/><xsl:text>&#xa;</xsl:text>
    </xsl:template>
       
    <!-- Process bullet points -->
    <xsl:template match="bullets">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <ul><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="text()"/>
            <xsl:with-param name="pElement" select="'li'"/>
        </xsl:call-template>
        </ul><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process text blocks -->
    <xsl:template match="text">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="text()"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Process textGraphics blocks -->
    <xsl:template match="textGraphics">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="addImage">
            <xsl:with-param name="pPath" select="./@url"/>
            <xsl:with-param name="pTip" select="./@tip"/>
        </xsl:call-template>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="text()"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process YouTube video -->
    <xsl:template match="youtube">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <youtube><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
        <p>
        <xsl:value-of select="." disable-output-escaping="yes"/>
        </p>
        </youtube><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process Wiki content -->
    <xsl:template match="wiki">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <wiki><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
        <p>
        <xsl:text>URL: </xsl:text><xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="./@url" disable-output-escaping="yes"/></xsl:attribute>
            <xsl:value-of select="./@url" disable-output-escaping="yes"/>
        </xsl:element>
        </p>
        </wiki><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process an embedded page -->
    <xsl:template match="embedDiv">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <embedDiv><xsl:text>&#xa;</xsl:text>
        <p>
        URL: <xsl:value-of select="./@src" disable-output-escaping="no"/>
        </p>
        </embedDiv><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process morph images -->
    <xsl:template match="morphImages">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <morphimages><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <p>
        <xsl:value-of select="." disable-output-escaping="yes"/>
        </p>
        </morphimages><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process tabNav -->
    <xsl:template match="tabNav">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <tabnav><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <p>
        <xsl:value-of select="." disable-output-escaping="yes"/>
        </p>
        <xsl:apply-templates select="nestedPage"/>
        </tabnav>
    </xsl:template>
    
    <!-- Process Multiple Choice Activity -->
    <xsl:template match="mcq">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <mcq><xsl:text>&#xa;</xsl:text>
        <table>
            <td width="20%">
        <p><xsl:value-of select="./@instruction" disable-output-escaping="yes"/></p><xsl:text>&#xa;</xsl:text>
        </td>
        <td>
        <H3><xsl:value-of select="./@prompt" disable-output-escaping="yes"/></H3><xsl:text>&#xa;</xsl:text>
        <table class="bordered">
            <tr><th width="20%" class="bordered">Text</th><th width="70%" class="bordered">Feedback</th><th width="10%" class="bordered">Correct</th></tr>
            <xsl:apply-templates select="option"/>
        </table>
        </td>
        </table>
        <p>[[Type: <xsl:value-of select="./@type" disable-output-escaping="yes"/>]]</p><xsl:text>&#xa;</xsl:text>
<!--        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
-->     </mcq><xsl:text>&#xa;</xsl:text>
        
    </xsl:template>
    
    <!-- Process Multiple Choice Options -->
    <xsl:template match="mcq/option">
        <tr><xsl:text>&#xa;</xsl:text>
        <td class="bordered"><xsl:value-of select="./@text" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td class="bordered"><xsl:value-of select="./@feedback" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td class="bordered"><xsl:value-of select="./@correct" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        </tr><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process Hotspot Image -->
    <xsl:template match="hotspotImage">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <hotspotImage><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pSeparator" select="'&#xA;'"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <xsl:call-template name="addImage">
            <xsl:with-param name="pPath" select="./@url"/>
            <xsl:with-param name="pTip" select="./@tip"/>
        </xsl:call-template>
        <table><xsl:text>&#xa;</xsl:text>
            <tr><th>Name</th><th>Text</th></tr><xsl:text>&#xa;</xsl:text>
            <xsl:apply-templates select="hotspot"/>
        </table><xsl:text>&#xa;</xsl:text>
        </hotspotImage><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process Image Hotspots -->
    <xsl:template match="hotspotImage/hotspot">
        <tr><xsl:text>&#xa;</xsl:text>
        <td><xsl:value-of select="./@name" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td><xsl:value-of select="./@text" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        </tr><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Process Dialog -->
    <xsl:template match="dialog">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <hotspotImage><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pSeparator" select="'&#xA;'"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <table class="bordered"><xsl:text>&#xa;</xsl:text>
            <tr><th class="bordered">Question</th><th class="bordered">Answer</th><th class="bordered">Hint</th></tr><xsl:text>&#xa;</xsl:text>
            <xsl:apply-templates select="dialogStep"/>
        </table><xsl:text>&#xa;</xsl:text>
        </hotspotImage><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process Dialog Steps -->
    <xsl:template match="dialog/dialogStep">
        <tr><xsl:text>&#xa;</xsl:text>
        <td width="40%" class="bordered"><xsl:value-of select="./@question" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td width="20%" class="bordered"><xsl:value-of select="./@answer" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td width="40%" class="bordered"><xsl:value-of select="./@hint" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        </tr><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Process Categories Activity -->
    <xsl:template match="categories">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <categories><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pSeparator" select="'&#xA;'"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        <table><xsl:text>&#xa;</xsl:text>
            <tr><th width="25%">Category Name</th><th width="75%">Items</th></tr><xsl:text>&#xa;</xsl:text>
            <xsl:apply-templates select="category"/>
        </table><xsl:text>&#xa;</xsl:text>
        </categories><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process individual Categories -->
    <xsl:template match="categories/category">
        <tr><xsl:text>&#xa;</xsl:text>
        <td><xsl:value-of select="./@name" disable-output-escaping="yes"/></td><xsl:text>&#xa;</xsl:text>
        <td><xsl:apply-templates select="item"/></td><xsl:text>&#xa;</xsl:text>
        </tr><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process items within individual Categories -->
    <xsl:template match="categories/category/item">
        <xsl:value-of select="./@name" disable-output-escaping="yes"/><br/><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process buttonQuestion -->
    <xsl:template match="buttonQuestion">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <buttonQuestion><xsl:text>&#xa;</xsl:text>
        <h3>Instructions</h3>
        <xsl:value-of select="./@instruction" disable-output-escaping="yes"/><br/><xsl:text>&#xa;</xsl:text>
        <h3>Prompt</h3>
        <xsl:value-of select="./@prompt" disable-output-escaping="yes"/><br/><xsl:text>&#xa;</xsl:text>
        <h3>Feedback</h3>
        <xsl:value-of select="./@feedback" disable-output-escaping="yes"/><br/><xsl:text>&#xa;</xsl:text>
 <!--        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
-->        </buttonQuestion><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Process columnPage -->
    <xsl:template match="columnPage">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <columnPage><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
        <xsl:apply-templates select="nestedPage"/>
        </columnPage><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process list -->
    <xsl:template match="list">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <list><xsl:text>&#xa;</xsl:text>
        <listheader><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'listitem'"/>
        </xsl:call-template>
        </listheader><xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="nestedPage"/>
        </list><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process bleedingImage blocks -->
    <xsl:template match="bleedingImage">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="addImage">
            <xsl:with-param name="pPath" select="./@url"/>
            <xsl:with-param name="pTip" select="./@tip"/>
        </xsl:call-template>
        <bleedingImage><xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="text()"/>
            <xsl:with-param name="pElement" select="'p'"/>
        </xsl:call-template>
        </bleedingImage><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Process gapFill activity -->
    <xsl:template match="gapFill">
        <H2><xsl:value-of select="./@name" disable-output-escaping="yes"/></H2><xsl:text>&#xa;</xsl:text>
        <gapFill><xsl:text>&#xa;</xsl:text>
        <table>
        <tr><th>Text:</th><td><xsl:value-of select="./@text" disable-output-escaping="yes"/></td></tr><xsl:text>&#xa;</xsl:text>
        <tr><th>Passage:</th><td><xsl:value-of select="./@passage" disable-output-escaping="yes"/></td></tr><xsl:text>&#xa;</xsl:text>
        <tr><th>Feedback:</th><td><xsl:value-of select="./@feedback" disable-output-escaping="yes"/></td></tr><xsl:text>&#xa;</xsl:text>
        </table>
<!--        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="./@text"/>
            <xsl:with-param name="pElement" select="'narration'"/>
        </xsl:call-template>
-->        </gapFill><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process nested pages -->
    <xsl:template match="nestedPage">
        <H3><xsl:value-of select="./@name" disable-output-escaping="yes"/></H3><xsl:text>&#xa;</xsl:text>
        <xsl:if test='./@name = "image"'>
            <xsl:call-template name="addImage">
                <xsl:with-param name="pPath" select="./@url"/>
                <xsl:with-param name="pTip" select="''"/>
            </xsl:call-template>
        </xsl:if>
        <page><xsl:text>&#xa;</xsl:text>
        <!--
        <pre>
        <xsl:value-of select="./@text" disable-output-escaping="yes"/>
        </pre>
        -->
        <xsl:apply-templates select="./@text"/>
        </page><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Process nested page text -->
    <xsl:template match="nestedPage/@text">
        <!--
        <xsl:call-template name="splitText">
            <xsl:with-param name="pText" select="."/>
            <xsl:with-param name="pElement" select="'p'"/>
            <xsl:with-param name="pSeparator" select="'&#xA;'"/>
        </xsl:call-template>
        <br/>
        -->
        <xsl:call-template name="textBlock">
            <xsl:with-param name="pText" select="."/>
        </xsl:call-template>
        <!--
        <pre>
        <xsl:value-of select="." disable-output-escaping="yes"/>
        </pre>
        -->
    </xsl:template>
    

    <!-- Process an image -->
    <xsl:template name="addImage">
        <xsl:param name="pPath" select="''"/>
        <xsl:param name="pTip" select="''"/>
        <p>Tip: <xsl:value-of select="$pTip" disable-output-escaping="yes"/></p><xsl:text>&#xa;</xsl:text>
        <p>Image location: <xsl:value-of select="$pPath" disable-output-escaping="yes"/></p><xsl:text>&#xa;</xsl:text>
        <p>
        <xsl:element name="img">
            <xsl:attribute name="width">
                <xsl:text>50%</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="src">
                <xsl:value-of select="$FileLocation" disable-output-escaping="yes"/>
                <xsl-text>/</xsl-text>
                <xsl:value-of select='translate(substring-after($pPath, "FileLocation + "), "&apos;", "")'/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select='$pTip'/>
            </xsl:attribute>
        </xsl:element>
        </p><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <!-- Process newlines -->
    <xsl:template name="textBlock">
        <xsl:param name="pText" select="."/>
        <xsl:param name="pElement" select="'textblock'"/>
        <xsl:param name="pSeparator" select="'&#xA;&#xA;'"/>
        <xsl:element name="{$pElement}"><xsl:text>&#xa;</xsl:text>
        <xsl:element name="p">
        <xsl:attribute name="class"><xsl:text>prop</xsl:text></xsl:attribute>
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="normalize-space($pText)" disable-output-escaping="yes"/><xsl:text>&#xa;</xsl:text>
        </xsl:element>
        </xsl:element><xsl:text>&#xa;</xsl:text>
    </xsl:template>
 
    <!-- Process newlines -->
    <xsl:template name="splitText">
        <xsl:param name="pText" select="."/>
        <xsl:param name="pElement" select="'textblock'"/>
        <xsl:param name="pSeparator" select="'&#xA;&#xA;'"/>
        <xsl:choose>
            <xsl:when test="not(contains($pText, $pSeparator))">
                <xsl:element name="{$pElement}">
                <xsl:value-of select="normalize-space($pText)" disable-output-escaping="yes"/></xsl:element>
                <xsl:text>&#xa;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$pElement}">
                <xsl:value-of select="normalize-space(substring-before($pText, $pSeparator))"  disable-output-escaping="yes"/></xsl:element>
                <xsl:text>&#xa;</xsl:text><xsl:call-template name="splitText">
                    <xsl:with-param name="pText" select="substring-after($pText, $pSeparator)"/>
                    <xsl:with-param name="pElement" select="$pElement"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 </xsl:stylesheet>
