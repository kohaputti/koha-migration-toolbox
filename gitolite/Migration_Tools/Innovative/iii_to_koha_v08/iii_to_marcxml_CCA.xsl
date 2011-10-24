<?xml version="1.0" encoding="utf-8"?>
	<!-- insert mat type codes into leader 06 position (cca)-->
	<xsl:with-param name="mattype">             
		<xsl:value-of select="BIB/IIIRECORD/TYPEINFO/BIBLIOGRAPHIC/FIXFLD[FIXLABEL='MAT TYPE']/FIXVALUE" />
	</xsl:with-param>


		<!--add last updated date to 952 r, Date last seen field (cca)-->  
			<xsl:element name="subfield">

				</xsl:with-param>
				<xsl:with-param name="mattype">
				</xsl:with-param>
	<!-- send VOLUME (changed from VOL) and LOC DETAIL to volcombiner to combine into 952$h (cca)-->		
		<xsl:call-template name="volcombiner">		
			<xsl:with-param name="volume">
			</xsl:with-param>
	<!-- send NOTE and MESSAGE and DONOR fields into notecombiner to combine into 952$x (cca) -->
		 <xsl:call-template name="notecombiner">
				<xsl:with-param name="note2">
				</xsl:with-param>
				<xsl:with-param name="donor">
				</xsl:with-param>
		<xsl:for-each select="IIIRECORD/TYPEINFO/ITEM/FIXFLD">
<!--item call # create 952$o from (1) MARC 090 or (2) MARC 050 (cca) -->
		<xsl:for-each select="../BIB/IIIRECORD/VARFLD[MARCINFO/MARCTAG='090']">
				<xsl:element name="subfield">
				<xsl:attribute name="code">o</xsl:attribute>
				<xsl:for-each select="MARCSUBFLD">	
				</xsl:for-each>		
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="../BIB/IIIRECORD/VARFLD[MARCINFO/MARCTAG='050']">
				<xsl:element name="subfield">
				<xsl:attribute name="code">o</xsl:attribute>
				<xsl:for-each select="MARCSUBFLD">	
				</xsl:for-each>		
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="../BIB/IIIRECORD/VARFLD[MARCINFO/MARCTAG='099']">
				<xsl:element name="subfield">
				<xsl:attribute name="code">o</xsl:attribute>
				<xsl:for-each select="MARCSUBFLD">	
				</xsl:for-each>		
				</xsl:element>
			</xsl:for-each>
			</xsl:element>		
		</xsl:for-each>		
	<!--import material type into 942$t (cca)-->		
		<xsl:when test="$biblabel = 'MAT TYPE'">
				<xsl:value-of select="$bibvalue" /> 			
			</xsl:element>
<!--changed this to insert 'a' in the 9th space for unicode (cca)-->
<xsl:param name="mattype"/>
	<xsl:when test="$mattype = 's' or $mattype = '@' or $mattype = 'z' or $mattype = 'x' or $mattype = 'y' and $biblvl = 'e'">00000cps a2200000la 4500</xsl:when>
<xsl:when test="$mattype = 's' or $mattype = '@' or $mattype = 'z' or $mattype = 'x' or $mattype = 'y' and $biblvl != 'e'">00000cpm a2200000la 4500</xsl:when>
	<xsl:if test="$itemlabel = 'LOCATION'">
			<!-- withdrawn (cca) -->		
			<!-- suppress (cca) -->		

			<!-- keep in cat (cca) -->		
			<!-- keep for patron record (cca) -->		
			<!-- order rep (cca) -->		
			<!-- gone (cca) -->		
	<!-- this doesn't appear to do anything (cca)
			<xsl:if test="$itemvalue!='Small Press Traffic'">
				<xsl:element name="subfield">       
			</xsl:if> 
	<xsl:param name="mattype"/>
		<xsl:when test="$mattype = 'o'">KIT</xsl:when>
		<xsl:when test="$mattype = 'e'">MAP</xsl:when>
		<xsl:otherwise>BK</xsl:otherwise>

					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">
					<xsl:element name="subfield">

<!-- this combines VOLUME and LOC DETAIL into the 952$h -->
		<xsl:if test="$volume != '' or $locdetail != ''">			
			<xsl:element name="subfield">
					<xsl:if test="$volume != '' and $locdetail != ''">		
						<xsl:text>, </xsl:text>
					</xsl:if>
				<xsl:value-of select="$locdetail" />
		</xsl:if>  	                       
<!-- this combines MESSAGE and NOTE and DONOR into the 952$x -->
	<xsl:param name="note2" />
        <xsl:param name="donor" />
		<xsl:if test="$note != '' or $message != '' or $note2 != '' or $donor != ''">			
			<xsl:element name="subfield">
				<xsl:value-of select="$note" />
					<xsl:if test="$note != '' and $note2 != ''">
						<xsl:text>; </xsl:text>					
					</xsl:if>
				<xsl:value-of select="$note2" />
					<xsl:if test="($note != '' or $note2 != '') and $message !=''">
						<xsl:text>; </xsl:text>					
					</xsl:if>
					<xsl:if test="$message != ''">
						<xsl:text>msg: </xsl:text>
					</xsl:if>
				<xsl:value-of select="$message" />
					<xsl:if test="($note != '' or $note2 != '' or $message !='') and $donor !=''">
						<xsl:text>; </xsl:text>					
					</xsl:if>
					<xsl:if test="$donor != ''">
						<xsl:text>donor: </xsl:text>
					</xsl:if>
				<xsl:value-of select="$donor" />
		</xsl:if>  	                       