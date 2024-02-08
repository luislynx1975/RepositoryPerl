ndex: exe/Makefile.am
===================================================================
--- exe/Makefile.am
+++ exe/Makefile.am
@@ -60,8 +60,10 @@ dltest_DEPENDENCIES = $(LTDLDEPS)
 dltest_LDADD = $(LIBLTDL)
 
 all-am:
-	@sed -i -e "s![@]ODBC_ULEN[@]!`$(CURDIR)/odbc_config$(EXEEXT) --ulen`!" \
-		-e "s![@]ODBC_CFLAGS[@]!`$(CURDIR)/odbc_config$(EXEEXT) --cflags | sed 's/ -I.*//'`!" \
-		$(top_builddir)/DriverManager/odbc.pc
-
+	@sed "s![@]ODBC_ULEN[@]!`$(CURDIR)/odbc_config$(EXEEXT) --ulen`!" \
+	  $(top_builddir)/DriverManager/odbc.pc > $(CURDIR)/odbc.pc.tmp
+	@mv $(CURDIR)/odbc.pc.tmp $(top_builddir)/DriverManager/odbc.pc
+	@sed "s![@]ODBC_CFLAGS[@]!`$(CURDIR)/odbc_config$(EXEEXT) --cflags | sed 's/ -I.*//'`!" \
+	  $(top_builddir)/DriverManager/odbc.pc > $(CURDIR)/odbc.pc.tmp
+	@mv $(CURDIR)/odbc.pc.tmp $(top_builddir)/DriverManager/odbc.pc
